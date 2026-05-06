import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../shared/section_label.dart';
import '../shared/scroll_reveal.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final padding = AppTheme.sectionPadding(context);

    final cards = [
      _ContactCard(icon: '📧', label: 'EMAIL', value: PortfolioData.email,
          onTap: () => launchUrl(Uri.parse('mailto:${PortfolioData.email}'))),
      _ContactCard(icon: '🐱', label: 'GITHUB', value: 'github.com/AldoZM',
          onTap: () => launchUrl(Uri.parse(PortfolioData.githubUrl))),
      _ContactCard(icon: '📱', label: 'PHONE', value: PortfolioData.phone,
          onTap: () => launchUrl(Uri.parse('tel:${PortfolioData.phone}'))),
    ];

    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: '\$ cat contact.txt'),
          const SizedBox(height: 8),
          ScrollReveal(
            child: RichText(text: const TextSpan(
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Get In ', style: TextStyle(color: AppTheme.textPrimary)),
                TextSpan(text: 'Touch', style: TextStyle(color: AppTheme.accentBlue)),
              ],
            )),
          ),
          const SizedBox(height: 44),
          if (isMobile)
            Column(children: cards.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ScrollReveal(
                delay: Duration(milliseconds: e.key * 120),
                child: e.value,
              ),
            )).toList())
          else
            Row(children: cards.asMap().entries.map((e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: e.key < 2 ? 12 : 0),
                child: ScrollReveal(
                  delay: Duration(milliseconds: e.key * 120),
                  child: e.value,
                ),
              ),
            )).toList()),
        ],
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final String icon, label, value;
  final VoidCallback onTap;
  const _ContactCard({required this.icon, required this.label, required this.value, required this.onTap});

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppTheme.bgSurface,
          border: Border.all(color: _hovered ? AppTheme.accentBlue : AppTheme.borderSubtle),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          Text(widget.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.label, style: const TextStyle(fontSize: 9, color: AppTheme.accentGreen, letterSpacing: 2)),
            const SizedBox(height: 3),
            Text(widget.value, style: const TextStyle(fontSize: 12, color: AppTheme.accentBlue)),
          ]),
        ]),
      ),
    ),
  );
}
