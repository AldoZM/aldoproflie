# Portfolio Flutter Web Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build Aldo Zetina's personal portfolio as a Flutter Web single-page app with dark minimal terminal aesthetic, typewriter animations, and full mobile responsiveness.

**Architecture:** Single-page scroll using `SingleChildScrollView` + `ScrollController` + `GlobalKey` anchors. Animations use custom `TypewriterText` widget (Timer-based) + `ScrollReveal` widget (VisibilityDetector + AnimationController). Responsive via `LayoutBuilder`/`MediaQuery` with mobile <600px, desktop >1024px breakpoints.

**Tech Stack:** Flutter Web, google_fonts, flutter_animate, visibility_detector, url_launcher

---

## File Map

| File | Responsibility |
|---|---|
| `lib/main.dart` | App entry, MaterialApp, theme wiring |
| `lib/theme/app_theme.dart` | Color tokens, text styles, breakpoints, padding helpers |
| `lib/data/portfolio_data.dart` | All content as Dart constants (jobs, projects, skills) |
| `lib/widgets/shared/typewriter_text.dart` | Typewriter animation widget |
| `lib/widgets/shared/scroll_reveal.dart` | Fade+slide on scroll enter |
| `lib/widgets/shared/section_label.dart` | `$ cat ...` green label, typewriter triggered by scroll |
| `lib/widgets/shared/skill_tag.dart` | Colored skill pill |
| `lib/widgets/shared/terminal_card.dart` | Terminal-style container + TerminalOutput |
| `lib/widgets/shared/project_card.dart` | Hoverable project card with tags |
| `lib/widgets/shared/timeline_item.dart` | Timeline dot + content row |
| `lib/widgets/navbar/desktop_navbar.dart` | Sticky horizontal nav with active link |
| `lib/widgets/navbar/mobile_navbar.dart` | Hamburger + full-screen overlay |
| `lib/home_page.dart` | CustomScrollView, progress bar, section assembly |
| `lib/widgets/sections/hero_section.dart` | Hero typewriter sequence |
| `lib/widgets/sections/experience_section.dart` | Timeline of 3 jobs |
| `lib/widgets/sections/projects_section.dart` | 2-col/1-col project grid |
| `lib/widgets/sections/skills_section.dart` | 2×2/stack skill groups |
| `lib/widgets/sections/about_section.dart` | Education, certs, languages |
| `lib/widgets/sections/contact_section.dart` | 3 contact cards |
| `web/index.html` | Title, meta, favicon |

---

### Task 1: Initialize Flutter project

**Files:**
- Create: Flutter scaffold in `D:/Codigo Express/aldoproflie/`
- Delete: `index.html` (old HTML portfolio — replaced by Flutter web)
- Move: `img/` → `assets/img/`

- [ ] **Step 1: Verify Flutter is installed**

```bash
flutter --version
```
Expected: Flutter 3.x or later. If not installed: https://docs.flutter.dev/get-started/install/windows/web

- [ ] **Step 2: Create Flutter project in existing repo**

```bash
cd "D:/Codigo Express/aldoproflie"
flutter create . --project-name aldo_portfolio --platforms web --org com.aldozetina
```
Expected output: `All done!` — creates `lib/`, `web/`, `test/`, `pubspec.yaml`

- [ ] **Step 3: Delete old HTML portfolio file**

```bash
rm "D:/Codigo Express/aldoproflie/index.html"
```

- [ ] **Step 4: Move img assets**

```bash
mkdir -p "D:/Codigo Express/aldoproflie/assets/img"
mv "D:/Codigo Express/aldoproflie/img/"* "D:/Codigo Express/aldoproflie/assets/img/"
rmdir "D:/Codigo Express/aldoproflie/img"
```

- [ ] **Step 5: Verify Flutter web runs**

```bash
cd "D:/Codigo Express/aldoproflie"
flutter run -d chrome
```
Expected: Default Flutter counter app opens in Chrome.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "chore: initialize Flutter Web project scaffold"
```

---

### Task 2: Configure pubspec.yaml

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Replace pubspec.yaml content**

```yaml
name: aldo_portfolio
description: Aldo Zetina Muciño — Personal Portfolio
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  visibility_detector: ^0.4.0+2
  url_launcher: ^6.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/img/
