import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'package:aldo_portfolio/widgets/shared/project_card.dart';
import 'helpers.dart';

/// ProjectsSection vive dentro de un CustomScrollView/SliverList que
/// construye de forma perezosa solo lo cercano al viewport: hay que
/// desplazarse manualmente hasta que aparezca antes de poder contar
/// sus tarjetas. No se usa pumpAndSettle (el timer del hero es perpetuo).
Future<void> _scrollUntilProjectCardsAppear(WidgetTester tester) async {
  final scrollable = tester.state<ScrollableState>(find.byType(Scrollable).first);
  for (int i = 0; i < 20 && find.byType(ProjectCard).evaluate().isEmpty; i++) {
    scrollable.position.jumpTo(scrollable.position.pixels + 300);
    await tester.pump(const Duration(milliseconds: 50));
  }
  // Drena las animaciones de entrada de ScrollReveal (delay + 500ms) para
  // que no queden Future.delayed/AnimationController pendientes al terminar.
  await tester.pump(const Duration(milliseconds: 700));
}

void main() {
  test('hay exactamente 3 proyectos, backend primero', () {
    expect(PortfolioData.projects.length, 3);
    expect(PortfolioData.projects[0].name, 'Institutional Email Automation Platform');
    expect(PortfolioData.projects[1].name, 'Food Match');
    expect(PortfolioData.projects[2].name, 'Elektra Shopping Cart');
  });

  test('ningún proyecto enlaza a un repositorio no público', () {
    for (final p in PortfolioData.projects) {
      if (p.githubUrl == null) {
        expect(p.note, isNotNull,
            reason: '${p.name}: sin githubUrl debe tener note');
      }
    }
  });

  testWidgets('escritorio renderiza los 3 proyectos sin RangeError', (tester) async {
    // visibility_detector debounce su chequeo cada 500ms por defecto; en
    // modo test eso deja timers pendientes al hacer scroll. Recomendación
    // oficial del paquete: updateInterval = Duration.zero en tests.
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    await pumpPortfolio(tester, size: const Size(1400, 900));
    await _scrollUntilProjectCardsAppear(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(ProjectCard), findsNWidgets(3));
  });

  testWidgets('móvil renderiza los 3 proyectos', (tester) async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    await pumpPortfolio(tester, size: const Size(420, 900));
    await _scrollUntilProjectCardsAppear(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(ProjectCard), findsNWidgets(3));
  });
}
