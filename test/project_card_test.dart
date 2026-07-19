import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'package:aldo_portfolio/theme/app_theme.dart';
import 'package:aldo_portfolio/widgets/shared/project_card.dart';

const _sample = Project(
  icon: '🍔',
  name: 'Food Match',
  period: '2026',
  summary: 'Summary line.',
  role: 'Solo developer',
  highlights: ['Built a Node.js/Express backend.'],
  stack: [
    StackLayer('Mobile', ['Flutter']),
    StackLayer('Backend', ['Node.js', 'Express']),
  ],
  githubUrl: null,
  note: 'Private repository',
);

Future<void> _pumpCard(
  WidgetTester tester, {
  required bool expanded,
  VoidCallback? onTap,
}) async {
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.theme,
    home: Scaffold(
      body: ProjectCard(
        project: _sample,
        expanded: expanded,
        onTap: onTap ?? () {},
      ),
    ),
  ));
}

void main() {
  testWidgets('cerrada muestra nombre y summary', (tester) async {
    await _pumpCard(tester, expanded: false);
    expect(find.text('Food Match'), findsOneWidget);
    expect(find.text('Summary line.'), findsOneWidget);
  });

  testWidgets('cerrada NO muestra highlights ni role', (tester) async {
    await _pumpCard(tester, expanded: false);
    expect(find.text('Solo developer'), findsNothing);
    expect(find.textContaining('Node.js/Express backend'), findsNothing);
  });

  testWidgets('abierta muestra role, highlights y capas de stack', (tester) async {
    await _pumpCard(tester, expanded: true);
    await tester.pumpAndSettle();
    expect(find.text('Solo developer'), findsOneWidget);
    expect(find.textContaining('Node.js/Express backend'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Backend'), findsOneWidget);
  });

  testWidgets('sin githubUrl renderiza note y NO renderiza enlace', (tester) async {
    await _pumpCard(tester, expanded: true);
    await tester.pumpAndSettle();
    expect(find.text('Private repository'), findsOneWidget);
    expect(find.textContaining('View on GitHub'), findsNothing);
  });

  testWidgets('Enter activa la tarjeta', (tester) async {
    var taps = 0;
    await _pumpCard(tester, expanded: false, onTap: () => taps++);

    FocusScope.of(tester.element(find.byType(ProjectCard))).nextFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('Espacio activa la tarjeta', (tester) async {
    var taps = 0;
    await _pumpCard(tester, expanded: false, onTap: () => taps++);

    FocusScope.of(tester.element(find.byType(ProjectCard))).nextFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(taps, 1);
  });
}
