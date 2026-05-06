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
            Column(children: [
              _Row(projects: projects, indices: [0, 1]),
              const SizedBox(height: 16),
              _Row(projects: projects, indices: [2, 3]),
            ]),
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
    children: indices.map((i) => Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: i == indices.first ? 8 : 0, left: i == indices.last ? 8 : 0),
        child: ScrollReveal(
          delay: Duration(milliseconds: (i % 2) * 120),
          child: ProjectCard(project: projects[i]),
        ),
      ),
    )).toList(),
  );
}
