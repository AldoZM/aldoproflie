import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../shared/section_label.dart';
import '../shared/scroll_reveal.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = AppTheme.sectionPadding(context);
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: '\$ cat about.txt'),
          const SizedBox(height: 8),
          ScrollReveal(
            child: RichText(text: const TextSpan(
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'About ', style: TextStyle(color: AppTheme.textPrimary)),
                TextSpan(text: 'Me', style: TextStyle(color: AppTheme.accentBlue)),
              ],
            )),
          ),
          const SizedBox(height: 44),
          ScrollReveal(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/img/Aldo.jpg',
                width: 160,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ScrollReveal(
            delay: const Duration(milliseconds: 100),
            child: _Card(title: '🎓 Education', child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('B.S. Computer Engineering',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                SizedBox(height: 4),
                Text('UNAM – Faculty of Engineering',
                    style: TextStyle(fontSize: 13, color: AppTheme.accentBlue)),
                SizedBox(height: 4),
                Text('GPA: 8.5/10.0 (equiv. 3.4/4.0) · Graduated Summer 2025',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                SizedBox(height: 4),
                Text('Coursework: Data Structures, Algorithms, Distributed Systems, OS, Software Engineering',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.6)),
              ],
            )),
          ),
          const SizedBox(height: 16),
          ScrollReveal(
            delay: const Duration(milliseconds: 200),
            child: _Card(title: '🏆 Certifications', child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Advanced SQL Course – PROTECO UNAM',
                    style: TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text('Honorable Mention · Query design, stored procedures, DB optimization',
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.5)),
                SizedBox(height: 12),
                Text('Java Developer Course – PROTECO UNAM',
                    style: TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text('OOP, data structures, scalable application development',
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.5)),
              ],
            )),
          ),
          const SizedBox(height: 16),
          ScrollReveal(
            delay: const Duration(milliseconds: 300),
            child: _Card(title: '🌐 Languages', child: Wrap(
              spacing: 12, runSpacing: 12,
              children: const [
                _LangChip(flag: '🇲🇽', lang: 'Spanish', level: 'Native'),
                _LangChip(flag: '🇬🇧', lang: 'English', level: 'Advanced'),
                _LangChip(flag: '🇯🇵', lang: 'Japanese', level: 'Basic'),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppTheme.bgSurface,
      border: Border.all(color: AppTheme.borderSubtle),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

class _LangChip extends StatelessWidget {
  final String flag, lang, level;
  const _LangChip({required this.flag, required this.lang, required this.level});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: AppTheme.borderDefault),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(children: [
      Text(flag, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 4),
      Text(lang, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
      Text(level, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
    ]),
  );
}
