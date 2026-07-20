import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'helpers.dart';

void main() {
  test('cvUrl apunta al PDF publicado', () {
    // Aldo decidió publicar el CV tal cual (ver portfolio_data.dart).
    expect(PortfolioData.cvUrl, isNotEmpty);
    expect(PortfolioData.cvUrl, endsWith('.pdf'));
  });

  testWidgets('con cvUrl definido SÍ se renderiza el botón de CV', (tester) async {
    await pumpPortfolio(tester);
    expect(find.text('./download_cv'), findsOneWidget);
  });

  testWidgets('el botón view_projects se renderiza', (tester) async {
    await pumpPortfolio(tester);
    expect(find.text('./view_projects'), findsOneWidget);
  });
}
