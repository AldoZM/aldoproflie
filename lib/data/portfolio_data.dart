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
