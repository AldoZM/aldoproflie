import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../shared/section_label.dart';
import '../shared/scroll_reveal.dart';
import '../shared/timeline_item.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = AppTheme.sectionPadding(context);
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: '\$ cat experience.log'),
          const SizedBox(height: 8),
          ScrollReveal(
            child: RichText(text: const TextSpan(
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Work ', style: TextStyle(color: AppTheme.textPrimary)),
                TextSpan(text: 'Experience', style: TextStyle(color: AppTheme.accentBlue)),
              ],
            )),
          ),
          const SizedBox(height: 44),
          ...PortfolioData.jobs.asMap().entries.map((e) => ScrollReveal(
            delay: Duration(milliseconds: e.key * 140),
            child: TimelineItem(
              job: e.value,
              isLast: e.key == PortfolioData.jobs.length - 1,
            ),
          )),
        ],
      ),
    );
  }
}
