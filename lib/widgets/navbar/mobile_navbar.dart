import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class MobileNavbar extends StatefulWidget {
  final Map<String, GlobalKey> sectionKeys;
  const MobileNavbar({super.key, required this.sectionKeys});

  @override
  State<MobileNavbar> createState() => _MobileNavbarState();
}

class _MobileNavbarState extends State<MobileNavbar> {
  bool _open = false;

  static const _links = [
    ('#home', 'home'), ('#experience', 'experience'),
    ('#projects', 'projects'), ('#skills', 'skills'),
    ('#about', 'about'), ('#contact', 'contact'),
  ];

  void _scrollTo(String section) {
    final ctx = widget.sectionKeys[section]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          color: AppTheme.bgPrimary.withOpacity(0.97),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2),
                  children: [
                    TextSpan(text: 'aldo', style: TextStyle(color: AppTheme.accentBlue)),
                    TextSpan(text: '.', style: TextStyle(color: AppTheme.accentGreen)),
                    TextSpan(text: 'dev', style: TextStyle(color: AppTheme.accentBlue)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _open = !_open),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (_) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    width: 20, height: 2,
                    decoration: BoxDecoration(
                      color: _open ? AppTheme.accentBlue : AppTheme.textSecondary,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
        if (_open)
          Positioned.fill(
            child: Container(
              color: AppTheme.bgPrimary.withOpacity(0.98),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _links.map((link) => GestureDetector(
                        onTap: () {
                          setState(() => _open = false);
                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () => _scrollTo(link.$2),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(link.$1,
                              style: const TextStyle(fontSize: 20, letterSpacing: 2, color: AppTheme.textSecondary)),
                        ),
                      )).toList(),
                    ),
                  ),
                  Positioned(
                    top: 16, right: 20,
                    child: GestureDetector(
                      onTap: () => setState(() => _open = false),
                      child: const Text('✕', style: TextStyle(fontSize: 22, color: AppTheme.textSecondary)),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