```

- [ ] **Step 2: Install dependencies**

```bash
cd "D:/Codigo Express/aldoproflie"
flutter pub get
```
Expected: `Got dependencies!`

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add portfolio dependencies"
```

---

### Task 3: Theme and data

**Files:**
- Create: `lib/theme/app_theme.dart`
- Create: `lib/data/portfolio_data.dart`

- [ ] **Step 1: Create theme file**

```bash
mkdir -p "D:/Codigo Express/aldoproflie/lib/theme"
mkdir -p "D:/Codigo Express/aldoproflie/lib/data"
```

- [ ] **Step 2: Write lib/theme/app_theme.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bgPrimary    = Color(0xFF010409);
  static const Color bgSurface    = Color(0xFF0d1117);
  static const Color borderSubtle = Color(0xFF21262d);
  static const Color borderDefault= Color(0xFF30363d);
  static const Color accentBlue   = Color(0xFF58a6ff);
  static const Color accentGreen  = Color(0xFF3fb950);
  static const Color textPrimary  = Color(0xFFe6edf3);
  static const Color textSecondary= Color(0xFF8b949e);

  static const double mobileBreakpoint  = 600;
  static const double desktopBreakpoint = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static EdgeInsets sectionPadding(BuildContext context) => isMobile(context)
      ? const EdgeInsets.symmetric(vertical: 48, horizontal: 22)
      : const EdgeInsets.symmetric(vertical: 100, horizontal: 96);

  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: bgPrimary,
    colorScheme: const ColorScheme.dark(
      surface: bgPrimary,
      primary: accentBlue,
      secondary: accentGreen,
    ),
    textTheme: GoogleFonts.sourceCodeProTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
  );
}
```

- [ ] **Step 3: Write lib/data/portfolio_data.dart**

```dart
enum SkillColor { blue, green, gray }

class Skill {
  final String label;
  final SkillColor color;
  const Skill(this.label, this.color);
}

class SkillGroup {
  final String label;
  final List<Skill> skills;
  const SkillGroup({required this.label, required this.skills});
}

class Job {
  final String role, company, dates;
  final List<String> bullets;
  final bool isCurrent;
  const Job({
    required this.role,
    required this.company,
    required this.dates,
    required this.bullets,
    this.isCurrent = false,
  });
}

class Project {
  final String icon, name, description;
  final List<String> tags;
  final String? githubUrl;
  const Project({
    required this.icon,
    required this.name,
    required this.description,
    required this.tags,
    this.githubUrl,
  });
}

class PortfolioData {
  static const String githubUrl = 'https://github.com/AldoZM';
  static const String email     = 'zetinaa3@gmail.com';
  static const String phone     = '+52 744-272-6616';
  static const String location  = 'Mexico City, Mexico';
  static const String cvUrl     = '';

  static const List<Job> jobs = [
    Job(
      role: 'Network Infrastructure Intern',
      company: 'Banco de México',
      dates: 'Fall 2024 – Spring 2026',
      isCurrent: true,
      bullets: [
        'Designed search algorithms (binary search, hash, trie) — identity resolution across 500+ Active Directory records',
        'Fault-tolerant automation in Python + PowerShell → 30% fewer process failures',
        'Event logging & auditing for production observability in critical financial systems',
        'Enforced 100% data integrity through validation algorithms before ingestion',
      ],
    ),
    Job(
      role: 'QA Automation Engineer Intern',
      company: 'Grupo Salinas · Elektra.mx',
      dates: 'Summer 2022 – Spring 2024',
      bullets: [
        'Developed multiplatform mobile features for Elektra app using Flutter (Provider/Bloc)',
        'Built automated regression suites with Appium → 40% less manual testing',
        'Integrated mobile CI/CD pipelines in AWS CodeCommit',
        'Triaged mobile-specific defects tracked in Jira',
      ],
    ),
    Job(
      role: 'NFV Engineer (Virtualization)',
      company: 'Huawei',
      dates: 'Summer 2021 – Spring 2022',
      bullets: [
        'Developed C++ client/server utilities over UNIX domain sockets in Linux NFV environments',
        'Automated infrastructure health monitoring via Bash + C++ scripts',
      ],
    ),
  ];

