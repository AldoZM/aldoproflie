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
      role: 'Database Engineering Intern',
      company: 'Banco de México',
      dates: 'Fall 2024 – Spring 2026',
      isCurrent: true,
      bullets: [
        'Reduced pipeline failures by 30% by implementing data validation and sanitization in Python with retry logic over critical production data pipelines',
        'Automated identity management for 500+ users using PowerShell and Python, integrating Active Directory with relational access-control systems',
        'Implemented audit controls and event logging over financial data flows, improving traceability and observability across production systems',
      ],
    ),
    Job(
      role: 'Database QA Engineer',
      company: 'Grupo Salinas · Elektra.mx',
      dates: 'Summer 2022 – Spring 2024',
      bullets: [
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
      icon: '📱',
      name: 'Mobile App with Flutter',
      description: 'Cross-platform mobile application development with Flutter and Dart — REST API consumption, state management, and adaptive UI for iOS and Android. (2025–Present)',
      tags: ['Flutter', 'Dart', 'REST APIs', 'iOS/Android'],
    ),
    Project(
      icon: '🫀',
      name: 'VR Medical Simulation — Código Infarto',
      description: 'Interactive VR module simulating cardiac emergency protocols, built with Unity and C#. Interaction logic and flow validation developed alongside medical professionals. (2026–Present)',
      tags: ['Unity', 'C#', 'VR', 'Interaction Logic'],
    ),
    Project(
      icon: '🖥️',
      name: 'Home Lab & Network Administration',
      description: 'Linux server configured with service monitoring, security rules, and access control for continuous availability. (2026)',
      tags: ['Linux', 'Networking', 'Monitoring', 'Security'],
    ),
    Project(
      icon: '☕',
      name: 'Advanced SQL & Java — PROTECO UNAM',
      description: 'Complex query design, stored procedures, and database optimization (Honorable Mention), plus OOP and scalable application development in Java.',
      tags: ['Java', 'SQL', 'Stored Procedures', 'OOP'],
    ),
  ];

  static const List<SkillGroup> skillGroups = [
    SkillGroup(label: 'MOBILE', skills: [
      Skill('Flutter', SkillColor.blue),
      Skill('Dart', SkillColor.blue),
      Skill('Appium', SkillColor.green),
      Skill('Selenium', SkillColor.gray),
      Skill('Cucumber', SkillColor.gray),
      Skill('iOS/Android', SkillColor.gray),
    ]),
    SkillGroup(label: 'LANGUAGES', skills: [
      Skill('Java', SkillColor.green),
      Skill('C++', SkillColor.green),
      Skill('Python', SkillColor.blue),
      Skill('Dart', SkillColor.blue),
      Skill('SQL', SkillColor.gray),
      Skill('Bash', SkillColor.gray),
      Skill('PowerShell', SkillColor.gray),
      Skill('JavaScript', SkillColor.gray),
    ]),
    SkillGroup(label: 'TOOLS', skills: [
      Skill('Git', SkillColor.green),
      Skill('Docker', SkillColor.green),
      Skill('Linux', SkillColor.green),
      Skill('AWS CodeCommit', SkillColor.gray),
      Skill('Jira', SkillColor.gray),
      Skill('Active Directory', SkillColor.gray),
      Skill('Wireshark', SkillColor.gray),
    ]),
    SkillGroup(label: 'OTHER', skills: [
      Skill('Unity', SkillColor.gray),
      Skill('C#', SkillColor.gray),
      Skill('RESTful APIs', SkillColor.gray),
      Skill('CI/CD', SkillColor.gray),
      Skill('UML', SkillColor.gray),
    ]),
  ];
}
