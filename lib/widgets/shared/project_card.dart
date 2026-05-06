import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppTheme.bgSurface,
          border: Border.all(
            color: _hovered ? AppTheme.accentBlue : AppTheme.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hovered
              ? [BoxShadow(
                  color: AppTheme.accentBlue.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                )]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.project.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            Text(widget.project.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            Text(widget.project.description,
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.8)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: widget.project.tags.map((t) => _Tag(label: t)).toList(),
            ),
            if (widget.project.githubUrl != null) ...[
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(widget.project.githubUrl!)),
                child: const Text('→ View on GitHub',
                    style: TextStyle(fontSize: 11, color: AppTheme.accentBlue)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFF161B22),
      border: Border.all(color: AppTheme.borderDefault),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.accentBlue)),
  );
}
