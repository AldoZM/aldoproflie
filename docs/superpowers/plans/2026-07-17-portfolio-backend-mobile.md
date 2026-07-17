# Portafolio — Reposicionamiento Backend & Mobile — Plan de Implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reposicionar el portafolio Flutter Web como *Software Engineer · Backend & APIs · Mobile*, con la evidencia de backend en la página misma.

**Architecture:** Refactor incremental sobre la app existente. El modelo `Project` gana capas de stack y campos narrativos de forma **aditiva** (los campos viejos se retiran hasta el final), de modo que el árbol compile y las pruebas pasen al terminar **cada** tarea. Sin router nuevo, sin gestor de estado, sin cambios al sistema visual.

**Tech Stack:** Flutter 3.41.2 · Dart 3.11.0 · `google_fonts` · `flutter_animate` · `visibility_detector` · `url_launcher` · GitHub Actions

**Spec:** `docs/superpowers/specs/2026-07-17-portfolio-backend-mobile-design.md`

## Global Constraints

- **Idioma del contenido publicado: inglés.** Sin excepciones. Los comentarios de código y esta documentación van en español.
- **Nombre correcto: `Aldo Zetina Muciño`.** Nunca "Muñino" (el CV tiene ese error; el código no).
- **Titular canónico:** `Software Engineer · Backend & APIs · Mobile`. Se usa idéntico en hero, `<title>`, `description` y `og:description`.
- **Nunca renderizar un enlace a repositorio que no sea público.** Sin `githubUrl` → se renderiza `note`.
- **Repositorio público:** no commitear el CV (tiene el error del apellido) ni detalles de seguridad de otros repositorios.
- **Commits:** sin firma de IA, sin `Co-Authored-By`.
- **Ejecutar `flutter` y `git` desde PowerShell**, no desde Bash (Bash de este entorno no tiene `git` en el PATH).
- Estética terminal oscura existente: no se toca. Colores en `lib/theme/app_theme.dart`.

## Estado inicial verificado (2026-07-17)

Bugs en vivo que este plan corrige:

| Archivo | Bug |
|---|---|
| `test/widget_test.dart` | Plantilla por defecto: llama `MyApp()`, `main.dart` exporta `PortfolioApp`. **No compila.** |
| `projects_section.dart:43-47` | Rejilla codificada a índices `[0,1]`/`[2,3]`. La lista tiene 5. **Food Match nunca se renderiza en escritorio.** |
| `hero_section.dart:132,138` | `./view_projects` → `onTap: () {}`, no hace nada. |
| `hero_section.dart:134,140` | `./download_cv` → abre GitHub, no el CV. |
| `hero_section.dart:86` | Titular: `Database Engineer · QA Automation · Flutter Developer`. |
| `hero_section.dart:116` | `Database Engineering Intern` (el CV dice Software Engineer Intern). |
| `portfolio_data.dart:113` | `githubUrl` a un repositorio privado → 404 para todo visitante. |
| `portfolio_data.dart:111` | Descripción en español entre contenido en inglés. |
| `web/index.html:21,24,36` | Metadata dice `Flutter Engineer · QA Automation`. |
| `assets/img/*` | 654 KB, **cero** referencias `Image.asset`/`AssetImage` en `lib/`. |

---

### Task 1: Reparar la suite de pruebas

Sin esto no hay ciclo TDD: `flutter test` no compila.

**Files:**
- Create: `test/helpers.dart`
- Modify: `test/widget_test.dart` (reemplazo completo)

**Interfaces:**
- Consumes: `PortfolioApp` de `lib/main.dart:11`
- Produces: `pumpPortfolio(WidgetTester, {Size size})` en `test/helpers.dart` — helper reutilizado por todas las tareas siguientes. Vive en su propio archivo, no en `widget_test.dart`: importar un archivo de pruebas desde otro funciona pero es un olor, y `helpers.dart` no termina en `_test.dart`, así que el runner no intenta ejecutarlo.

- [ ] **Step 1: Confirmar que la suite está rota**

Run: `flutter test`
Expected: FAIL en compilación — `Method not found: 'MyApp'`

- [ ] **Step 2: Crear el helper compartido**

Contenido completo de `test/helpers.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/main.dart';

/// Monta la app con un viewport fijo. `size` por defecto = escritorio.
///
/// Bombea en ciclos en vez de usar `pumpAndSettle()`: el cursor del hero es un
/// `Timer.periodic` perpetuo (`hero_section.dart:197`, `typewriter_text.dart:64`)
/// y `pumpAndSettle` nunca convergería. 10s cubren la secuencia completa del
/// hero (~2.6s de delays encadenados más el tecleo carácter por carácter).
Future<void> pumpPortfolio(
  WidgetTester tester, {
  Size size = const Size(1400, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const PortfolioApp());
  for (int i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

/// Busca texto renderizado por `TypewriterText`.
///
/// `find.text()` NO sirve para esos textos: solo encuentra `Text` y
/// `EditableText`, y `TypewriterText.build` devuelve un `RichText`
/// (`typewriter_text.dart:82`). Sin esto, las aserciones sobre el nombre,
/// el titular y la descripción del hero fallan aunque el texto sí esté en
/// pantalla. `includePlaceholders: false` descarta el WidgetSpan del cursor.
Finder findTypewriterText(String text) => find.byWidgetPredicate(
      (w) =>
          w is RichText &&
          w.text.toPlainText(includePlaceholders: false).contains(text),
      description: 'RichText que contiene "$text"',
    );
```

- [ ] **Step 3: Reemplazar la plantilla por un smoke test real**

Las aserciones deben verificar **contenido de esta app**, no que exista un
`Scaffold`: cualquier app de Flutter en blanco tiene uno, así que una prueba
así pasa siempre y no protege nada.

Contenido completo de `test/widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() {
  testWidgets('la app monta y renderiza el nombre', (tester) async {
    await pumpPortfolio(tester);
    expect(findTypewriterText('Aldo Zetina Muciño'), findsOneWidget);
  });

  testWidgets('renderiza el scroll principal', (tester) async {
    await pumpPortfolio(tester);
    expect(find.byType(CustomScrollView), findsOneWidget);
  });
}
```

- [ ] **Step 4: Verificar que pasa**

Run: `flutter test`
Expected: PASS — 2 pruebas.

- [ ] **Step 5: Commit**

```powershell
git add test/helpers.dart test/widget_test.dart
git commit -m "test: replace default counter template with real smoke test"
```

---

### Task 2: Modelo `StackLayer` y campos nuevos en `Project`

Aditivo: `description` y `tags` se conservan para que `ProjectCard` siga compilando. Se retiran en la Task 5.

**Files:**
- Modify: `lib/data/portfolio_data.dart:28-39`
- Test: `test/project_model_test.dart` (crear)

