# Portafolio — Reposicionamiento Backend & Mobile

**Fecha:** 2026-07-17
**Estado:** Aprobado
**Reemplaza parcialmente a:** `2026-04-29-portfolio-flutter-web-design.md`

---

## Problema

El portafolio publicado presenta a Aldo por debajo de lo que su CV respalda. El
diagnóstico, contrastando `lib/data/portfolio_data.dart` contra
`Aldo_Zetina_CV_Java_EN.pdf`:

| Área | Publicado hoy | Realidad según el CV |
|---|---|---|
| Titular | `Database Engineer · QA Automation · Flutter Developer` | Software Engineer, backend Java/Spring |
| Puesto Banxico | Database Engineering Intern | **Software Engineer Intern** |
| Puesto Elektra | Database QA Engineer | **Fullstack & Multiplatform QA Engineer** |
| Backend | No existe como sección | Spring Boot, JPA/Hibernate, JUnit, Maven, REST |

Causa raíz: **no es que falte contenido, es que la estructura de datos no tiene
dónde ponerlo.** La clase `Project` solo admite ícono, nombre, descripción,
etiquetas planas y un enlace opcional. No hay forma de expresar "diseñé el
backend además de la app".

Además, el grupo de skills **"Backend & APIs" fue especificado en el diseño de
2026-04-29 (línea 118) y nunca se implementó**.

## Objetivo

Reposicionar el portafolio como **Software Engineer · Backend & APIs · Mobile**,
con evidencia verificable en la página misma.

Restricción determinante: **ninguno de los tres proyectos tiene código público**
(uno es privado, dos son propietarios). La página no puede delegar la prueba a
un enlace — tiene que cargarla ella.

---

## 1. Modelo de datos

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
  final List<String> highlights;     // viñetas al expandir — la evidencia
  final List<StackLayer> stack;      // por capa, no plano
  final String? githubUrl;           // null = sin enlace
  final String? note;                // "Private repository", etc.
  final List<String> images;         // opcional, default []
}
```

**Decisiones:**

- **`stack` por capas.** `Backend: Node.js, Express · Mobile: Flutter, Dart ·
  Infrastructure: Docker, Cloud Run` comunica el perfil en un vistazo. Una lista
  plana de etiquetas hace que todo pese igual.
- **`githubUrl` nulable + `note`.** Resuelve el caso real: repositorios privados
  y software interno. Sin enlace se renderiza `note` en gris. **Nunca un enlace
  muerto** — hoy `portfolio_data.dart:113` apunta a un repositorio privado y
  devuelve 404 a todo visitante.
- **`role` separado de `summary`.** Responde la primera pregunta de cualquier
  entrevistador.
- **`highlights` reemplaza a `description`.** Viñetas, mismo estilo que
  `Job.bullets`.

## 2. Contenido

**Idioma: todo en inglés.** Hoy está mezclado — las viñetas de experiencia en
inglés y Food Match en español (`portfolio_data.dart:111`).

**Puestos** (corregidos contra el CV):

- Banco de México → `Software Engineer Intern`
- Grupo Salinas → `Fullstack & Multiplatform QA Engineer`
- Huawei → `NoSQL Database Engineer` (sin cambio)

**Viñetas faltantes que se restauran:**

- Banxico, **primera viñeta**: la plataforma fullstack (Java/Spring, REST sobre
  almacén relacional, frontend JavaScript, servicios Python). Es la prueba de
  fullstack y hoy no aparece en la página.
- Elektra: el carrito de compras en Java. Lo saca del casillero de solo-QA.

**Hero** (`hero_section.dart`):

```
$ whoami
Aldo Zetina Muciño
Software Engineer · Backend & APIs · Mobile

