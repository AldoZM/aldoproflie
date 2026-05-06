import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../shared/section_label.dart';
import '../shared/scroll_reveal.dart';
import '../shared/skill_tag.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final padding = AppTheme.sectionPadding(context);
    final groups = PortfolioData.skillGroups;

    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: '\$ cat skills.json'),
          const SizedBox(height: 8),
          ScrollReveal(
            child: RichText(text: const TextSpan(
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Tech ', style: TextStyle(color: AppTheme.textPrimary)),
                TextSpan(text: 'Stack', style: TextStyle(color: AppTheme.accentBlue)),
              ],
            )),
          ),
          const SizedBox(height: 44),
          if (isMobile)
            Column(children: groups.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ScrollReveal(
                delay: Duration(milliseconds: e.key * 100),
                child: _GroupCard(group: e.value),
              ),
            )).toList())
          else
            Column(children: [
              _GridRow(groups: groups, indices: [0, 1]),
              const SizedBox(height: 16),
              _GridRow(groups: groups, indices: [2, 3]),
            ]),
        ],
      ),
    );
  }
}

class _GridRow extends StatelessWidget {
  final List<SkillGroup> groups;
  final List<int> indices;
  const _GridRow({required this.groups, required this.indices});

  @override
  Widget build(BuildContext context) => Row(
    children: indices.map((i) => Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: i == indices.first ? 8 : 0, left: i == indices.last ? 8 : 0),
        child: ScrollReveal(
          delay: Duration(milliseconds: (i % 2) * 100),
          child: _GroupCard(group: groups[i]),
        ),
      ),
    )).toList(),
  );
}

class _GroupCard extends StatelessWidget {
  final SkillGroup group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: AppTheme.bgSurface,
      border: Border.all(color: AppTheme.borderSubtle),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(group.label, style: const TextStyle(fontSize: 9, color: AppTheme.accentGreen, letterSpacing: 3)),
        const SizedBox(height: 14),
        Wrap(spacing: 8, runSpacing: 8,
            children: group.skills.map((s) => SkillTagWidget(skill: s)).toList()),
      ],
    ),
  );
}
