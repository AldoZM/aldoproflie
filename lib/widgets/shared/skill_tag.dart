import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';

class SkillTagWidget extends StatelessWidget {
  final Skill skill;
  const SkillTagWidget({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final (color, bg, border) = switch (skill.color) {
      SkillColor.blue  => (AppTheme.accentBlue,  const Color(0x0D58A6FF), const Color(0x4D58A6FF)),
      SkillColor.green => (AppTheme.accentGreen, const Color(0x0D3FB950), const Color(0x4D3FB950)),
      SkillColor.gray  => (AppTheme.textSecondary, const Color(0xFF161B22), AppTheme.borderDefault),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(skill.label, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}