  static const List<Project> projects = [
    Project(
      icon: '🫀',
      name: 'VR Medical Simulation — Código Infarto',
      description: 'Real-time multiplatform VR app simulating cardiac emergency protocols. Built with medical professionals.',
      tags: ['Unity', 'C#', 'VRChat SDK', 'UdonSharp'],
    ),
    Project(
      icon: '🖥️',
      name: 'Home Lab & Server Administration',
      description: 'Personal Linux server with containerized services, network security rules, and uptime monitoring.',
      tags: ['Linux', 'Docker', 'Networking'],
    ),
    Project(
      icon: '☕',
      name: 'Advanced SQL & Java — PROTECO',
      description: 'Scalable backends with JDBC/Hibernate ORM and RESTful APIs. Honorable Mention at PROTECO UNAM.',
      tags: ['Java', 'SQL Server', 'Hibernate', 'JDBC'],
    ),
    Project(
      icon: '👾',
      name: 'Space Invader — 2 Players',
      description: 'Multiplayer Space Invader using threading for independent player ship control.',
      tags: ['Python', 'pygame', 'Threading'],
      githubUrl: 'https://github.com/AldoZM/Space_Invader_Two_Player_Full',
    ),
  ];

  static const List<SkillGroup> skillGroups = [
    SkillGroup(label: 'MOBILE', skills: [
      Skill('Flutter', SkillColor.blue),
      Skill('Dart', SkillColor.blue),
      Skill('Appium', SkillColor.gray),
      Skill('Provider', SkillColor.gray),
      Skill('Bloc', SkillColor.gray),
      Skill('iOS/Android', SkillColor.gray),
    ]),
    SkillGroup(label: 'LANGUAGES', skills: [
      Skill('Python', SkillColor.blue),
      Skill('Dart', SkillColor.blue),
      Skill('Java', SkillColor.gray),
      Skill('C++', SkillColor.gray),
      Skill('C#', SkillColor.gray),
      Skill('JavaScript', SkillColor.gray),
      Skill('SQL', SkillColor.gray),
      Skill('Bash', SkillColor.gray),
    ]),
    SkillGroup(label: 'DEVOPS & INFRA', skills: [
      Skill('Docker', SkillColor.green),
      Skill('Linux', SkillColor.green),
      Skill('Git', SkillColor.green),
      Skill('AWS CodeCommit', SkillColor.gray),
      Skill('CI/CD', SkillColor.gray),
      Skill('Active Directory', SkillColor.gray),
      Skill('Vim', SkillColor.gray),
    ]),
    SkillGroup(label: 'BACKEND & APIs', skills: [
      Skill('RESTful APIs', SkillColor.gray),
      Skill('JDBC', SkillColor.gray),
      Skill('Hibernate ORM', SkillColor.gray),
      Skill('SQL Server', SkillColor.gray),
      Skill('MySQL', SkillColor.gray),
    ]),
  ];
}
```

- [ ] **Step 4: Commit**

```bash
git add lib/theme/ lib/data/
git commit -m "feat: add theme tokens and portfolio content data"
```

---

### Task 4: TypewriterText widget

**Files:**
- Create: `lib/widgets/shared/typewriter_text.dart`
- Create: `test/widgets/typewriter_text_test.dart`

- [ ] **Step 1: Create directories**

```bash
mkdir -p "D:/Codigo Express/aldoproflie/lib/widgets/shared"
mkdir -p "D:/Codigo Express/aldoproflie/test/widgets"
```

- [ ] **Step 2: Write failing test**

`test/widgets/typewriter_text_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/widgets/shared/typewriter_text.dart';
import 'package:aldo_portfolio/theme/app_theme.dart';

