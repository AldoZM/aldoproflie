import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../shared/section_label.dart';
import '../shared/scroll_reveal.dart';
import '../shared/project_card.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  /// Índices expandidos. Escritorio: a lo más uno. Móvil: los que el usuario abra.
  final Set<int> _expanded = {};
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // Escritorio abre la primera: mucha gente no hace clic, y ahí vive la
    // evidencia de backend. En móvil empujaría el resto fuera de pantalla.
    if (!AppTheme.isMobile(context)) _expanded.add(0);
  }

  void _toggle(int index) {
    setState(() {
      if (_expanded.contains(index)) {
        _expanded.remove(index);
        return;
      }
      // Escritorio: una a la vez, para que la rejilla no se vuelva un acordeón.
      // Móvil: es una columna; forzar el cierre solo estorba.
      if (!AppTheme.isMobile(context)) _expanded.clear();
      _expanded.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final padding = AppTheme.sectionPadding(context);
    final projects = PortfolioData.projects;

    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: '\$ ls -la projects/'),
          const SizedBox(height: 8),
          ScrollReveal(
            child: RichText(text: const TextSpan(
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'My ', style: TextStyle(color: AppTheme.textPrimary)),
                TextSpan(text: 'Projects', style: TextStyle(color: AppTheme.accentBlue)),
              ],
            )),
          ),
          const SizedBox(height: 44),
          if (isMobile)
            Column(children: projects.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ScrollReveal(
                delay: Duration(milliseconds: e.key * 120),
                child: ProjectCard(
                  project: e.value,
                  expanded: _expanded.contains(e.key),
                  onTap: () => _toggle(e.key),
                ),
              ),
            )).toList())
          else
            // Filas de 2. Se calculan a partir de la lista: no codificar índices.
            Column(
              children: [
                for (int i = 0; i < projects.length; i += 2) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _Row(
                    projects: projects,
                    indices: [
                      for (int j = i; j < i + 2 && j < projects.length; j++) j,
                    ],
                    expanded: _expanded,
                    onTap: _toggle,
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final List<Project> projects;
  final List<int> indices;
  final Set<int> expanded;
  final void Function(int) onTap;

  const _Row({
    required this.projects,
    required this.indices,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (int slot = 0; slot < 2; slot++)
        Expanded(
          child: slot < indices.length
              ? Padding(
                  padding: EdgeInsets.only(
                    right: slot == 0 ? 8 : 0,
                    left: slot == 1 ? 8 : 0,
                  ),
                  child: ScrollReveal(
                    delay: Duration(milliseconds: slot * 120),
                    child: ProjectCard(
                      project: projects[indices[slot]],
                      expanded: expanded.contains(indices[slot]),
                      onTap: () => onTap(indices[slot]),
                    ),
                  ),
                )
              // Hueco: mantiene el ancho de columna cuando la fila va incompleta.
              : const SizedBox.shrink(),
        ),
    ],
  );
}
