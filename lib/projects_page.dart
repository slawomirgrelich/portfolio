import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'site_chrome.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  static const projects = [
    _Project(
      title: 'Portfolio Sławomira',
      category: 'Projekt webowy',
      description: 'Responsywne portfolio stworzone we Flutterze, z animowanym przewijaniem i formularzem kontaktowym.',
      technologies: ['Flutter', 'Dart', 'Web'],
      icon: Icons.web_rounded,
      color: Color(0xFF22D3EE),
      githubUrl: 'https://github.com/slawomirgrelich/portfolio',
    ),
    _Project(
      title: 'Aplikacja mobilna',
      category: 'Aplikacja mobilna',
      description: 'Koncepcja aplikacji mobilnej z prostą nawigacją, praktycznymi ekranami i interfejsem gotowym do dalszego rozwoju.',
      technologies: ['Flutter', 'Dart', 'Material 3'],
      icon: Icons.phone_iphone_rounded,
      color: Color(0xFFA78BFA),
      githubUrl: 'https://github.com/slawomirgrelich',
    ),
    _Project(
      title: 'Skrypty IT',
      category: 'Automatyzacja',
      description: 'Małe narzędzia i skrypty, które porządkują powtarzalne zadania i pomagają szybciej pracować z kodem.',
      technologies: ['Dart', 'Python', 'Git'],
      icon: Icons.terminal_rounded,
      color: Color(0xFF34D399),
      githubUrl: 'https://github.com/slawomirgrelich',
    ),
    _Project(
      title: 'Landing page dla marki',
      category: 'Projekt webowy',
      description: 'Czytelna strona startowa skupiona na prezentacji oferty, strukturze treści i wygodnym doświadczeniu użytkownika.',
      technologies: ['UI/UX', 'HTML', 'CSS'],
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFFF472B6),
      githubUrl: 'https://github.com/slawomirgrelich',
    ),
  ];

  Future<void> _openGithub(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !await canLaunchUrl(uri)) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1000
              ? 3
              : constraints.maxWidth >= 640
              ? 2
              : 1;
          final contentWidth = constraints.maxWidth > 1200
              ? 1200.0
              : constraints.maxWidth;
          final cardWidth = (contentWidth - (columns - 1) * 18) / columns;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 30, 18, 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PortfolioNavbar(
                            onHome: () => _goHome(context),
                            onAbout: () => _goHome(context),
                            onServices: () => _goHome(context),
                            onProjects: () {},
                            onContact: () => _goHome(context),
                            onGithub: () => _openGithub(
                              'https://github.com/slawomirgrelich',
                            ),
                            onLinkedIn: () => _openGithub(
                              'https://www.linkedin.com/in/slawomirgrelich/',
                            ),
                          ),
                          const SizedBox(height: 34),
                          const Text(
                            'Projekty, które buduję',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Zobacz moje realizacje, eksperymenty i kierunki dalszego rozwoju.',
                            style: TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 17,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Wrap(
                            spacing: 18,
                            runSpacing: 18,
                            children: [
                              for (final project in projects)
                                SizedBox(
                                  width: cardWidth,
                                  child: _ProjectCard(
                                    project: project,
                                    onGithubTap: () =>
                                        _openGithub(project.githubUrl),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          OutlinedButton.icon(
                            onPressed: () => _goHome(context),
                            icon: const Icon(Icons.home_rounded),
                            label: const Text('Wróć na stronę główną'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF334155)),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                PortfolioFooter(
                  onGithub: () =>
                      _openGithub('https://github.com/slawomirgrelich'),
                  onLinkedIn: () => _openGithub(
                    'https://www.linkedin.com/in/slawomirgrelich/',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Project {
  final String title;
  final String category;
  final String description;
  final List<String> technologies;
  final IconData icon;
  final Color color;
  final String githubUrl;

  const _Project({
    required this.title,
    required this.category,
    required this.description,
    required this.technologies,
    required this.icon,
    required this.color,
    required this.githubUrl,
  });
}

class _ProjectCard extends StatelessWidget {
  final _Project project;
  final VoidCallback onGithubTap;

  const _ProjectCard({required this.project, required this.onGithubTap});

  @override
  Widget build(BuildContext context) {
    return PortfolioHoverLift(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 132,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    project.color.withValues(alpha: 0.28),
                    const Color(0xFF111827),
                  ],
                ),
              ),
              child: Icon(project.icon, color: project.color, size: 54),
            ),
            const SizedBox(height: 18),
            Text(
              project.category.toUpperCase(),
              style: TextStyle(
                color: project.color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              project.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              project.description,
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 14,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final technology in project.technologies)
                  _TechnologyTag(label: technology, color: project.color),
              ],
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onGithubTap,
              icon: const Icon(Icons.open_in_new_rounded, size: 17),
              label: const Text('Zobacz na GitHubie'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF334155)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechnologyTag extends StatelessWidget {
  final String label;
  final Color color;

  const _TechnologyTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
