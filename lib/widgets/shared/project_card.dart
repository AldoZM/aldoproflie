import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final bool expanded;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.expanded,
    required this.onTap,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  /// Enter y Espacio activan la tarjeta igual que el clic. Sin esto la
  /// sección es inalcanzable con teclado y con lector de pantalla.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      widget.onTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final active = _hovered || widget.expanded;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: Focus(
        onKeyEvent: _onKey,
        child: Builder(builder: (context) {
          final focused = Focus.of(context).hasFocus;
          return GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              transform: Matrix4.translationValues(0, active ? -3 : 0, 0),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                border: Border.all(
                  color: (active || focused) ? AppTheme.accentBlue : AppTheme.borderSubtle,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: active
                    ? [BoxShadow(
                        color: AppTheme.accentBlue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      )]
                    : [],
              ),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.icon, style: const TextStyle(fontSize: 28)),
                        const Spacer(),
                        Text(p.period,
                            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    Text(p.summary,
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.textSecondary, height: 1.8)),
                    const SizedBox(height: 14),
                    // Cerrada: solo las etiquetas de capa. Abierta: el detalle.
                    if (!widget.expanded)
                      Wrap(
                        spacing: 6, runSpacing: 6,
                        children: p.stack.map((l) => _LayerChip(label: l.label)).toList(),
                      )
                    else
                      _Details(project: p),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final Project project;
  const _Details({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(p.role,
            style: const TextStyle(fontSize: 11, color: AppTheme.accentGreen)),
        const SizedBox(height: 12),
        ...p.highlights.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('▸ ',
                      style: TextStyle(fontSize: 11, color: AppTheme.accentBlue)),
                  Expanded(
                    child: Text(h,
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.textSecondary, height: 1.7)),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 6),
        ...p.stack.map((layer) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(layer.label,
                        style: const TextStyle(
                            fontSize: 10, color: AppTheme.textSecondary, letterSpacing: 1)),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 6, runSpacing: 6,
                      children: layer.techs.map((t) => _TechChip(label: t)).toList(),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
        // Regla dura: sin githubUrl no se renderiza enlace. Nunca un 404.
        if (p.githubUrl != null)
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(p.githubUrl!)),
            child: const Text('→ View on GitHub',
                style: TextStyle(fontSize: 11, color: AppTheme.accentBlue)),
          )
        else if (p.note != null)
          Text(p.note!,
              style: const TextStyle(
                  fontSize: 10, color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
      ],
    );
  }
}

class _LayerChip extends StatelessWidget {
  final String label;
  const _LayerChip({required this.label});

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

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFF161B22),
      border: Border.all(color: AppTheme.borderSubtle),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
  );
}
