import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'helpers.dart';

/// About vive dentro de un CustomScrollView/SliverList perezoso, cerca del
/// final: no se monta con solo pumpPortfolio. Hay que desplazarse hasta el
/// fondo antes de poder aseverar sobre su contenido. No se usa pumpAndSettle
/// (el cursor del hero es un Timer.periodic perpetuo).
Future<void> _scrollToAbout(WidgetTester tester) async {
  final scrollable = tester.state<ScrollableState>(find.byType(Scrollable).first);
  for (int i = 0; i < 40; i++) {
    final pos = scrollable.position;
    if (pos.pixels >= pos.maxScrollExtent) break;
    pos.jumpTo(
      (pos.pixels + 400).clamp(0.0, pos.maxScrollExtent),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  // Drena las animaciones de entrada de ScrollReveal (delay + 500ms).
  await tester.pump(const Duration(milliseconds: 700));
}

void main() {
  testWidgets('la foto de Aldo se renderiza', (tester) async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    await pumpPortfolio(tester);
    await _scrollToAbout(tester);
    final assets = tester
        .widgetList<Image>(find.byType(Image))
        .map((i) => i.image)
        .whereType<AssetImage>()
        .map((a) => a.assetName);
    expect(assets, contains('assets/img/Aldo.jpg'));
  });

  testWidgets('no anuncia una graduación futura que ya pasó', (tester) async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    await pumpPortfolio(tester);
    await _scrollToAbout(tester);
    // Sonda de que About sí se montó: la fecha corregida debe estar presente.
    expect(find.textContaining('Graduated'), findsOneWidget);
    expect(find.textContaining('Graduating'), findsNothing);
  });
}
