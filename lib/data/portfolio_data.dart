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
  });
}

class PortfolioData {
  static const String githubUrl = 'https://github.com/AldoZM';
  static const String email     = 'zetinaa3@gmail.com';
  static const String phone     = '+52 744-272-6616';
  static const String location  = 'Mexico City, Mexico';
  // Vacío a propósito: el CV fuente tiene el apellido mal escrito ("Muñino"
  // en vez de "Muciño"). Mientras esté vacío, el botón ./download_cv no se
  // renderiza. Al corregirlo: colocar el PDF en web/ y poner aquí su nombre.
  static const String cvUrl     = '';

  static const List<Job> jobs = [
    Job(
      role: 'Software Engineer Intern',
      company: 'Banco de México',
      dates: 'Fall 2024 – Spring 2026',
      isCurrent: true,
      bullets: [
        'Built an internal fullstack web platform automating institutional email '
        'workflows: Java/Spring backend exposing REST endpoints over a relational '
        'store, JavaScript frontend, and Python services, integrated with the '
        'bank\'s user-directory infrastructure.',
        'Reduced pipeline failures by 30% by implementing data validation and sanitization in Python with retry logic over critical production data pipelines',
        'Automated identity management for 500+ users using PowerShell and Python, integrating Active Directory with relational access-control systems',
        'Implemented audit controls and event logging over financial data flows, improving traceability and observability across production systems',
      ],
    ),
    Job(
      role: 'Fullstack & Multiplatform QA Engineer',
      company: 'Grupo Salinas · Elektra.mx',
      dates: 'Summer 2022 – Spring 2024',
      bullets: [
        'Implemented core shopping cart features in Java during the early build '
        'phase of Elektra\'s high-traffic e-commerce mobile app, shipping product '
        'code alongside the engineering team.',
        'Reduced manual testing time by 40% by automating test suites for iOS and Android with Appium, accelerating mobile app release cycles',
        'Built a scalable testing framework for native and hybrid mobile apps using Java, Selenium, and Cucumber, integrated into CI/CD pipelines with AWS CodeCommit',
        "Validated critical user flows on Elektra's high-traffic mobile app, documenting root causes in Jira and preventing cross-release regressions",
        'Applied mobile app lifecycle knowledge (iOS/Android) to design end-to-end test scenarios aligned with real user behavior',
      ],
    ),
    Job(
      role: 'NoSQL Database Engineer',
      company: 'Huawei',
      dates: 'Summer 2021 – Spring 2022',
      bullets: [
        'Automated network infrastructure monitoring (latency, availability, polling) using Bash and C++ scripts, enabling continuous observability on Linux',
        'Built client/server utilities in C++ over UNIX domain sockets for real-time capture and persistence of network events on distributed Linux systems',
        'Diagnosed L3/L4 incidents by analyzing logs with Wireshark and tcpdump, accelerating root-cause resolution in production',
      ],
    ),
  ];

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
    ),
  ];

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
}
