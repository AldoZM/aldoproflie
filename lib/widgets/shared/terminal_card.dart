import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TerminalCard extends StatelessWidget {
  final Widget child;
  const TerminalCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppTheme.bgSurface,
      border: Border.all(color: AppTheme.borderDefault),
      borderRadius: BorderRadius.circular(8),
    ),
    child: child,
  );
}

class TerminalOutput extends StatelessWidget {
  final String text;
  final Color? color;
  const TerminalOutput({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 14, top: 3),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, color: color ?? AppTheme.textSecondary),
    ),
  );
}
