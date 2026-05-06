import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/navbar/desktop_navbar.dart';
import 'widgets/navbar/mobile_navbar.dart';
import 'widgets/sections/hero_section.dart';
import 'widgets/sections/experience_section.dart';
import 'widgets/sections/projects_section.dart';
import 'widgets/sections/skills_section.dart';
import 'widgets/sections/about_section.dart';
import 'widgets/sections/contact_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  double _progress = 0;
  String _activeSection = 'home';

  final Map<String, GlobalKey> _keys = {
    'home': GlobalKey(), 'experience': GlobalKey(),
    'projects': GlobalKey(), 'skills': GlobalKey(),
    'about': GlobalKey(), 'contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    setState(() {
      _progress = max > 0 ? _scrollController.offset / max : 0;
      _activeSection = _detectSection();
    });
  }

  String _detectSection() {
    for (final entry in _keys.entries.toList().reversed) {
      final box = entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      if (box.localToGlobal(Offset.zero).dy <= 140) return entry.key;
    }
    return 'home';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final navHeight = isMobile ? 50.0 : 58.0;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _NavDelegate(
                  height: navHeight,
                  child: isMobile
                      ? MobileNavbar(sectionKeys: _keys)
                      : DesktopNavbar(
                          activeSection: _activeSection,
                          sectionKeys: _keys,
                        ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  HeroSection(key: _keys['home']),
                  ExperienceSection(key: _keys['experience']),
                  ProjectsSection(key: _keys['projects']),
                  SkillsSection(key: _keys['skills']),
                  AboutSection(key: _keys['about']),
                  ContactSection(key: _keys['contact']),
                  _Footer(),
                ]),
              ),
            ],
          ),
          Positioned(
            top: navHeight,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (_, c) => Container(
                height: 2,
                width: c.maxWidth * _progress,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.accentBlue, AppTheme.accentGreen],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;
  const _NavDelegate({required this.height, required this.child});

  @override double get minExtent => height;
  @override double get maxExtent => height;

  @override
  Widget build(BuildContext c, double shrinkOffset, bool overlaps) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_NavDelegate old) => old.child != child;
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 96),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: AppTheme.borderSubtle)),
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('aldo@dev:~\$ ▌', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        Text('Built with Flutter Web · 2026', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    ),
  );
}
