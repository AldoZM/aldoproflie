import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DesktopNavbar extends StatelessWidget {
  final String activeSection;
  final Map<String, GlobalKey> sectionKeys;

  const DesktopNavbar({
    super.key,
    required this.activeSection,
    required this.sectionKeys,
  });

  static const _links = [
    ('#home', 'home'),
    ('#experience', 'experience'),
    ('#projects', 'projects'),
    ('#skills', 'skills'),
    ('#about', 'about'),
    ('#contact', 'contact'),
  ];

  void _scrollTo(String section) {
    final ctx = sectionKeys[section]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 72),
      color: AppTheme.bgPrimary.withOpacity(0.97),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Logo(),
          Row(
            children: _links.map((link) {
              final active = activeSection == link.$2;
              return GestureDetector(
                onTap: () => _scrollTo(link.$2),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(link.$1,
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1,
                          color: active ? AppTheme.accentBlue : AppTheme.textSecondary,
                        )),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RichText(
    text: const TextSpan(
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 2),
      children: [
        TextSpan(text: 'aldo', style: TextStyle(color: AppTheme.accentBlue)),
        TextSpan(text: '.', style: TextStyle(color: AppTheme.accentGreen)),
        TextSpan(text: 'dev', style: TextStyle(color: AppTheme.accentBlue)),
      ],
    ),
  );
}