**Interfaces:**
- Produces:
  - `class StackLayer { final String label; final List<String> techs; const StackLayer(this.label, this.techs); }`
  - `Project` con: `icon`, `name`, `period`, `summary`, `role`, `highlights` (`List<String>`), `stack` (`List<StackLayer>`), `githubUrl` (`String?`), `note` (`String?`), más los legados `description` y `tags`.

**Sin campo `images`.** La spec lo contemplaba para capturas de Food Match, pero
no existen (la carpeta del proyecto no está en esta máquina) y ninguna tarea lo
lee. Un campo que nadie usa es YAGNI. Se añade cuando haya capturas que poner.

- [ ] **Step 1: Escribir la prueba que falla**

Crear `test/project_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';

void main() {
  test('StackLayer expone label y techs', () {
    const layer = StackLayer('Backend', ['Node.js', 'Express']);
    expect(layer.label, 'Backend');
    expect(layer.techs, ['Node.js', 'Express']);
  });

  test('Project sin githubUrl conserva note y no url', () {
    const p = Project(
      icon: '🍔',
      name: 'Food Match',
      period: '2026',
      summary: 'summary',
      role: 'Solo developer',
      highlights: ['h1'],
      stack: [StackLayer('Backend', ['Node.js'])],
      githubUrl: null,
      note: 'Private repository',
      description: 'legacy',
      tags: ['Flutter'],
    );
    expect(p.githubUrl, isNull);
    expect(p.note, 'Private repository');
  });
}
```

- [ ] **Step 2: Ejecutar y verificar que falla**

Run: `flutter test test/project_model_test.dart`
Expected: FAIL en compilación — `StackLayer` no existe.

- [ ] **Step 3: Implementar el modelo**

Reemplazar la clase `Project` en `lib/data/portfolio_data.dart:28-39` por:

```dart
class StackLayer {
  final String label;          // "Backend", "Mobile", "Infrastructure"
  final List<String> techs;
  const StackLayer(this.label, this.techs);
}

class Project {
  final String icon;
  final String name;
  final String period;
  final String summary;              // visible con la tarjeta cerrada
  final String role;                 // qué hizo él, no el equipo
  final List<String> highlights;     // viñetas al expandir
  final List<StackLayer> stack;
  final String? githubUrl;           // null = sin enlace
  final String? note;                // "Private repository", etc.

  // Legados: los retira la Task 5, cuando ProjectCard deje de usarlos.
  final String description;
  final List<String> tags;

  const Project({
    required this.icon,
    required this.name,
    required this.period,
    required this.summary,
    required this.role,
    required this.highlights,
    required this.stack,
    this.githubUrl,
    this.note,
    required this.description,
    required this.tags,
  });
}
```

- [ ] **Step 4: Ejecutar la prueba del modelo**

Run: `flutter test test/project_model_test.dart`
Expected: PASS — 2 pruebas.

- [ ] **Step 5: Verificar que la suite completa aún compila**

Run: `flutter test`
Expected: FAIL — los 5 `Project(...)` existentes en `portfolio_data.dart:83-115` no tienen los campos requeridos nuevos. **Es esperado**; lo resuelve la Task 3. No commitear todavía.

- [ ] **Step 6: Rellenar los proyectos existentes con valores mínimos**

Para que el árbol compile antes de reescribir el contenido en la Task 3, añadir a **cada uno** de los 5 `Project(...)` existentes los campos `period: '—'`, `summary: ''`, `role: ''`, `highlights: const []`, `stack: const []`. No tocar `description` ni `tags`.

- [ ] **Step 7: Verificar suite verde**

Run: `flutter test`
Expected: PASS — 4 pruebas.

- [ ] **Step 8: Commit**

```powershell
git add lib/data/portfolio_data.dart test/project_model_test.dart
git commit -m "feat: add StackLayer and narrative fields to Project model"
```

---

### Task 3: Los tres proyectos y la rejilla dinámica

Corrige el bug de índices codificados que hace invisible a Food Match en escritorio.

**Files:**
- Modify: `lib/data/portfolio_data.dart:83-115` (lista `projects`, reemplazo completo)
- Modify: `lib/widgets/sections/projects_section.dart:34-47` y `54-71`
- Test: `test/projects_section_test.dart` (crear)

**Interfaces:**
- Consumes: `Project`, `StackLayer` (Task 2)
- Produces: `PortfolioData.projects` con exactamente 3 entradas, orden: Banxico, Food Match, Elektra.

- [ ] **Step 1: Escribir la prueba que falla**

Crear `test/projects_section_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'package:aldo_portfolio/widgets/shared/project_card.dart';
import 'helpers.dart';

void main() {
  test('hay exactamente 3 proyectos, backend primero', () {
    expect(PortfolioData.projects.length, 3);
    expect(PortfolioData.projects[0].name, 'Institutional Email Automation Platform');
    expect(PortfolioData.projects[1].name, 'Food Match');
    expect(PortfolioData.projects[2].name, 'Elektra Shopping Cart');
  });

  test('ningún proyecto enlaza a un repositorio no público', () {
    for (final p in PortfolioData.projects) {
      if (p.githubUrl == null) {
        expect(p.note, isNotNull,
            reason: '${p.name}: sin githubUrl debe tener note');
      }
    }
  });

  testWidgets('escritorio renderiza los 3 proyectos sin RangeError', (tester) async {
    await pumpPortfolio(tester, size: const Size(1400, 900));
    expect(tester.takeException(), isNull);
    expect(find.byType(ProjectCard), findsNWidgets(3));
  });

  testWidgets('móvil renderiza los 3 proyectos', (tester) async {
    await pumpPortfolio(tester, size: const Size(420, 900));
    expect(tester.takeException(), isNull);
    expect(find.byType(ProjectCard), findsNWidgets(3));
  });
}
```

- [ ] **Step 2: Ejecutar y verificar que falla**

Run: `flutter test test/projects_section_test.dart`
Expected: FAIL — hay 5 proyectos, no 3.

- [ ] **Step 3: Reemplazar la lista `projects`**

Reemplazar `portfolio_data.dart:83-115` completo por:

```dart
  static const List<Project> projects = [
    Project(
      icon: '🏦',
      name: 'Institutional Email Automation Platform',
      period: '2024–2026',
      summary: 'An internal fullstack platform automating institutional email '
               'workflows at Mexico\'s central bank.',
      role: 'Software Engineer Intern — Banco de México',
      highlights: [
        'Built a Java/Spring backend exposing REST endpoints over a relational store.',
        'Developed the JavaScript frontend and the supporting Python services.',
        'Integrated the platform with the bank\'s user-directory infrastructure.',
      ],
      stack: [
        StackLayer('Backend', ['Java', 'Spring Boot', 'JPA', 'REST']),
        StackLayer('Frontend', ['JavaScript']),
        StackLayer('Data', ['SQL']),
        StackLayer('Services', ['Python']),
      ],
      githubUrl: null,
      note: 'Internal software — not publicly available',
      description: '',
      tags: [],
    ),
    Project(
      icon: '🍔',
      name: 'Food Match',
      period: '2026',
      summary: 'A decision-making app for two people sharing one phone: swipe '
               'through food cards and a Bayesian scoring engine narrows down '
               'what you both want to eat, then finds real restaurants nearby.',
      role: 'Solo developer — mobile app, backend, and deployment',
      highlights: [
        'Designed a Bayesian scoring engine that updates weights across all '
        'cuisine types on every swipe, converging on a shared preference in '
        '6–10 questions.',
        'Built a Node.js/Express backend that proxies the Google Places API, '
        'keeping the API key server-side so it never ships in the mobile client.',
        'Containerized the backend with Docker and deployed it to Google Cloud Run.',
        'Extracted pure helpers to make request building and response mapping '
        'unit-testable under node:test.',
      ],
      stack: [
        StackLayer('Mobile', ['Flutter', 'Dart', 'Geolocator']),
        StackLayer('Backend', ['Node.js', 'Express', 'REST']),
        StackLayer('Infrastructure', ['Docker', 'Google Cloud Run']),
      ],
      githubUrl: null,
      note: 'Private repository',
      description: '',
      tags: [],
    ),
    Project(
      icon: '🛒',
      name: 'Elektra Shopping Cart',
      period: '2022–2024',
      summary: 'Core shopping-cart functionality for Elektra\'s high-traffic '
               'e-commerce mobile app, shipped during its initial build phase.',
      role: 'Fullstack & Multiplatform QA Engineer — Grupo Salinas',
      highlights: [
        'Implemented core shopping cart features in Java, shipping product code '
        'alongside the engineering team.',
        'Applied object-oriented design against a high-traffic production codebase.',
      ],
      stack: [
        StackLayer('Backend', ['Java']),
        StackLayer('Mobile', ['Native & hybrid apps']),
      ],
      githubUrl: null,
      note: 'Proprietary — not publicly available',
      description: '',
      tags: [],
    ),
  ];
```

- [ ] **Step 4: Hacer dinámica la rejilla de escritorio**

Reemplazar `projects_section.dart:34-47` por:

```dart
          if (isMobile)
            Column(children: projects.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ScrollReveal(
                delay: Duration(milliseconds: e.key * 120),
                child: ProjectCard(project: e.value),
              ),
            )).toList())
          else
            // Filas de 2. Se calculan a partir de la lista: no codificar índices.
            Column(
              children: [
                for (int i = 0; i < projects.length; i += 2) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _Row(
                    projects: projects,
                    indices: [
                      for (int j = i; j < i + 2 && j < projects.length; j++) j,
                    ],
                  ),
                ],
              ],
            ),
```

- [ ] **Step 5: Hacer que `_Row` tolere filas incompletas**

Con 3 proyectos la última fila tiene 1. Reemplazar `projects_section.dart:54-71` por:

```dart
class _Row extends StatelessWidget {
  final List<Project> projects;
  final List<int> indices;
  const _Row({required this.projects, required this.indices});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (int slot = 0; slot < 2; slot++)
        Expanded(
          child: slot < indices.length
              ? Padding(
                  padding: EdgeInsets.only(
                    right: slot == 0 ? 8 : 0,
                    left: slot == 1 ? 8 : 0,
                  ),
                  child: ScrollReveal(
                    delay: Duration(milliseconds: slot * 120),
                    child: ProjectCard(project: projects[indices[slot]]),
                  ),
                )
              // Hueco: mantiene el ancho de columna cuando la fila va incompleta.
              : const SizedBox.shrink(),
        ),
    ],
  );
}
```

- [ ] **Step 6: Ejecutar las pruebas**

Run: `flutter test`
Expected: PASS — 8 pruebas.

- [ ] **Step 7: Commit**

```powershell
git add lib/data/portfolio_data.dart lib/widgets/sections/projects_section.dart test/projects_section_test.dart
git commit -m "feat: three backend-first projects with dynamic desktop grid

Reemplaza los 5 proyectos por 3 (Banxico, Food Match, Elektra) alineados
con el CV. La rejilla de escritorio tenía los índices [0,1]/[2,3] codificados,
lo que dejaba Food Match sin renderizar y habría reventado con 3 proyectos."
```

---

### Task 4: Tarjeta expandible

**Files:**
- Modify: `lib/widgets/shared/project_card.dart` (reemplazo completo)
- Modify: `lib/widgets/sections/projects_section.dart` (pasa a `StatefulWidget`)
- Test: `test/project_card_test.dart` (crear)

**Interfaces:**
- Consumes: `Project`, `StackLayer` (Task 2)
- Produces: `ProjectCard({required Project project, required bool expanded, required VoidCallback onTap})` — el estado vive en `ProjectsSection`.

- [ ] **Step 1: Escribir la prueba que falla**

Crear `test/project_card_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'package:aldo_portfolio/theme/app_theme.dart';
import 'package:aldo_portfolio/widgets/shared/project_card.dart';

const _sample = Project(
  icon: '🍔',
  name: 'Food Match',
  period: '2026',
  summary: 'Summary line.',
  role: 'Solo developer',
  highlights: ['Built a Node.js/Express backend.'],
  stack: [
    StackLayer('Mobile', ['Flutter']),
    StackLayer('Backend', ['Node.js', 'Express']),
  ],
  githubUrl: null,
  note: 'Private repository',
  description: '',
  tags: [],
);

Future<void> _pumpCard(
  WidgetTester tester, {
  required bool expanded,
  VoidCallback? onTap,
}) async {
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.theme,
    home: Scaffold(
      body: ProjectCard(
        project: _sample,
        expanded: expanded,
        onTap: onTap ?? () {},
      ),
    ),
  ));
}

void main() {
  testWidgets('cerrada muestra nombre y summary', (tester) async {
    await _pumpCard(tester, expanded: false);
    expect(find.text('Food Match'), findsOneWidget);
    expect(find.text('Summary line.'), findsOneWidget);
  });

  testWidgets('cerrada NO muestra highlights ni role', (tester) async {
    await _pumpCard(tester, expanded: false);
    expect(find.text('Solo developer'), findsNothing);
    expect(find.textContaining('Node.js/Express backend'), findsNothing);
  });

  testWidgets('abierta muestra role, highlights y capas de stack', (tester) async {
    await _pumpCard(tester, expanded: true);
    await tester.pumpAndSettle();
    expect(find.text('Solo developer'), findsOneWidget);
    expect(find.textContaining('Node.js/Express backend'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Backend'), findsOneWidget);
  });

  testWidgets('sin githubUrl renderiza note y NO renderiza enlace', (tester) async {
    await _pumpCard(tester, expanded: true);
    await tester.pumpAndSettle();
    expect(find.text('Private repository'), findsOneWidget);
    expect(find.textContaining('View on GitHub'), findsNothing);
  });

  testWidgets('Enter activa la tarjeta', (tester) async {
    var taps = 0;
    await _pumpCard(tester, expanded: false, onTap: () => taps++);

    FocusScope.of(tester.element(find.byType(ProjectCard))).nextFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('Espacio activa la tarjeta', (tester) async {
    var taps = 0;
    await _pumpCard(tester, expanded: false, onTap: () => taps++);

    FocusScope.of(tester.element(find.byType(ProjectCard))).nextFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(taps, 1);
  });
}
```