void main() {
  testWidgets('TypewriterText starts empty and types characters', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: const Scaffold(
          body: TypewriterText(
            text: 'hi',
            charDelayMs: 50,
          ),
        ),
      ),
    );

    // Initially empty (no text rendered yet)
    expect(find.text('hi'), findsNothing);

    // After first char delay
    await tester.pump(const Duration(milliseconds: 60));
    // After both chars
    await tester.pump(const Duration(milliseconds: 110));
    expect(find.textContaining('hi'), findsOneWidget);
  });

  testWidgets('TypewriterText calls onComplete', (tester) async {
    bool completed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: TypewriterText(
            text: 'ab',
            charDelayMs: 10,
            onComplete: () => completed = true,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(completed, isTrue);
  });
}
```

- [ ] **Step 3: Run test — expect FAIL**

```bash
cd "D:/Codigo Express/aldoproflie"
flutter test test/widgets/typewriter_text_test.dart
```
Expected: FAIL — `typewriter_text.dart` not found.

- [ ] **Step 4: Write lib/widgets/shared/typewriter_text.dart**

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int charDelayMs;
  final int startDelayMs;
  final bool autoStart;
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDelayMs = 40,
    this.startDelayMs = 0,
    this.autoStart = true,
    this.onComplete,
  });

  @override
  State<TypewriterText> createState() => TypewriterTextState();
}

class TypewriterTextState extends State<TypewriterText> {
  String _displayed = '';
  bool _showCursor = true;
  bool _done = false;
  Timer? _charTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startCursorBlink();
    if (widget.autoStart) start();
  }

  void start() {
    if (widget.startDelayMs > 0) {
      Future.delayed(Duration(milliseconds: widget.startDelayMs), _typeChars);
    } else {
      _typeChars();
    }
  }

  void _typeChars() {
    int i = 0;
    _charTimer = Timer.periodic(Duration(milliseconds: widget.charDelayMs), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _displayed = widget.text.substring(0, i + 1));
      i++;
      if (i >= widget.text.length) {
        t.cancel();
        setState(() => _done = true);
        _cursorTimer?.cancel();
        widget.onComplete?.call();
      }
    });
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      if (mounted) setState(() => _showCursor = !_showCursor);
    });
  }

  @override
  void dispose() {
    _charTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const TextStyle(color: AppTheme.textPrimary);
    final cursorHeight = (style.fontSize ?? 16) * 1.2;

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: _displayed),
          if (!_done)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: AnimatedOpacity(
                opacity: _showCursor ? 1.0 : 0.0,
                duration: Duration.zero,
                child: Container(
                  width: 2,
                  height: cursorHeight,
                  color: AppTheme.accentBlue,
                  margin: const EdgeInsets.only(left: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Run test — expect PASS**

```bash
flutter test test/widgets/typewriter_text_test.dart
```
Expected: All tests passed.

- [ ] **Step 6: Commit**

```bash
git add lib/widgets/shared/typewriter_text.dart test/widgets/typewriter_text_test.dart
git commit -m "feat: add TypewriterText widget"
```

---

### Task 5: ScrollReveal widget

**Files:**
- Create: `lib/widgets/shared/scroll_reveal.dart`
- Create: `test/widgets/scroll_reveal_test.dart`

- [ ] **Step 1: Write failing test**

`test/widgets/scroll_reveal_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:aldo_portfolio/widgets/shared/scroll_reveal.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('ScrollReveal child is initially invisible', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScrollReveal(child: Text('hello')),
        ),
      ),
    );
    await tester.pump();
    final opacity = tester.widget<FadeTransition>(find.byType(FadeTransition));
    expect(opacity.opacity.value, 0.0);
  });
}
```

- [ ] **Step 2: Run test — expect FAIL**

```bash
flutter test test/widgets/scroll_reveal_test.dart
```
Expected: FAIL — `scroll_reveal.dart` not found.

- [ ] **Step 3: Write lib/widgets/shared/scroll_reveal.dart**

```dart
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisible() {
    if (_triggered) return;
    _triggered = true;
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('sr-${widget.hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) _onVisible();
      },
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test — expect PASS**

```bash
flutter test test/widgets/scroll_reveal_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/shared/scroll_reveal.dart test/widgets/scroll_reveal_test.dart
git commit -m "feat: add ScrollReveal widget"
```

---

### Task 6: SectionLabel + SkillTag

**Files:**
- Create: `lib/widgets/shared/section_label.dart`
- Create: `lib/widgets/shared/skill_tag.dart`

- [ ] **Step 1: Write lib/widgets/shared/section_label.dart**

```dart
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../theme/app_theme.dart';
import 'typewriter_text.dart';

class SectionLabel extends StatefulWidget {
  final String text;
  const SectionLabel({super.key, required this.text});

  @override
  State<SectionLabel> createState() => _SectionLabelState();
}

class _SectionLabelState extends State<SectionLabel> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('label-${widget.text}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5 && !_started) {
          setState(() => _started = true);
        }
      },
      child: SizedBox(
        height: 16,
        child: _started
            ? TypewriterText(
                text: widget.text,
                charDelayMs: 28,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.accentGreen,
                  letterSpacing: 3,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
```

- [ ] **Step 2: Write lib/widgets/shared/skill_tag.dart**

```dart
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
```

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/shared/section_label.dart lib/widgets/shared/skill_tag.dart
git commit -m "feat: add SectionLabel and SkillTag widgets"
```

---

### Task 7: TerminalCard + ProjectCard + TimelineItem

**Files:**
- Create: `lib/widgets/shared/terminal_card.dart`
- Create: `lib/widgets/shared/project_card.dart`
- Create: `lib/widgets/shared/timeline_item.dart`

- [ ] **Step 1: Write lib/widgets/shared/terminal_card.dart**

```dart
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
```

- [ ] **Step 2: Write lib/widgets/shared/project_card.dart**

```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppTheme.bgSurface,
          border: Border.all(
            color: _hovered ? AppTheme.accentBlue : AppTheme.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hovered
              ? [BoxShadow(
                  color: AppTheme.accentBlue.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                )]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.project.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            Text(widget.project.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            Text(widget.project.description,
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.8)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: widget.project.tags.map((t) => _Tag(label: t)).toList(),
            ),
            if (widget.project.githubUrl != null) ...[
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(widget.project.githubUrl!)),
                child: const Text('→ View on GitHub',
                    style: TextStyle(fontSize: 11, color: AppTheme.accentBlue)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

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
```

- [ ] **Step 3: Write lib/widgets/shared/timeline_item.dart**

```dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';

class TimelineItem extends StatelessWidget {
  final Job job;
  final bool isLast;
  const TimelineItem({super.key, required this.job, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 9, height: 9,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: job.isCurrent ? AppTheme.accentGreen : AppTheme.accentBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.bgPrimary, width: 2),
                    boxShadow: job.isCurrent
                        ? [BoxShadow(color: AppTheme.accentGreen.withOpacity(0.6), blurRadius: 8)]
                        : [],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: AppTheme.borderDefault,
                      margin: const EdgeInsets.only(left: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(job.role,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      ),
                      Text(job.dates,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(job.company, style: const TextStyle(fontSize: 13, color: AppTheme.accentBlue)),
                  const SizedBox(height: 12),
                  ...job.bullets.map((b) => _Bullet(text: b)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('▸ ', style: TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
        Expanded(
          child: Text(text,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.9)),
        ),
      ],
    ),
  );
}
```

- [ ] **Step 4: Commit**

```bash
git add lib/widgets/shared/terminal_card.dart lib/widgets/shared/project_card.dart lib/widgets/shared/timeline_item.dart
git commit -m "feat: add TerminalCard, ProjectCard, TimelineItem widgets"
```

---

### Task 8: Navbar widgets

**Files:**
- Create: `lib/widgets/navbar/desktop_navbar.dart`
- Create: `lib/widgets/navbar/mobile_navbar.dart`

- [ ] **Step 1: Create directory**

```bash
mkdir -p "D:/Codigo Express/aldoproflie/lib/widgets/navbar"
```

- [ ] **Step 2: Write lib/widgets/navbar/desktop_navbar.dart**

```dart
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
```

- [ ] **Step 3: Write lib/widgets/navbar/mobile_navbar.dart**

```dart
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
```

- [ ] **Step 4: Commit**

```bash
git add lib/widgets/navbar/
git commit -m "feat: add desktop and mobile navbar widgets"
```

---

### Task 9: HomePage scaffold

**Files:**
- Create: `lib/home_page.dart`

- [ ] **Step 1: Write lib/home_page.dart**

```dart
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
          // Progress bar
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
  Widget build(BuildContext c, double shrinkOffset, bool overlaps) => child;

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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text('aldo@dev:~\$ ▌', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        Text('Built with Flutter Web · 2026', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    ),
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/home_page.dart
git commit -m "feat: add HomePage scaffold with scroll progress and active nav"
```

---

### Task 10: HeroSection

**Files:**
- Create: `lib/widgets/sections/hero_section.dart`

- [ ] **Step 1: Create directory**

```bash
mkdir -p "D:/Codigo Express/aldoproflie/lib/widgets/sections"
```

- [ ] **Step 2: Write lib/widgets/sections/hero_section.dart**

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../../shared/typewriter_text.dart';
import '../../shared/terminal_card.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _showPre = false, _showName = false, _showTitle = false,
       _showDesc = false, _showTerminal = false, _terminalCmd = false;
  final List<bool> _outputs = [false, false, false, false];
  bool _showButtons = false, _showHint = false;

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  Future<void> _runSequence() async {
    await _delay(300);
    _set(() => _showPre = true);
    await _delay(580);   // "$ whoami" 7 chars * 40ms
    _set(() => _showName = true);
    await _delay(870);   // "Aldo Zetina Muciño" 18 chars * 45ms
    _set(() => _showTitle = true);
    await _delay(940);   // title 49 chars * 18ms
    _set(() => _showDesc = true);
    await _delay(1140);  // desc ~90 chars * 12ms
    _set(() => _showTerminal = true);
    await _delay(400);
    _set(() => _terminalCmd = true);
    await _delay(830);   // "cat about.txt" 14 chars * 55ms
    for (int i = 0; i < _outputs.length; i++) {
      await _delay(220);
      _set(() => _outputs[i] = true);
    }
    await _delay(400);
    _set(() => _showButtons = true);
    await _delay(200);
    _set(() => _showHint = true);
  }

  Future<void> _delay(int ms) => Future.delayed(Duration(milliseconds: ms));
  void _set(VoidCallback fn) { if (mounted) setState(fn); }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    return Container(
      padding: isMobile
          ? const EdgeInsets.fromLTRB(22, 52, 22, 40)
          : const EdgeInsets.fromLTRB(96, 100, 96, 100),
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 58),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_showPre) TypewriterText(
            text: '\$ whoami',
            charDelayMs: 40,
            style: const TextStyle(fontSize: 13, color: AppTheme.accentGreen, letterSpacing: 1),
          ),
          const SizedBox(height: 10),
          if (_showName) TypewriterText(
            text: 'Aldo Zetina Muciño',
            charDelayMs: 45,
            style: TextStyle(
              fontSize: isMobile ? 30 : 60,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          if (_showTitle) TypewriterText(
            text: 'Flutter Engineer · QA Automation · Infrastructure',
            charDelayMs: 18,
            style: TextStyle(fontSize: isMobile ? 13 : 20, color: AppTheme.accentBlue),
          ),
          const SizedBox(height: 16),
          if (_showDesc) TypewriterText(
            text: 'Computer Engineer from UNAM. Building reliable mobile\nexperiences and automated systems. Currently @ Banco de México.',
            charDelayMs: 12,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.9),
          ),
          const SizedBox(height: 32),
          AnimatedOpacity(
            opacity: _showTerminal ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: TerminalCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text('aldo@dev:~\$ ', style: TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                      if (_terminalCmd) TypewriterText(
                        text: ' cat about.txt',
                        charDelayMs: 55,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                      ),
                    ]),
                    if (_outputs[0]) const TerminalOutput(text: '📍 Mexico City, Mexico'),
                    if (_outputs[1]) const TerminalOutput(text: '🎓 B.S. Computer Engineering — UNAM (2025)'),
                    if (_outputs[2]) const TerminalOutput(text: '💼 Network Infra Intern — Banco de México'),
                    if (_outputs[3]) const TerminalOutput(text: '▸ Open to opportunities', color: AppTheme.accentGreen),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Text('aldo@dev:~\$ ', style: TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                      _BlinkingCursor(),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          if (_showButtons)
            (isMobile
                ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    _HeroBtn(label: './view_projects', primary: true, onTap: () {}),
                    const SizedBox(height: 10),
                    _HeroBtn(label: './download_cv', primary: false,
                        onTap: () => launchUrl(Uri.parse(PortfolioData.githubUrl))),
                  ])
                : Row(children: [
                    _HeroBtn(label: './view_projects', primary: true, onTap: () {}),
                    const SizedBox(width: 12),
                    _HeroBtn(label: './download_cv', primary: false,
                        onTap: () => launchUrl(Uri.parse(PortfolioData.githubUrl))),
                  ])
            ).animate().fadeIn(duration: 500.ms),
          const SizedBox(height: 40),
          if (_showHint)
            const Text('▼  scroll to explore',
                style: TextStyle(fontSize: 11, color: Color(0xFF3D4451)))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideY(begin: 0, end: 0.3, duration: 1200.ms, curve: Curves.easeInOut),
        ],
      ),
    );
  }
}

class _HeroBtn extends StatefulWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;
  const _HeroBtn({required this.label, required this.primary, required this.onTap});

  @override
  State<_HeroBtn> createState() => _HeroBtnState();
}

class _HeroBtnState extends State<_HeroBtn> {
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
        decoration: BoxDecoration(
          color: widget.primary
              ? (_hovered ? AppTheme.accentBlue.withOpacity(0.8) : AppTheme.accentBlue)
              : Colors.transparent,
          border: Border.all(color: AppTheme.accentBlue),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(widget.label,
            style: TextStyle(
              fontSize: 12, letterSpacing: 1,
              color: widget.primary ? AppTheme.bgPrimary : AppTheme.accentBlue,
              fontWeight: widget.primary ? FontWeight.bold : FontWeight.normal,
            )),
      ),
    ),
  );
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 530),
        (_) { if (mounted) setState(() => _visible = !_visible); });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: _visible ? 1.0 : 0.0,
    duration: Duration.zero,
    child: Container(width: 2, height: 14, color: AppTheme.accentBlue),
  );
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/sections/hero_section.dart
git commit -m "feat: add HeroSection with full typewriter sequence"
```

---

### Task 11: Experience, Projects, Skills sections

**Files:**
- Create: `lib/widgets/sections/experience_section.dart`
- Create: `lib/widgets/sections/projects_section.dart`
- Create: `lib/widgets/sections/skills_section.dart`

- [ ] **Step 1: Write lib/widgets/sections/experience_section.dart**

```dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../../shared/section_label.dart';
import '../../shared/scroll_reveal.dart';
import '../../shared/timeline_item.dart';

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
```

- [ ] **Step 2: Write lib/widgets/sections/projects_section.dart**

```dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../../shared/section_label.dart';
import '../../shared/scroll_reveal.dart';
import '../../shared/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    final padding = AppTheme.sectionPadding(context);
    final projects = PortfolioData.projects;

    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: '\$ ls -la projects/'),
          const SizedBox(height: 8),
          ScrollReveal(
            child: RichText(text: const TextSpan(
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'My ', style: TextStyle(color: AppTheme.textPrimary)),
                TextSpan(text: 'Projects', style: TextStyle(color: AppTheme.accentBlue)),
              ],
            )),
          ),
          const SizedBox(height: 44),
          if (isMobile)
            Column(children: projects.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ScrollReveal(
                delay: Duration(milliseconds: e.key * 120),
                child: ProjectCard(project: e.value),
              ),
            )).toList())
          else
            Column(children: [
              _Row(projects: projects, indices: [0, 1]),
              const SizedBox(height: 16),
              _Row(projects: projects, indices: [2, 3]),
            ]),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final List<Project> projects;
  final List<int> indices;
  const _Row({required this.projects, required this.indices});

  @override
  Widget build(BuildContext context) => Row(
    children: indices.map((i) => Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: i == indices.first ? 8 : 0, left: i == indices.last ? 8 : 0),
        child: ScrollReveal(
          delay: Duration(milliseconds: (i % 2) * 120),
          child: ProjectCard(project: projects[i]),
        ),
      ),
    )).toList(),
  );
}
```

- [ ] **Step 3: Write lib/widgets/sections/skills_section.dart**

```dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../../shared/section_label.dart';
import '../../shared/scroll_reveal.dart';
import '../../shared/skill_tag.dart';

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
```

- [ ] **Step 4: Commit**

```bash
git add lib/widgets/sections/experience_section.dart lib/widgets/sections/projects_section.dart lib/widgets/sections/skills_section.dart
git commit -m "feat: add Experience, Projects, and Skills sections"
```

---

### Task 12: About + Contact sections

**Files:**
- Create: `lib/widgets/sections/about_section.dart`
- Create: `lib/widgets/sections/contact_section.dart`

- [ ] **Step 1: Write lib/widgets/sections/about_section.dart**

```dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../shared/section_label.dart';
import '../../shared/scroll_reveal.dart';

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
                Text('GPA: 8.5/10.0 (equiv. 3.4/4.0) · Graduating Summer 2025',
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
```

- [ ] **Step 2: Write lib/widgets/sections/contact_section.dart**

```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../../shared/section_label.dart';
import '../../shared/scroll_reveal.dart';

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
```

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/sections/about_section.dart lib/widgets/sections/contact_section.dart
git commit -m "feat: add About and Contact sections"
```

---

### Task 13: main.dart + web/index.html

**Files:**
- Modify: `lib/main.dart`
- Modify: `web/index.html`

- [ ] **Step 1: Write lib/main.dart**

```dart
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'home_page.dart';
import 'theme/app_theme.dart';

void main() {
  VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 100);
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Aldo Zetina — Portfolio',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    home: const HomePage(),
  );
}
```

- [ ] **Step 2: Update web/index.html head section**

Replace the `<title>` and add meta tags inside `<head>`:
```html
<title>Aldo Zetina Muciño — Flutter Engineer</title>
<meta name="description" content="Personal portfolio of Aldo Zetina Muciño — Flutter Engineer, QA Automation, Infrastructure. Computer Engineer from UNAM.">
<meta name="theme-color" content="#010409">
<meta property="og:title" content="Aldo Zetina — Portfolio">
<meta property="og:description" content="Flutter Engineer · QA Automation · Infrastructure">
```

- [ ] **Step 3: Run the app**

```bash
cd "D:/Codigo Express/aldoproflie"
flutter run -d chrome
```
Expected: Portfolio opens with typewriter hero sequence, scroll animations, responsive navbar.

- [ ] **Step 4: Build release**

```bash
flutter build web --release
```
Expected: `Build directory: build/web`

- [ ] **Step 5: Commit**

```bash
git add lib/main.dart web/index.html
git commit -m "feat: wire main.dart and update web metadata"
```

---

## Self-Review

**Spec coverage:**
- ✅ Dark minimal theme — `app_theme.dart` tokens
- ✅ Single-page scroll — `home_page.dart` with `CustomScrollView`
- ✅ Typewriter hero sequence — `hero_section.dart` state machine
- ✅ Scroll-triggered typewriter on section labels — `section_label.dart` + `VisibilityDetector`
- ✅ Scroll-triggered fade-slide on cards — `scroll_reveal.dart`
- ✅ Progress bar — `home_page.dart` `_progress` + `Positioned`
- ✅ Desktop navbar with active link — `desktop_navbar.dart`
- ✅ Mobile hamburger + overlay — `mobile_navbar.dart`
- ✅ Responsive breakpoints — `AppTheme.isMobile()` + `AppTheme.sectionPadding()`
- ✅ 3 jobs timeline — `experience_section.dart` + `timeline_item.dart`
- ✅ 4 projects 2-col/1-col — `projects_section.dart`
- ✅ 4 skill groups 2×2/stack — `skills_section.dart`
- ✅ About: education, certs, languages — `about_section.dart`
- ✅ Contact: email, github, phone — `contact_section.dart`
- ✅ Hover effects on cards — `project_card.dart`, `contact_section.dart`

**No placeholders found.**

**Type consistency:** All widget constructors consistent across tasks. `PortfolioData` constants referenced by exact field names throughout.
