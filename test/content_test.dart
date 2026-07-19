import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'helpers.dart';

void main() {
  test('los puestos coinciden con el CV', () {
    expect(PortfolioData.jobs[0].role, 'Software Engineer Intern');
    expect(PortfolioData.jobs[1].role, 'Fullstack & Multiplatform QA Engineer');
    expect(PortfolioData.jobs[2].role, 'NoSQL Database Engineer');
  });

  test('la viñeta de la plataforma Spring va primera en Banxico', () {
    expect(PortfolioData.jobs[0].bullets.first, contains('Java/Spring backend'));
  });

  test('Elektra menciona el carrito en Java', () {
    expect(
      PortfolioData.jobs[1].bullets.any((b) => b.contains('shopping cart')),
      isTrue,
    );
  });

  test('existe el grupo BACKEND & APIs y va primero', () {
    expect(PortfolioData.skillGroups.first.label, 'BACKEND & APIs');
  });

  test('los 4 lenguajes de especialización van en azul', () {
    final langs = PortfolioData.skillGroups.firstWhere((g) => g.label == 'LANGUAGES');
    for (final name in ['Java', 'C++', 'Python', 'JavaScript']) {
      final skill = langs.skills.firstWhere((s) => s.label == name);
      expect(skill.color, SkillColor.blue, reason: '$name debe ir en azul');
    }
  });

  test('Unity y C# ya no aparecen', () {
    final all = PortfolioData.skillGroups.expand((g) => g.skills).map((s) => s.label);
    expect(all, isNot(contains('Unity')));
    expect(all, isNot(contains('C#')));
  });

  // El titular lo pinta TypewriterText, que devuelve RichText: hay que usar
  // findTypewriterText, no find.text (ver helpers.dart).
  testWidgets('el hero muestra el titular nuevo', (tester) async {
    await pumpPortfolio(tester);
    expect(findTypewriterText('Software Engineer · Backend & APIs · Mobile'),
        findsOneWidget);
  });

  testWidgets('el hero ya no dice Database Engineer ni QA Automation', (tester) async {
    await pumpPortfolio(tester);
    expect(findTypewriterText('Database Engineer'), findsNothing);
    expect(findTypewriterText('QA Automation'), findsNothing);
  });
}
