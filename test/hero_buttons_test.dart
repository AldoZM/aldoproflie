import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'helpers.dart';

void main() {
  test('cvUrl vacío es la señal de "no hay CV publicable"', () {
    // El CV fuente tiene el apellido mal escrito ("Muñino").
    // Mientras cvUrl esté vacío, el botón no debe renderizarse.
    expect(PortfolioData.cvUrl, isEmpty);
  });

  testWidgets('con cvUrl vacío NO se renderiza el botón de CV', (tester) async {
    await pumpPortfolio(tester);
    expect(find.text('./download_cv'), findsNothing);
  });

  testWidgets('el botón view_projects sí se renderiza', (tester) async {
    await pumpPortfolio(tester);
    expect(find.text('./view_projects'), findsOneWidget);
  });
}
