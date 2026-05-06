# Aldo Zetina — Portfolio

Personal portfolio built with Flutter Web. Dark terminal aesthetic, typewriter animations, scroll reveal effects, fully responsive.

**Live:** https://aldozm.github.io/aldoproflie/

---

## Stack

- Flutter Web (Dart)
- `google_fonts` — Source Code Pro
- `flutter_animate` — hero button/hint animations
- `visibility_detector` — scroll-triggered reveals
- `url_launcher` — contact links

## Project Structure

```
lib/
├── main.dart                    # App entry, MaterialApp
├── home_page.dart               # Scroll controller, progress bar, navbar
├── theme/
│   └── app_theme.dart           # Colors, breakpoints, padding helpers
├── data/
│   └── portfolio_data.dart      # All content (jobs, projects, skills)
└── widgets/
    ├── navbar/
    │   ├── desktop_navbar.dart  # Sticky horizontal nav with active link
    │   └── mobile_navbar.dart   # Hamburger + full-screen overlay
    ├── sections/
    │   ├── hero_section.dart    # Typewriter sequence on load
    │   ├── experience_section.dart
    │   ├── projects_section.dart
    │   ├── skills_section.dart
    │   ├── about_section.dart
    │   └── contact_section.dart
    └── shared/
        ├── typewriter_text.dart # Timer-based character-by-character animation
        ├── scroll_reveal.dart   # Fade+slide on scroll enter (VisibilityDetector)
        ├── section_label.dart   # $ cat ... green label, typewriter on scroll
        ├── skill_tag.dart       # Colored skill pill (blue/green/gray)
        ├── terminal_card.dart   # Terminal-style container
        ├── project_card.dart    # Hoverable project card
        └── timeline_item.dart   # Timeline dot + job content
```

## Responsive Breakpoints

| Breakpoint | Width |
|---|---|
| Mobile | < 600px |
| Desktop | > 1024px |

## Local Development

```bash
# Install dependencies
flutter pub get

# Run in browser (Edge)
flutter run -d edge

# Run in Chrome
flutter run -d chrome
```

## Deploy to GitHub Pages

> **Windows:** use PowerShell for the build step — bash mangles the `--base-href` flag.

```powershell
# Build with correct base-href (PowerShell)
flutter build web --release --base-href "/aldoproflie/"
```

```bash
# Copy build output to gh-pages branch and push (Git Bash / WSL)
# First time only: git worktree add /tmp/gh-pages gh-pages
cp -r build/web/. /tmp/gh-pages/
cd /tmp/gh-pages && git add -A && git commit -m "deploy: update build" && git push origin gh-pages
```

## Update Content

All content lives in `lib/data/portfolio_data.dart`:
- `PortfolioData.jobs` — work experience timeline
- `PortfolioData.projects` — project cards
- `PortfolioData.skillGroups` — skill tags by category
- `PortfolioData.email/phone/githubUrl` — contact info