- [ ] **Step 2: Ejecutar y verificar que falla**

Run: `flutter test test/project_card_test.dart`
Expected: FAIL — `ProjectCard` no acepta `expanded` ni `onTap`.

- [ ] **Step 3: Reescribir `ProjectCard`**

Reemplazo completo de `lib/widgets/shared/project_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final bool expanded;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.expanded,
    required this.onTap,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  /// Enter y Espacio activan la tarjeta igual que el clic. Sin esto la
  /// sección es inalcanzable con teclado y con lector de pantalla.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      widget.onTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final active = _hovered || widget.expanded;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: Focus(
        onKeyEvent: _onKey,
        child: Builder(builder: (context) {
          final focused = Focus.of(context).hasFocus;
          return GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              transform: Matrix4.translationValues(0, active ? -3 : 0, 0),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                border: Border.all(
                  color: (active || focused) ? AppTheme.accentBlue : AppTheme.borderSubtle,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: active
                    ? [BoxShadow(
                        color: AppTheme.accentBlue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      )]
                    : [],
              ),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.icon, style: const TextStyle(fontSize: 28)),
                        const Spacer(),
                        Text(p.period,
                            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    Text(p.summary,
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.textSecondary, height: 1.8)),
                    const SizedBox(height: 14),
                    // Cerrada: solo las etiquetas de capa. Abierta: el detalle.
                    if (!widget.expanded)
                      Wrap(
                        spacing: 6, runSpacing: 6,
                        children: p.stack.map((l) => _LayerChip(label: l.label)).toList(),
                      )
                    else
                      _Details(project: p),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final Project project;
  const _Details({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(p.role,
            style: const TextStyle(fontSize: 11, color: AppTheme.accentGreen)),
        const SizedBox(height: 12),
        ...p.highlights.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('▸ ',
                      style: TextStyle(fontSize: 11, color: AppTheme.accentBlue)),
                  Expanded(
                    child: Text(h,
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.textSecondary, height: 1.7)),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 6),
        ...p.stack.map((layer) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(layer.label,
                        style: const TextStyle(
                            fontSize: 10, color: AppTheme.textSecondary, letterSpacing: 1)),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 6, runSpacing: 6,
                      children: layer.techs.map((t) => _TechChip(label: t)).toList(),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
        // Regla dura: sin githubUrl no se renderiza enlace. Nunca un 404.
        if (p.githubUrl != null)
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(p.githubUrl!)),
            child: const Text('→ View on GitHub',
                style: TextStyle(fontSize: 11, color: AppTheme.accentBlue)),
          )
        else if (p.note != null)
          Text(p.note!,
              style: const TextStyle(
                  fontSize: 10, color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
      ],
    );
  }
}

class _LayerChip extends StatelessWidget {
  final String label;
  const _LayerChip({required this.label});

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

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFF161B22),
      border: Border.all(color: AppTheme.borderSubtle),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
  );
}
```

- [ ] **Step 4: Ejecutar las pruebas de la tarjeta**

Run: `flutter test test/project_card_test.dart`
Expected: PASS — 6 pruebas.

- [ ] **Step 5: Escribir la prueba de coordinación**

Añadir al final de `test/projects_section_test.dart` (dentro de `main()`):

```dart
  // Los `role` de cada proyecto sirven de sonda: solo se renderizan al expandir.
  const roleBanxico = 'Software Engineer Intern — Banco de México';
  const roleFoodMatch = 'Solo developer — mobile app, backend, and deployment';

  testWidgets('escritorio: la primera tarjeta arranca abierta', (tester) async {
    await pumpPortfolio(tester, size: const Size(1400, 900));
    expect(find.text(roleBanxico), findsOneWidget);
  });

  testWidgets('móvil: ninguna tarjeta arranca abierta', (tester) async {
    await pumpPortfolio(tester, size: const Size(420, 900));
    expect(find.text(roleBanxico), findsNothing);
  });

  testWidgets('escritorio: abrir una cierra la anterior', (tester) async {
    await pumpPortfolio(tester, size: const Size(1400, 900));
    expect(find.text(roleBanxico), findsOneWidget); // arranca abierta

    await tester.tap(find.text('Food Match'));
    await tester.pumpAndSettle();

    expect(find.text(roleFoodMatch), findsOneWidget);
    expect(find.text(roleBanxico), findsNothing); // la anterior se cerró
  });

  testWidgets('móvil: dos tarjetas pueden quedar abiertas a la vez', (tester) async {
    await pumpPortfolio(tester, size: const Size(420, 2400));

    await tester.tap(find.text('Institutional Email Automation Platform'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Food Match'));
    await tester.pumpAndSettle();

    // En una columna, forzar el cierre estorba: ambas siguen abiertas.
    expect(find.text(roleBanxico), findsOneWidget);
    expect(find.text(roleFoodMatch), findsOneWidget);
  });
```

- [ ] **Step 6: Ejecutar y verificar que falla**

Run: `flutter test test/projects_section_test.dart`
Expected: FAIL — `ProjectsSection` aún es `StatelessWidget` y no pasa `expanded`.

- [ ] **Step 7: Convertir `ProjectsSection` en `StatefulWidget`**

Reemplazar `lib/widgets/sections/projects_section.dart:8-52` por:

