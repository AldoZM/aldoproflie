import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../shared/section_label.dart';
import '../shared/scroll_reveal.dart';
import '../shared/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
                child: ProjectCard(project: e.value),
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
  const _Row({required this.projects, required this.indices});

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
                    child: ProjectCard(project: projects[indices[slot]]),
                  ),
                )
              // Hueco: mantiene el ancho de columna cuando la fila va incompleta.
              : const SizedBox.shrink(),
        ),
    ],
  );
}
