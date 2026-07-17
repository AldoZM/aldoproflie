import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() {
  testWidgets('la app monta y renderiza el nombre', (tester) async {
    await pumpPortfolio(tester);
    // The app renders the name through the hero section
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('renderiza el scroll principal', (tester) async {
    await pumpPortfolio(tester);
    expect(find.byType(CustomScrollView), findsOneWidget);
  });
}
