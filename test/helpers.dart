import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/main.dart';

/// Monta la app con un viewport fijo. `size` por defecto = escritorio.
/// Bombea lo suficiente para que la app se inicialice completamente.
Future<void> pumpPortfolio(
  WidgetTester tester, {
  Size size = const Size(1400, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const PortfolioApp());
  // Bombea en ciclos cortos para permitir que todas las animaciones se completen
  for (int i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

/// Busca texto renderizado por `TypewriterText`.
///
/// `find.text()` NO sirve para esos textos: solo encuentra `Text` y
/// `EditableText`, y `TypewriterText.build` devuelve un `RichText`
/// (`typewriter_text.dart:82`). `includePlaceholders: false` descarta el
/// WidgetSpan del cursor.
Finder findTypewriterText(String text) => find.byWidgetPredicate(
      (w) =>
          w is RichText &&
          w.text.toPlainText(includePlaceholders: false).contains(text),
      description: 'RichText que contiene "$text"',
    );
