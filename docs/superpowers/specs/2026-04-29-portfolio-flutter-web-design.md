# Portfolio Flutter Web — Design Spec
**Date:** 2026-04-29  
**Status:** Approved

---

## Overview

Personal portfolio web app for Aldo Zetina Muciño built with **Flutter Web**. Target: recruiters + personal showcase. Dark minimal terminal aesthetic with typewriter animations triggered on scroll.

---

## Architecture

- **Framework:** Flutter Web (Dart)
- **Routing:** Sin router — `SingleChildScrollView` + `ScrollController` con anchor keys. URLs se actualizan con `html.window.location.hash` via `dart:js`
- **State:** No external state manager needed — local `StatefulWidget` + `ScrollController`
- **Responsive:** `LayoutBuilder` + `MediaQuery` — breakpoints: mobile <600px, tablet 600–1024px, desktop >1024px
- **Fonts:** Google Fonts — `Source Code Pro` (monospace body), `Space Grotesk` (headings)
- **Animations:** `flutter_animate` package for typewriter + fade-slide effects

---

## Folder Structure

```
aldoproflie/
├── lib/
│   ├── main.dart                  # app entry, MaterialApp, theme
│   ├── theme/
│   │   └── app_theme.dart         # colors, text styles, constants
│   ├── data/
│   │   └── portfolio_data.dart    # all content (jobs, projects, skills) as Dart constants
│   ├── widgets/
│   │   ├── navbar/
│   │   │   ├── desktop_navbar.dart
│   │   │   └── mobile_navbar.dart  # hamburger + overlay menu
│   │   ├── sections/
│   │   │   ├── hero_section.dart
│   │   │   ├── experience_section.dart
│   │   │   ├── projects_section.dart
│   │   │   ├── skills_section.dart
│   │   │   └── contact_section.dart
│   │   └── shared/
│   │       ├── terminal_card.dart      # reusable terminal-style box
│   │       ├── typewriter_text.dart    # typewriter animation widget
│   │       ├── section_label.dart      # "$ cat ..." green label
│   │       ├── skill_tag.dart
│   │       ├── project_card.dart
│   │       └── timeline_item.dart
│   └── home_page.dart             # SingleChildScrollView, assembles all sections
├── web/
│   └── index.html
├── pubspec.yaml
├── img/                           # existing logo assets
└── docs/
    └── superpowers/specs/
        └── 2026-04-29-portfolio-flutter-web-design.md
```

---

## Visual Design

| Token | Value |
|---|---|
| Background | `#010409` |
| Surface | `#0d1117` |
| Border | `#21262d` / `#30363d` |
| Accent blue | `#58a6ff` |
| Accent green | `#3fb950` |
| Accent red (unused) | `#f85149` |
| Text primary | `#e6edf3` |
| Text secondary | `#8b949e` |
| Navbar height desktop | 60px (padding 18px 72px) |
| Navbar height mobile | 52px (padding 14px 20px) |
| Section padding desktop | 100px top/bottom, 96px horizontal |
| Section padding mobile | 48px top/bottom, 22px horizontal |

---

## Sections & Content

### `/` → Home (Hero)
- Typewriter sequence on load (no scroll trigger):
  1. `$ whoami` (green, 40ms/char)
  2. `Aldo Zetina Muciño` (white bold, 45ms/char, 600ms delay)
  3. `Flutter Engineer · QA Automation · Infrastructure` (blue, 18ms/char)
  4. Description paragraph (gray, 12ms/char)
  5. Terminal card fades in → types `cat about.txt` → output lines appear sequentially
  6. Buttons + scroll hint fade in
- Buttons: `./view_projects` (primary filled) | `./download_cv` (outlined)
- Progress bar: 2px gradient strip, sticky top, width = scroll %

### `#experience`
- Section label `$ cat experience.log` — typewriter on scroll enter
- Timeline with left border + dot indicators
- 3 jobs from CV (chronological desc):
  1. **Banco de México** — Network Infrastructure Intern (Fall 2024–Spring 2026) — green dot + glow (current)
  2. **Grupo Salinas / Elektra.mx** — QA Automation Engineer Intern (Summer 2022–Spring 2024)
  3. **Huawei** — NFV Engineer (Summer 2021–Spring 2022)
- Each card: fade-slide in with staggered delay (0ms, 140ms, 280ms)

### `#projects`
- Section label `$ ls -la projects/`
- Desktop: 2-col grid | Mobile: 1-col stack
- 4 projects (priority order):
  1. VR Medical Simulation — Código Infarto (Unity, C#, VRChat SDK)
  2. Home Lab & Server Administration (Linux, Docker, Networking)
  3. Advanced SQL & Java — PROTECO UNAM (Java, SQL Server, Hibernate)
  4. Space Invader 2 Players (Python, pygame, Threading)
- Each card: hover → border-color #58a6ff + translateY(-3px) + glow shadow
- GitHub link button on each card (where applicable)

### `#skills`
- Section label `$ cat skills.json`
- Desktop: 2×2 grid | Mobile: vertical stack
- 4 groups: Mobile, Languages, DevOps & Infra, Backend & APIs
- Tag colors: primary skills = blue, devops = green, others = gray

### `#about`
- Education: UNAM B.S. Computer Engineering (GPA 8.5/10, graduating Summer 2025)
- Certifications: Advanced SQL PROTECO (Honorable Mention), Java Developer PROTECO
- Languages: Spanish (Native), English (Advanced), Japanese (Basic)

### `#contact`
- Section label `$ cat contact.txt`
- 3 cards: Email, GitHub, Phone
- Desktop: horizontal row | Mobile: vertical stack

---

## Navigation

### Desktop
- Sticky navbar: logo left, links right (`#home #experience #projects #skills #about #contact`)
- Active link = `#58a6ff` — updated via `ScrollController` listener
- Smooth scroll to anchor on click

### Mobile
- Hamburger (3 lines) top right
- Tap → full-screen overlay menu, links centered, font-size 20px
- X button closes overlay
- Same scroll-to-anchor behavior

---

## Animation System

### TypewriterText widget
- Takes `String text`, `int speed` (ms/char), `int startDelay` (ms)
- Uses `Timer.periodic` to append characters
- Shows inline blinking cursor (`|`) while typing, removes on complete
- Triggered by: `VisibilityDetector` (scroll) or called directly (hero)

### ScrollReveal (fade-slide)
- `VisibilityDetector` wraps each card/section
- On first visibility: `AnimationController` plays opacity 0→1 + translateY 18→0
- `staggerDelay` parameter for sequential card reveals

### Progress bar
- `ScrollController` listener on `SingleChildScrollView`
- Width = `scrollOffset / maxScrollExtent * 100%`

---

## Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.0.0
  flutter_animate: ^4.0.0
  visibility_detector: ^0.4.0
  url_launcher: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

---

## Responsive Behavior

| Element | Desktop (>1024px) | Mobile (<600px) |
|---|---|---|
| Navbar | Full links | Hamburger + overlay |
| Hero name font | 60px | 30px |
| Hero buttons | Row | Column |
| Projects | 2-col grid | 1-col |
| Skills | 2×2 grid | Vertical stack |
| Contact | Row | Column |
| Section padding | 100px / 96px | 48px / 22px |

---

## Out of Scope
- Backend / form submission (contact form)
- Blog section
- Dark/light toggle
- i18n