```dart
class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  /// Índices expandidos. Escritorio: a lo más uno. Móvil: los que el usuario abra.
  final Set<int> _expanded = {};
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // Escritorio abre la primera: mucha gente no hace clic, y ahí vive la
    // evidencia de backend. En móvil empujaría el resto fuera de pantalla.
    if (!AppTheme.isMobile(context)) _expanded.add(0);
  }

  void _toggle(int index) {
    setState(() {
      if (_expanded.contains(index)) {
        _expanded.remove(index);
        return;
      }
      // Escritorio: una a la vez, para que la rejilla no se vuelva un acordeón.
      // Móvil: es una columna; forzar el cierre solo estorba.
      if (!AppTheme.isMobile(context)) _expanded.clear();
      _expanded.add(index);
    });
  }

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
                child: ProjectCard(
                  project: e.value,
                  expanded: _expanded.contains(e.key),
                  onTap: () => _toggle(e.key),
                ),
              ),
            )).toList())
          else
            Column(
              children: [
                for (int i = 0; i < projects.length; i += 2) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _Row(
                    projects: projects,
                    indices: [
                      for (int j = i; j < i + 2 && j < projects.length; j++) j,
                    ],
                    expanded: _expanded,
                    onTap: _toggle,
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 8: Actualizar `_Row` para propagar el estado**

Reemplazar la clase `_Row` completa por:

```dart
class _Row extends StatelessWidget {
  final List<Project> projects;
  final List<int> indices;
  final Set<int> expanded;
  final void Function(int) onTap;

