import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';

void main() {
  test('StackLayer expone label y techs', () {
    const layer = StackLayer('Backend', ['Node.js', 'Express']);
    expect(layer.label, 'Backend');
    expect(layer.techs, ['Node.js', 'Express']);
  });

  test('Project sin githubUrl conserva note y no url', () {
    const p = Project(
      icon: '🍔',
      name: 'Food Match',
      period: '2026',
      summary: 'summary',
      role: 'Solo developer',
      highlights: ['h1'],
      stack: [StackLayer('Backend', ['Node.js'])],
      githubUrl: null,
      note: 'Private repository',
    );
    expect(p.githubUrl, isNull);
    expect(p.note, 'Private repository');
  });
}