Computer Engineer from UNAM. Building backend systems
in Java and Spring, and shipping mobile apps end to end.
Currently @ Banco de México.
```

Corregir también la tarjeta de terminal, línea 116: `Database Engineering
Intern` → `Software Engineer Intern`.

**Skills** (orden = prioridad, backend primero):

| Grupo | Contenido |
|---|---|
| `BACKEND & APIs` | Java, Spring Boot, JPA/Hibernate, REST APIs, Node.js, Express, JUnit, Maven/Gradle, stored procedures, query optimization |
| `MOBILE` | Flutter, Dart, iOS/Android, Appium |
| `LANGUAGES` | Java, C++, Python, JavaScript (azul) · SQL, Dart, Bash, PowerShell (gris) |
| `INFRA & TOOLS` | Docker, Cloud Run/GCP, Linux, Git, CI/CD, Active Directory, Jira, Wireshark |

- **Azul = especialización declarada** (Java, C++, Python, JavaScript). El enum
  `SkillColor` ya existe; el color pasa a comunicar profundidad en vez de decorar.
- **Unity y C# se eliminan.** Sostenían al proyecto de VR, que sale; el CV
  tampoco los menciona.
- Node.js y Express entran por Food Match, no por el CV.

## 3. Proyectos

Tres, ordenados para que backend lidere (coherente con el titular).

**1. Institutional Email Automation Platform — Banco de México (2024–2026)**
Java/Spring, la especialidad declarada, en un banco central.
Detalle: **al nivel del CV, sin capturas ni arquitectura interna** (decisión
explícita del autor). `note: 'Internal software — not publicly available'`.

**2. Food Match (2026)**
Único proyecto con las tres capas y dueño completo.

```dart
role: 'Solo developer — mobile app, backend, and deployment',
highlights: [
  'Designed a Bayesian scoring engine that updates weights across all cuisine '
  'types on every swipe, converging on a shared preference in 6–10 questions.',
  'Built a Node.js/Express backend that proxies the Google Places API, keeping '
  'the API key server-side so it never ships in the mobile client.',
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
```

La segunda viñeta es la más valiosa: no dice "usé Node", dice que identificó un
riesgo de seguridad y construyó un servidor para resolverlo.

**3. Elektra Shopping Cart (2022–2024)**
Java, código de producto en comercio electrónico de alto tráfico.
`note: 'Proprietary — not publicly available'`.

**Se eliminan:**

- **PROTECO SQL & Java** → es una certificación con mención honorífica, no un
  proyecto. Se mueve a la sección *About*.
- **Home Lab** → la evidencia de infraestructura ya es más fuerte (Docker y
  Cloud Run en producción).
- **VR Código Infarto** → no encaja en el enfoque backend/mobile.

**Riesgo asumido y conocido:** los tres proyectos carecen de código público.
Food Match es el único que puede volverse público y depende de una limpieza de
historial pendiente (ver *Bloqueos*). Mientras siga privado, la credibilidad
del portafolio descansa enteramente en el texto de las tarjetas.

## 4. Tarjeta expandible

**Cerrada:** ícono, nombre, periodo, `summary` (2 líneas), fila compacta de
capas (`Backend · Mobile · Infra`).

**Abierta:** `role`, viñetas de `highlights`, stack completo por capa, y enlace
o `note`.

**Comportamiento:**

- `AnimatedSize`, `easeInOutCubic`, ~240ms — consistente con las animaciones
  existentes.
- **Una abierta a la vez en escritorio**; abrir una cierra la anterior. Estado en
  `ProjectsSection`, no en la tarjeta.
- **Móvil: expansión libre** (es columna, no rejilla).
- **Primera tarjeta abierta al cargar, solo en escritorio.** En móvil empujaría
  el resto fuera de pantalla.
- Sin `githubUrl` → no se renderiza botón, se renderiza `note`.
- `Focusable`; Enter/Espacio expanden. Requisito de accesibilidad, no adorno.

**Fuera de alcance:** modal, ruta dedicada, diagramas de arquitectura.

## 5. Arreglos

**Botones del hero (ambos rotos hoy):**

- `./view_projects` (`hero_section.dart:132,138`) — `onTap: () {}`, no hace nada.
  Se conecta al `ScrollController` existente en `home_page.dart`.
- `./download_cv` (`hero_section.dart:134,140`) — abre GitHub, no el CV.
  Se conecta a `cvUrl`. **Bloqueado**: ver *Bloqueos*.

**Assets muertos.** Cero coincidencias de `Image.asset`/`AssetImage` en todo
`lib/`. **Ningún asset se usa**: ~654 KB descargados en cada visita sin
renderizarse (`Gato2.ico` 268 KB, `postgresql.png` 123 KB, `react.png` 93 KB,
`Aldo.jpg` 59 KB, `node-js.png`, `docker.png`, `linux.png`, `git.png`).

- Borrar los siete logos, incluido `Gato2.ico`. `postgresql.png` y `react.png`
  no tienen respaldo en el CV ni en el código.
- **`Aldo.jpg` (su foto) tampoco se usa.** Se conserva y se coloca en la sección
  *About*, no en el hero: el hero ya tiene la secuencia typewriter más la
  tarjeta de terminal, y una foto ahí compite con esa estética. *About* es hoy
  solo texto y es donde una foto se lee natural.

**Metadata** (`web/index.html`) — hoy contradice el nuevo posicionamiento en el
lugar más visible:

- Línea 21 `description` y línea 24 `og:description`: `Flutter Engineer · QA
  Automation · Infrastructure` → `Software Engineer · Backend & APIs · Mobile`.
  Es lo que se ve al compartir el enlace en LinkedIn o WhatsApp.
- Línea 36 `<title>`: `Aldo Zetina Muciño — Flutter Engineer` → `Aldo Zetina
  Muciño — Software Engineer`.
- Añadir `og:image` (hoy el enlace se comparte sin vista previa).

## 6. Pruebas

`test/widget_test.dart` es **la plantilla por defecto de Flutter**: prueba un
contador inexistente y llama a `MyApp()`, pero `main.dart` exporta
`PortfolioApp`. **No compila** — `flutter test` está roto desde el primer commit.

Plan (enfocado en lo que puede romperse de verdad):

- Reemplazar la plantilla por un smoke test que monte `PortfolioApp` y verifique
  que las secciones renderizan.
- **`Project` con `githubUrl: null` no renderiza enlace y sí renderiza `note`.**
  Es la regla que impide repetir el 404 actual.
- Expandir/colapsar; abrir una cierra la anterior en escritorio.
- `StackLayer` renderiza todas sus capas.

Sin pruebas de animaciones ni de typewriter: frágiles, lentas, no protegen nada.

## 7. Despliegue

**Estado actual, incoherente.** El commit `b942fef` ("serve site from main
/docs") reestructuró el repositorio pero **nunca cambió la configuración de
Pages**, que sigue apuntando a la rama `gh-pages`. Consecuencia: **35.4 MB de
build muerto commiteado en `main`** que no sirve nada y crece con cada
despliegue. El sitio en vivo sí está actualizado, vía el flujo manual a
`gh-pages` que describe el README.

**Solución: GitHub Actions.**

- Workflow que construye con `flutter build web --release --base-href
  "/aldoproflie/"` al hacer push a `main` y publica en Pages.
- Borrar los 45 archivos de build de `docs/` (conservando `docs/superpowers/`,
  que vuelve a ser documentación real y no salida de build).
- Eliminar la rama `gh-pages` y cambiar Pages a origen Actions.
- Actualizar el README: el flujo manual y la advertencia de PowerShell para
  `--base-href` dejan de aplicar.

Nota: borrar `docs/` no reduce el historial (los 35 MB siguen ahí); sí detiene
el crecimiento.

---

## Bloqueos

Ninguno impide empezar; los tres condicionan el resultado final.

1. **CV — error tipográfico en el apellido.** El PDF dice **"Aldo Zetina
   Muñino"** en el encabezado; el correcto es **"Muciño"** (el portafolio lo
   tiene bien en `hero_section.dart:75`). Hay que corregirlo en el archivo
   fuente, que no está en este repositorio. **Hasta entonces el botón
   `./download_cv` no se renderiza** — un botón ausente es mejor que uno que
   entrega un documento con el apellido mal escrito.

2. **Food Match — repositorio privado.** Requiere una limpieza de historial
   pendiente antes de poder publicarse (detalles fuera de este documento).
   Mientras siga privado, `githubUrl: null` y `note: 'Private repository'`.
   Es el único de los tres proyectos que puede volverse verificable.

3. **Capturas de Food Match — no disponibles.** La carpeta del proyecto no está
   en la máquina de trabajo. `images` queda vacío; las tarjetas funcionan sin
   ellas.

## Fuera de alcance

- Selector de idioma / bilingüe (duplica el contenido y añade estado).
- Páginas dedicadas por proyecto, diagramas de arquitectura, demo embebida.
- Rediseño del sistema visual (colores, tipografía, animaciones): el enfoque
  terminal oscuro se conserva.
- Migrar fuera de Flutter Web. Evaluado y descartado: funciona, es su expertise,
  y el stack importa menos que la ejecución.

## Pendientes fuera de este repositorio

- Corregir el apellido en el CV fuente.
- Añadir Node.js/Express y el backend en Cloud Run al CV: tiene un backend en
  producción y el documento no lo menciona.
- Actualizar la fecha de graduación del CV ("Summer 2025" ya pasó).