  const _Row({
    required this.projects,
    required this.indices,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (int slot = 0; slot < 2; slot++)
        Expanded(
          child: slot < indices.length
              ? Padding(
                  padding: EdgeInsets.only(
                    right: slot == 0 ? 8 : 0,
                    left: slot == 1 ? 8 : 0,
                  ),
                  child: ScrollReveal(
                    delay: Duration(milliseconds: slot * 120),
                    child: ProjectCard(
                      project: projects[indices[slot]],
                      expanded: expanded.contains(indices[slot]),
                      onTap: () => onTap(indices[slot]),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
    ],
  );
}
```

- [ ] **Step 9: Ejecutar la suite completa**

Run: `flutter test`
Expected: PASS — 18 pruebas.

- [ ] **Step 10: Commit**

```powershell
git add lib/widgets/shared/project_card.dart lib/widgets/sections/projects_section.dart test/project_card_test.dart test/projects_section_test.dart
git commit -m "feat: expandable project cards with layered stack

Cerrada muestra summary y capas; abierta muestra rol, highlights y stack
completo. Sin githubUrl se renderiza la nota en vez de un enlace muerto."
```

---

### Task 5: Retirar los campos legados

**Files:**
- Modify: `lib/data/portfolio_data.dart`

**Interfaces:**
- Consumes: nada nuevo.
- Produces: `Project` sin `description` ni `tags`.

- [ ] **Step 1: Verificar que ya nadie los usa**

Run: `Select-String -Path lib\**\*.dart -Pattern "\.description|\.tags" -ErrorAction SilentlyContinue`
Expected: sin coincidencias sobre `Project` (`SkillGroup` no tiene esos campos).

- [ ] **Step 2: Eliminar los campos del modelo**

En `lib/data/portfolio_data.dart`, borrar de la clase `Project` las líneas:

```dart
  // Legados: los retira la Task 5, cuando ProjectCard deje de usarlos.
  final String description;
  final List<String> tags;
```

y del constructor:

```dart
    required this.description,
    required this.tags,
```

- [ ] **Step 3: Eliminar los campos de los 3 proyectos**

Borrar `description: '',` y `tags: [],` de cada una de las 3 entradas de `PortfolioData.projects`.

- [ ] **Step 4: Limpiar las pruebas**

En `test/project_model_test.dart` y `test/project_card_test.dart`, borrar `description: 'legacy'` / `description: ''` y `tags: [...]` / `tags: []` de los `Project(...)` de prueba.

- [ ] **Step 5: Ejecutar la suite**

Run: `flutter test`
Expected: PASS — 18 pruebas.

- [ ] **Step 6: Commit**

```powershell
git add lib/data/portfolio_data.dart test/
git commit -m "refactor: drop legacy description and tags from Project"
```

---

### Task 6: Contenido — puestos, hero y skills

**Files:**
- Modify: `lib/data/portfolio_data.dart` (`jobs`, `skillGroups`)
- Modify: `lib/widgets/sections/hero_section.dart:86,92,116`
- Test: `test/content_test.dart` (crear)

**Interfaces:**
- Consumes: `Job`, `SkillGroup`, `Skill`, `SkillColor` (ya existen, sin cambios).

- [ ] **Step 1: Escribir la prueba que falla**

Crear `test/content_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'helpers.dart';

void main() {
  test('los puestos coinciden con el CV', () {
    expect(PortfolioData.jobs[0].role, 'Software Engineer Intern');
    expect(PortfolioData.jobs[1].role, 'Fullstack & Multiplatform QA Engineer');
    expect(PortfolioData.jobs[2].role, 'NoSQL Database Engineer');
  });

  test('la viñeta de la plataforma Spring va primera en Banxico', () {
    expect(PortfolioData.jobs[0].bullets.first, contains('Java/Spring backend'));
  });

  test('Elektra menciona el carrito en Java', () {
    expect(
      PortfolioData.jobs[1].bullets.any((b) => b.contains('shopping cart')),
      isTrue,
    );
  });

  test('existe el grupo BACKEND & APIs y va primero', () {
    expect(PortfolioData.skillGroups.first.label, 'BACKEND & APIs');
  });

  test('los 4 lenguajes de especialización van en azul', () {
    final langs = PortfolioData.skillGroups.firstWhere((g) => g.label == 'LANGUAGES');
    for (final name in ['Java', 'C++', 'Python', 'JavaScript']) {
      final skill = langs.skills.firstWhere((s) => s.label == name);
      expect(skill.color, SkillColor.blue, reason: '$name debe ir en azul');
    }
  });

  test('Unity y C# ya no aparecen', () {
    final all = PortfolioData.skillGroups.expand((g) => g.skills).map((s) => s.label);
    expect(all, isNot(contains('Unity')));
    expect(all, isNot(contains('C#')));
  });

  // El titular lo pinta TypewriterText, que devuelve RichText: hay que usar
  // findTypewriterText, no find.text (ver helpers.dart).
  testWidgets('el hero muestra el titular nuevo', (tester) async {
    await pumpPortfolio(tester);
    expect(findTypewriterText('Software Engineer · Backend & APIs · Mobile'),
        findsOneWidget);
  });

  testWidgets('el hero ya no dice Database Engineer ni QA Automation', (tester) async {
    await pumpPortfolio(tester);
    expect(findTypewriterText('Database Engineer'), findsNothing);
    expect(findTypewriterText('QA Automation'), findsNothing);
  });
}
```

- [ ] **Step 2: Ejecutar y verificar que falla**

Run: `flutter test test/content_test.dart`
Expected: FAIL — el puesto dice `Database Engineering Intern`.

- [ ] **Step 3: Corregir los puestos y viñetas**

En `portfolio_data.dart`, dentro de `jobs`:

- Job 0: `role: 'Database Engineering Intern'` → `role: 'Software Engineer Intern'`. Insertar como **primera** viñeta:

```dart
        'Built an internal fullstack web platform automating institutional email '
        'workflows: Java/Spring backend exposing REST endpoints over a relational '
        'store, JavaScript frontend, and Python services, integrated with the '
        'bank\'s user-directory infrastructure.',
```

- Job 1: `role: 'Database QA Engineer'` → `role: 'Fullstack & Multiplatform QA Engineer'`. Insertar como **primera** viñeta:

```dart
        'Implemented core shopping cart features in Java during the early build '
        'phase of Elektra\'s high-traffic e-commerce mobile app, shipping product '
        'code alongside the engineering team.',
```

- Job 2: sin cambios.

- [ ] **Step 4: Reemplazar `skillGroups`**

Reemplazo completo:

```dart
  static const List<SkillGroup> skillGroups = [
    SkillGroup(label: 'BACKEND & APIs', skills: [
      Skill('Java', SkillColor.blue),
      Skill('Spring Boot', SkillColor.blue),
      Skill('JPA/Hibernate', SkillColor.blue),
      Skill('REST APIs', SkillColor.green),
      Skill('Node.js', SkillColor.green),
      Skill('Express', SkillColor.green),
      Skill('JUnit', SkillColor.gray),
      Skill('Maven/Gradle', SkillColor.gray),
      Skill('Stored Procedures', SkillColor.gray),
      Skill('Query Optimization', SkillColor.gray),
    ]),
    SkillGroup(label: 'MOBILE', skills: [
      Skill('Flutter', SkillColor.blue),
      Skill('Dart', SkillColor.blue),
      Skill('iOS/Android', SkillColor.gray),
      Skill('Appium', SkillColor.gray),
    ]),
    SkillGroup(label: 'LANGUAGES', skills: [
      Skill('Java', SkillColor.blue),
      Skill('C++', SkillColor.blue),
      Skill('Python', SkillColor.blue),
      Skill('JavaScript', SkillColor.blue),
      Skill('SQL', SkillColor.gray),
      Skill('Dart', SkillColor.gray),
      Skill('Bash', SkillColor.gray),
      Skill('PowerShell', SkillColor.gray),
    ]),
    SkillGroup(label: 'INFRA & TOOLS', skills: [
      Skill('Docker', SkillColor.green),
      Skill('Google Cloud Run', SkillColor.green),
      Skill('Linux', SkillColor.green),
      Skill('Git', SkillColor.green),
      Skill('CI/CD', SkillColor.gray),
      Skill('Active Directory', SkillColor.gray),
      Skill('Jira', SkillColor.gray),
      Skill('Wireshark', SkillColor.gray),
    ]),
  ];
```

- [ ] **Step 5: Corregir el hero**

En `lib/widgets/sections/hero_section.dart`:

- Línea 86: `text: 'Database Engineer · QA Automation · Flutter Developer',` →
  `text: 'Software Engineer · Backend & APIs · Mobile',`
- Línea 92: `text: 'Computer Engineer from UNAM. Building reliable mobile\nexperiences and automated systems. Currently @ Banco de México.',` →
  `text: 'Computer Engineer from UNAM. Building backend systems in Java\nand Spring, and shipping mobile apps end to end. Currently @ Banco de México.',`
- Línea 116: `TerminalOutput(text: '💼 Database Engineering Intern — Banco de México')` →
  `TerminalOutput(text: '💼 Software Engineer Intern — Banco de México')`

- [ ] **Step 6: Ejecutar la suite**

Run: `flutter test`
Expected: PASS — 26 pruebas.

- [ ] **Step 7: Commit**

```powershell
git add lib/data/portfolio_data.dart lib/widgets/sections/hero_section.dart test/content_test.dart
git commit -m "feat: reposition as Software Engineer - Backend & APIs - Mobile

Alinea puestos y viñetas con el CV, restaura la plataforma Spring de Banxico
y el carrito de Elektra, y añade el grupo BACKEND & APIs que se especificó
en el diseño de abril y nunca se implementó."
```

---

### Task 7: Arreglar los botones del hero

**Files:**
- Modify: `lib/widgets/sections/hero_section.dart:10-14,129-143`
- Modify: `lib/home_page.dart:87`
- Modify: `lib/data/portfolio_data.dart:46`
- Test: `test/hero_buttons_test.dart` (crear)

**Interfaces:**
- Consumes: `Map<String, GlobalKey>` de `home_page.dart:24-28`
- Produces: `HeroSection({Key? key, required Map<String, GlobalKey> sectionKeys})`

- [ ] **Step 1: Escribir la prueba que falla**

Crear `test/hero_buttons_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:aldo_portfolio/data/portfolio_data.dart';
import 'helpers.dart';

void main() {
  test('cvUrl vacío es la señal de "no hay CV publicable"', () {
    // El CV fuente tiene el apellido mal escrito ("Muñino").
    // Mientras cvUrl esté vacío, el botón no debe renderizarse.
    expect(PortfolioData.cvUrl, isEmpty);
  });

  testWidgets('con cvUrl vacío NO se renderiza el botón de CV', (tester) async {
    await pumpPortfolio(tester);
    expect(find.text('./download_cv'), findsNothing);
  });

  testWidgets('el botón view_projects sí se renderiza', (tester) async {
    await pumpPortfolio(tester);
    expect(find.text('./view_projects'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Ejecutar y verificar que falla**

Run: `flutter test test/hero_buttons_test.dart`
Expected: FAIL — `./download_cv` se renderiza aunque `cvUrl` esté vacío.

- [ ] **Step 3: Pasar las claves de sección al hero**

En `lib/widgets/sections/hero_section.dart`, reemplazar la declaración (líneas 10-14):

```dart
class HeroSection extends StatefulWidget {
  final Map<String, GlobalKey> sectionKeys;
  const HeroSection({super.key, required this.sectionKeys});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}
```

- [ ] **Step 4: Conectar los botones**

Reemplazar el bloque de botones (`hero_section.dart:129-143`) por:

```dart
          if (_showButtons)
            (isMobile
                ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    _HeroBtn(label: './view_projects', primary: true, onTap: _scrollToProjects),
                    if (PortfolioData.cvUrl.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _HeroBtn(label: './download_cv', primary: false,
                          onTap: () => launchUrl(Uri.parse(PortfolioData.cvUrl))),
                    ],
                  ])
                : Row(children: [
                    _HeroBtn(label: './view_projects', primary: true, onTap: _scrollToProjects),
                    if (PortfolioData.cvUrl.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      _HeroBtn(label: './download_cv', primary: false,
                          onTap: () => launchUrl(Uri.parse(PortfolioData.cvUrl))),
                    ],
                  ])
            ).animate().fadeIn(duration: 500.ms),
```

Y añadir el método a `_HeroSectionState` (junto a `_delay`, línea 53):

```dart
  // Mismo mecanismo que DesktopNavbar._scrollTo (desktop_navbar.dart:23).
  void _scrollToProjects() {
    final ctx = widget.sectionKeys['projects']?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }
```

- [ ] **Step 5: Pasar las claves desde `HomePage`**

En `lib/home_page.dart:87`:

```dart
                  HeroSection(key: _keys['home'], sectionKeys: _keys),
```

- [ ] **Step 6: Documentar por qué `cvUrl` está vacío**

En `lib/data/portfolio_data.dart:46`, reemplazar:

```dart
  // Vacío a propósito: el CV fuente tiene el apellido mal escrito ("Muñino"
  // en vez de "Muciño"). Mientras esté vacío, el botón ./download_cv no se
  // renderiza. Al corregirlo: colocar el PDF en web/ y poner aquí su nombre.
  static const String cvUrl = '';
```

- [ ] **Step 7: Ejecutar la suite**

Run: `flutter test`
Expected: PASS — 29 pruebas.

- [ ] **Step 8: Commit**

```powershell
git add lib/widgets/sections/hero_section.dart lib/home_page.dart lib/data/portfolio_data.dart test/hero_buttons_test.dart
git commit -m "fix: wire up both hero buttons

./view_projects no hacía nada (onTap vacío) y ./download_cv abría GitHub
en lugar del CV. Ahora el primero navega a #projects y el segundo solo se
renderiza cuando hay un CV que entregar."
```

---

### Task 8: Assets muertos, foto y fecha de graduación vencida

`about_section.dart:40` dice **"Graduating Summer 2025"**. Esa fecha pasó hace más de un año: el sitio anuncia un futuro que ya ocurrió.

Nota: las certificaciones de PROTECO **ya viven en About** (`about_section.dart:54,60`). La spec pedía "mover PROTECO a About"; en realidad basta con haberlo quitado de `projects` en la Task 3. Aquí no hay nada que añadir.

**Files:**
- Delete: `assets/img/docker.png`, `git.png`, `linux.png`, `node-js.png`, `postgresql.png`, `react.png`, `Gato2.ico`
- Keep: `assets/img/Aldo.jpg`
- Modify: `lib/widgets/sections/about_section.dart:28-29` (foto) y `:40` (graduación)
- Test: `test/about_test.dart` (crear)

**Interfaces:**
- Consumes: `ScrollReveal` de `lib/widgets/shared/scroll_reveal.dart` (ya importado en `about_section.dart:4`).

- [ ] **Step 1: Escribir las pruebas que fallan**

Crear `test/about_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() {
  testWidgets('la foto de Aldo se renderiza', (tester) async {
    await pumpPortfolio(tester);
    final assets = tester
        .widgetList<Image>(find.byType(Image))
        .map((i) => i.image)
        .whereType<AssetImage>()
        .map((a) => a.assetName);
    expect(assets, contains('assets/img/Aldo.jpg'));
  });

  testWidgets('no anuncia una graduación futura que ya pasó', (tester) async {
    await pumpPortfolio(tester);
    expect(find.textContaining('Graduating'), findsNothing);
  });
}
```

- [ ] **Step 2: Ejecutar y verificar que falla**

Run: `flutter test test/about_test.dart`
Expected: FAIL — no hay `Image` en el árbol, y "Graduating Summer 2025" sí aparece.

- [ ] **Step 3: Borrar los 7 logos muertos**

```powershell
Remove-Item assets\img\docker.png, assets\img\git.png, assets\img\linux.png, assets\img\node-js.png, assets\img\postgresql.png, assets\img\react.png, assets\img\Gato2.ico
Get-ChildItem assets\img
```
Expected: solo `Aldo.jpg`.

- [ ] **Step 4: Insertar la foto**

En `about_section.dart`, entre la línea 28 (`const SizedBox(height: 44),`) y la línea 29 (el `ScrollReveal` de Education), insertar:

```dart
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
```

- [ ] **Step 5: Corregir la fecha de graduación**

En `about_section.dart:40`, reemplazar:

```dart
                Text('GPA: 8.5/10.0 (equiv. 3.4/4.0) · Graduating Summer 2025',
```

por:

```dart
                Text('GPA: 8.5/10.0 (equiv. 3.4/4.0) · Graduated Summer 2025',
```

- [ ] **Step 6: Ejecutar la suite**

Run: `flutter test`
Expected: PASS — 31 pruebas.

- [ ] **Step 7: Commit**

```powershell
git add assets/img lib/widgets/sections/about_section.dart test/about_test.dart
git commit -m "fix: use the photo, drop dead assets, correct graduation date

Ningún asset se referenciaba desde lib/: 654 KB descargados en cada visita
sin renderizarse, incluida la foto. postgresql.png y react.png ni siquiera
corresponden al stack real. About decía 'Graduating Summer 2025', una fecha
que pasó hace más de un año."
```

---

### Task 9: Metadata de la página

**Files:**
- Modify: `web/index.html:21,24,36`
- Create: `web/og-image.png` (1200×630)

- [ ] **Step 1: Corregir los tres campos**

En `web/index.html`:

- Línea 21:
```html
  <meta name="description" content="Aldo Zetina Muciño — Software Engineer. Backend systems in Java and Spring, REST APIs, and cross-platform mobile apps. Computer Engineer from UNAM.">
```
- Línea 24:
```html
  <meta property="og:description" content="Software Engineer · Backend & APIs · Mobile">
```
- Línea 36:
```html
  <title>Aldo Zetina Muciño — Software Engineer</title>
```

- [ ] **Step 2: Añadir og:image y og:url**

Insertar después de la línea 24:

```html
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://aldozm.github.io/aldoproflie/">
  <meta property="og:image" content="https://aldozm.github.io/aldoproflie/og-image.png">
  <meta name="twitter:card" content="summary_large_image">
```

- [ ] **Step 3: Crear la imagen de vista previa**

Guardar como `scripts/make_og_image.py` y ejecutar con `python scripts/make_og_image.py`.
Requiere Pillow (verificado: 12.2.0 disponible). Usa Consolas, la monoespaciada
de Windows, porque Source Code Pro llega vía `google_fonts` en tiempo de
ejecución y no existe como archivo local.

```python
"""Genera web/og-image.png: la vista previa al compartir el enlace."""
from PIL import Image, ImageDraw, ImageFont

W, H = 1200, 630
BG      = (1, 4, 9)        # #010409
PRIMARY = (230, 237, 243)  # #e6edf3
BLUE    = (88, 166, 255)   # #58a6ff
GREEN   = (63, 185, 80)    # #3fb950
GRAY    = (139, 148, 158)  # #8b949e

MONO = r"C:\Windows\Fonts\consola.ttf"
MONO_BOLD = r"C:\Windows\Fonts\consolab.ttf"

img = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(img)

f_prompt = ImageFont.truetype(MONO, 26)
f_name   = ImageFont.truetype(MONO_BOLD, 66)
f_title  = ImageFont.truetype(MONO, 30)
f_foot   = ImageFont.truetype(MONO, 22)

x = 90
d.text((x, 150), "$ whoami", font=f_prompt, fill=GREEN)
d.text((x, 205), "Aldo Zetina Muciño", font=f_name, fill=PRIMARY)
d.text((x, 305), "Software Engineer · Backend & APIs · Mobile", font=f_title, fill=BLUE)
d.text((x, 380), "Java · Spring · Node.js · Flutter · C++ · Python",
       font=f_foot, fill=GRAY)
d.text((x, 470), "aldozm.github.io/aldoproflie", font=f_foot, fill=GRAY)

# Franja inferior: el mismo gradiente azul→verde de la barra de progreso.
for i in range(W):
    t = i / W
    d.line([(i, H - 6), (i, H)], fill=(
        int(BLUE[0] + (GREEN[0] - BLUE[0]) * t),
        int(BLUE[1] + (GREEN[1] - BLUE[1]) * t),
        int(BLUE[2] + (GREEN[2] - BLUE[2]) * t),
    ))

img.save("web/og-image.png")
print("web/og-image.png escrito:", img.size)
```

- [ ] **Step 4: Verificar la imagen y el build**

```powershell
python scripts/make_og_image.py
flutter build web --release --base-href "/aldoproflie/"
Test-Path build\web\og-image.png
```
Expected: `web/og-image.png escrito: (1200, 630)` y luego `True`.

Revisar la imagen a ojo antes de commitear: si Consolas no renderiza bien la
`ñ` de "Muciño", cambiar `MONO_BOLD` por otra fuente instalada.

- [ ] **Step 5: Commit**

```powershell
git add web/index.html web/og-image.png scripts/make_og_image.py
git commit -m "fix: update page metadata to match new positioning

og:description seguía diciendo 'Flutter Engineer - QA Automation', que es
lo que se ve al compartir el enlace en LinkedIn. Añade og:image: hasta ahora
el enlace se compartía sin vista previa."
```

---

### Task 10: Despliegue con GitHub Actions

Hoy Pages sirve desde la rama `gh-pages` (flujo manual), mientras `main` carga **35.4 MB de build muerto** que no sirve nada — resultado de que el commit `b942fef` cambiara la estructura sin cambiar la configuración de Pages.

**Files:**
- Create: `.github/workflows/deploy.yml`
- Delete: los 45 archivos de build en `docs/` (**conservar `docs/superpowers/`**)
- Modify: `README.md` (sección Deploy)
- Modify: `.gitignore`

- [ ] **Step 1: Crear el workflow**

Crear `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.41.2'
          channel: stable
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Build web
        run: flutter build web --release --base-href "/aldoproflie/"

      - uses: actions/upload-pages-artifact@v3
        with:
          path: build/web

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

`flutter test` corre antes del build: si las pruebas fallan, no se publica.

- [ ] **Step 2: Borrar el build muerto de `docs/`**

```powershell
Get-ChildItem docs -Exclude superpowers | Remove-Item -Recurse -Force
Get-ChildItem docs
```
Expected: solo `superpowers`.

- [ ] **Step 3: Evitar que `docs/` vuelva a llenarse de build**

Añadir al final de `.gitignore`:

```
# El build lo publica GitHub Actions; nunca se commitea.
/build/
/docs/*
!/docs/superpowers/
```

- [ ] **Step 4: Actualizar el README**

Reemplazar la sección `## Deploy to GitHub Pages` completa por:

```markdown
## Deploy

Automático. Cada push a `main` dispara `.github/workflows/deploy.yml`, que
corre las pruebas, construye con el `--base-href` correcto y publica en Pages.
No hay pasos manuales y no se commitea build.

Para verificar el build localmente antes de empujar:

```powershell
flutter test
flutter build web --release --base-href "/aldoproflie/"
```
```

- [ ] **Step 5: Commit y push**

```powershell
git add .github/workflows/deploy.yml .gitignore README.md docs
git commit -m "ci: build and deploy with GitHub Actions

Pages servía desde gh-pages mientras main cargaba 35.4 MB de build muerto
que no servía nada — el commit b942fef cambió la estructura pero nunca la
configuración de Pages. Ahora Actions construye, prueba y publica; se elimina
el build de docs/ y el flujo manual del README."
git push origin main
```

- [ ] **Step 6: Cambiar la configuración de Pages a Actions**

Requiere permisos del dueño del repositorio:

```powershell
gh api -X PUT repos/AldoZM/aldoproflie/pages -f build_type=workflow
```

- [ ] **Step 7: Verificar el despliegue**

```powershell
gh run list --limit 1
gh api repos/AldoZM/aldoproflie/pages | ConvertFrom-Json | Select-Object html_url, status, build_type
```
Expected: `build_type: workflow`, `status: built`.

- [ ] **Step 8: Eliminar la rama `gh-pages`**

Solo después de confirmar que el sitio en vivo funciona desde Actions:

```powershell
git push origin --delete gh-pages
```

---

## Verificación final

- [ ] `flutter test` — **31 pruebas** en verde
- [ ] `flutter analyze` — sin issues
- [ ] Abrir el sitio en escritorio: **3 tarjetas visibles**, la de Banxico abierta
      (hoy solo se ven 4 de 5 y Food Match no aparece nunca)
- [ ] Abrir el sitio en móvil (<600px): 3 tarjetas, ninguna abierta;
      abrir dos a la vez funciona (en escritorio abrir una cierra la otra)
- [ ] Tab lleva el foco a las tarjetas; Enter y Espacio las expanden
- [ ] Clic en `./view_projects` → navega a #projects
- [ ] `./download_cv` **no** aparece (cvUrl vacío)
- [ ] Ninguna tarjeta muestra "View on GitHub"; las tres muestran su nota
- [ ] El titular dice `Software Engineer · Backend & APIs · Mobile` en el hero,
      en la pestaña del navegador y al compartir el enlace
- [ ] About muestra la foto y dice "Graduated", no "Graduating"

## Bloqueos conocidos

1. **CV** — apellido mal escrito en el PDF fuente. Hasta corregirlo, `cvUrl` vacío y sin botón.
2. **Food Match privado** — requiere limpieza de historial. Es el único proyecto que puede volverse verificable; mientras siga privado, los tres dicen "confía en mí".
3. **Capturas de Food Match** — la carpeta del proyecto no está en la máquina. `images` vacío.
