import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'cv_download.dart';
import 'projects_page.dart';
import 'site_chrome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sławomir Grelich | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF8B5CF6),
          secondary: const Color(0xFF22D3EE),
          surface: const Color(0xFF0F172A),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
          titleMedium: TextStyle(color: Color(0xFFE2E8F0)),
          bodyMedium: TextStyle(color: Color(0xFFCBD5E1)),
        ),
      ),
      routes: {
        '/': (_) => const PortfolioHomePage(),
        '/projekty': (_) => const ProjectsPage(),
      },
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _servicesKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _scrollController = ScrollController();
  final _contactFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null || _scrollController.hasClients == false) {
      return;
    }

    final renderObject = targetContext.findRenderObject();
    if (renderObject == null) {
      return;
    }

    final viewport = RenderAbstractViewport.of(renderObject);

    final targetOffset = viewport
        .getOffsetToReveal(renderObject, 0.05)
        .offset
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openProjectsPage() {
    Navigator.of(context).pushNamed('/projekty');
  }

  Future<void> _submitContactForm() async {
    if (_isSubmitting || _contactFormKey.currentState?.validate() != true) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('https://formspree.io/f/mvkgzzda'),
        headers: const {'Accept': 'application/json'},
        body: {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'message': _messageController.text.trim(),
        },
      );

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wiadomość została wysłana!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nie udało się wysłać wiadomości (${response.statusCode}).',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nie udało się wysłać wiadomości. Spróbuj ponownie.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = MediaQuery.of(context).size.width > 800;
          final contentWidth = isDesktop ? 1200.0 : constraints.maxWidth;

          return SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 30,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentWidth),
                      child: _buildMobileLayout(),
                    ),
                  ),
                ),
                PortfolioFooter(
                  onGithub: () =>
                      _openUrl('https://github.com/slawomirgrelich'),
                  onLinkedIn: () =>
                      _openUrl('https://www.linkedin.com/in/slawomirgrelich/'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PortfolioNavbar(
          onHome: () => _scrollTo(_heroKey),
          onAbout: () => _scrollTo(_aboutKey),
          onServices: () => _scrollTo(_servicesKey),
          onProjects: _openProjectsPage,
          onContact: () => _scrollTo(_contactKey),
          onGithub: () => _openUrl('https://github.com/slawomirgrelich'),
          onLinkedIn: () =>
              _openUrl('https://www.linkedin.com/in/slawomirgrelich/'),
        ),
        const SizedBox(height: 30),
        Container(key: _heroKey, child: _buildHeroSection()),
        const SizedBox(height: 30),
        _buildStatsRow(),
        const SizedBox(height: 40),
        Container(key: _aboutKey, child: _buildAboutSection()),
        const SizedBox(height: 40),
        Container(key: _servicesKey, child: _buildServicesSection()),
        const SizedBox(height: 40),
        _buildTechnologiesSection(),
        const SizedBox(height: 40),
        _buildProcessSection(),
        const SizedBox(height: 40),
        Container(key: _contactKey, child: _buildContactBanner()),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF111827), Color(0xFF0B1321)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = MediaQuery.of(context).size.width <= 800;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Text(
                        'Flutter Developer • Web Developer',
                        style: TextStyle(
                          color: Color(0xFFC4B5FD),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Sławomir Grelich',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.08,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tworzę nowoczesne aplikacje i strony internetowe, które pomagają firmom i ludziom działać lepiej w cyfrowym świecie.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCBD5E1),
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _InfoChip(label: 'Frontend'),
                        _InfoChip(label: 'Mobile'),
                        _InfoChip(label: 'Web'),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed: () => _scrollTo(_contactKey),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Napisz do mnie',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: openCv,
                          icon: const Icon(Icons.download_rounded, size: 19),
                          label: const Text(
                            'Pobierz CV',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF8B5CF6)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _openProjectsPage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Zobacz projekty',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8B5CF6)
                                      .withValues(alpha: 0.25),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          _buildProfileAvatar(),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PortfolioAvailabilityStatus(),
                          const SizedBox(width: 9),
                          const Text(
                            'Dostępny do współpracy',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Zaczynam od małych projektów, a z czasem rozwijam swoje portfolio i buduję profesjonalne realizacje.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFCBD5E1), height: 1.7),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          final profileWidth = constraints.maxWidth >= 1050 ? 420.0 : 360.0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Text(
                        'Flutter Developer • Web Developer',
                        style: TextStyle(
                          color: Color(0xFFC4B5FD),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Sławomir Grelich',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.08,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tworzę nowoczesne aplikacje i strony internetowe, które pomagają firmom i ludziom działać lepiej w cyfrowym świecie.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFCBD5E1),
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _InfoChip(label: 'Frontend'),
                        _InfoChip(label: 'Mobile'),
                        _InfoChip(label: 'Web'),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed: () => _scrollTo(_contactKey),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Napisz do mnie',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: openCv,
                          icon: const Icon(Icons.download_rounded, size: 19),
                          label: const Text(
                            'Pobierz CV',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF8B5CF6)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _openProjectsPage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Zobacz projekty',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Container(
                width: profileWidth,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6)
                                    .withValues(alpha: 0.25),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        _buildProfileAvatar(),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PortfolioAvailabilityStatus(),
                        const SizedBox(width: 9),
                        const Text(
                          'Dostępny do współpracy',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Zaczynam od małych projektów, a z czasem rozwijam swoje portfolio i buduję profesjonalne realizacje.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFCBD5E1), height: 1.7),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: 86,
      backgroundColor: const Color(0xFF0F172A),
      child: ClipOval(
        child: Image.network(
          'https://media.licdn.com/dms/image/v2/D4D03AQFCZcxcC5_iAg/profile-displayphoto-scale_400_400/B4DZ0Hj2h6IwAg-/0/1773948337829?e=1791417600&v=beta&t=GMYLbZkLTuPlZ6bcA-bih_wX54h0mNaa0hvFTzQnueM',
          width: 172,
          height: 172,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person_rounded,
              size: 82,
              color: Color(0xFF22D3EE),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || uri.hasScheme == false || uri.host.isEmpty) {
        return;
      }

      final canOpen = await canLaunchUrl(uri);
      if (canOpen) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      return;
    }
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 32) / 3;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                label: 'Rok doświadczenia w IT',
                value: '1+',
                accent: const Color(0xFF8B5CF6),
                icon: Icons.work_history_rounded,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                label: 'Zrealizowanych projektów',
                value: '5+',
                accent: const Color(0xFF22D3EE),
                icon: Icons.folder_special_rounded,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                label: 'Freelance & B2B',
                value: 'Dostępność',
                accent: const Color(0xFF34D399),
                icon: Icons.rocket_launch_rounded,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 800;
          final textWidth = isNarrow
              ? constraints.maxWidth
              : constraints.maxWidth - 304;
          final textColumn = SizedBox(
            width: textWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'O mnie',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Jestem osobą, która od początku interesuje się technologią, projektowaniem i tworzeniem rozwiązań, które mają sens i działają w praktyce. Chcę rozwijać się w obszarze tworzenia aplikacji i stron internetowych oraz zdobywać doświadczenie, które pozwoli mi później zarabiać na swojej pracy w świecie cyfrowym.',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.8,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Moim celem jest budowa profesjonalnego portfolio, ciągłe uczenie się nowych technologii, a potem tworzenie stron i aplikacji, które spełniają wymagania klientów i są atrakcyjne wizualnie oraz wygodne w użyciu.',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.8,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),
          );
          final valuesCard = SizedBox(
            width: 280,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Moje wartości',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 18),
                  _ValueRow(
                    icon: Icons.auto_awesome,
                    label: 'Nowoczesny design',
                  ),
                  _ValueRow(icon: Icons.speed, label: 'Wydajność i ergonomia'),
                  _ValueRow(
                    icon: Icons.psychology_alt_rounded,
                    label: 'Ciągły rozwój',
                  ),
                  _ValueRow(
                    icon: Icons.lightbulb_rounded,
                    label: 'Pomysłowość i zaangażowanie',
                  ),
                ],
              ),
            ),
          );

          return isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textColumn,
                    const SizedBox(height: 24),
                    valuesCard,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [textColumn, const SizedBox(width: 24), valuesCard],
                );
        },
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Usługi i specjalizacje',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 900;

            if (isNarrow) {
              return Column(
                children: [
                  _buildServiceCard(
                    title: 'Aplikacje mobilne',
                    text: 'Tworzenie responsywnych i nowoczesnych aplikacji mobilnych w technologii Flutter z naciskiem na wygodę użytkownika.',
                    icon: Icons.phone_iphone_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildServiceCard(
                    title: 'Strony internetowe',
                    text: 'Projektowanie i wdrażanie estetycznych stron internetowych, które dobrze działają na komputerze, tablecie i telefonie.',
                    icon: Icons.language_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildServiceCard(
                    title: 'UI/UX i prototypy',
                    text: 'Budowanie przejrzystych interfejsów oraz prostych prototypów, które wspierają komfort użytkowania i dobry wizerunek marki.',
                    icon: Icons.design_services_rounded,
                  ),
                ],
              );
            }

            final cardWidth = (constraints.maxWidth - 32) / 3;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _buildServiceCard(
                    title: 'Aplikacje mobilne',
                    text: 'Tworzenie responsywnych i nowoczesnych aplikacji mobilnych w technologii Flutter z naciskiem na wygodę użytkownika.',
                    icon: Icons.phone_iphone_rounded,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildServiceCard(
                    title: 'Strony internetowe',
                    text: 'Projektowanie i wdrażanie estetycznych stron internetowych, które dobrze działają na komputerze, tablecie i telefonie.',
                    icon: Icons.language_rounded,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _buildServiceCard(
                    title: 'UI/UX i prototypy',
                    text: 'Budowanie przejrzystych interfejsów oraz prostych prototypów, które wspierają komfort użytkowania i dobry wizerunek marki.',
                    icon: Icons.design_services_rounded,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTechnologiesSection() {
    const technologies = [
      _TechnologyData(
        name: 'Flutter',
        subtitle: 'Aplikacje mobilne i webowe',
        icon: Icons.flutter_dash_rounded,
        color: Color(0xFF22D3EE),
      ),
      _TechnologyData(
        name: 'Dart',
        subtitle: 'Logika i architektura aplikacji',
        icon: Icons.code_rounded,
        color: Color(0xFF60A5FA),
      ),
      _TechnologyData(
        name: 'HTML & CSS',
        subtitle: 'Nowoczesne strony internetowe',
        icon: Icons.language_rounded,
        color: Color(0xFFF97316),
      ),
      _TechnologyData(
        name: 'Git & GitHub',
        subtitle: 'Wersjonowanie i publikacja kodu',
        icon: Icons.account_tree_rounded,
        color: Color(0xFF34D399),
      ),
      _TechnologyData(
        name: 'Figma',
        subtitle: 'Projekty UI i prototypy',
        icon: Icons.design_services_rounded,
        color: Color(0xFFF472B6),
      ),
      _TechnologyData(
        name: 'VS Code',
        subtitle: 'Codzienne środowisko pracy',
        icon: Icons.terminal_rounded,
        color: Color(0xFF818CF8),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Technologie',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Narzędzia, których używam do tworzenia funkcjonalnych i dopracowanych realizacji.',
          style: TextStyle(fontSize: 16, color: Color(0xFFCBD5E1), height: 1.6),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 580
                ? 2
                : 1;
            final itemWidth =
                (constraints.maxWidth - (columns - 1) * 16) / columns;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final technology in technologies)
                  SizedBox(
                    width: itemWidth,
                    child: _TechnologyCard(data: technology),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildProcessSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jak pracuję',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final stepWidth = (constraints.maxWidth - 32) / 3;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: stepWidth,
                    child: const _ProcessStep(
                      number: '01',
                      title: 'Analiza',
                      subtitle: 'Rozumiem cel i potrzeby projektu.',
                    ),
                  ),
                  SizedBox(
                    width: stepWidth,
                    child: const _ProcessStep(
                      number: '02',
                      title: 'Projekt',
                      subtitle: 'Tworzę strukturę i wygląd interfejsu.',
                    ),
                  ),
                  SizedBox(
                    width: stepWidth,
                    child: const _ProcessStep(
                      number: '03',
                      title: 'Realizacja',
                      subtitle: 'Buduję działający efekt końcowy.',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF22D3EE).withValues(alpha: 0.5),
        ),
      ),
      child: Form(
        key: _contactFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chcesz współpracować?',
              style: TextStyle(
                color: Color(0xFF67E8F9),
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Zacznijmy od pierwszego projektu i zbudujmy coś naprawdę dobrego.',
              style: TextStyle(color: Color(0xFFE9D5FF), fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
              decoration: _contactInputDecoration('Imię'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Podaj imię' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _contactInputDecoration('Email'),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty || email.contains('@') == false) {
                  return 'Podaj poprawny email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: _contactInputDecoration('Wiadomość'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Napisz wiadomość'
                  : null,
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitContactForm,
              icon: Icon(
                _isSubmitting
                    ? Icons.hourglass_top_rounded
                    : Icons.send_rounded,
                size: 18,
              ),
              label: Text(
                _isSubmitting ? 'Wysyłanie...' : 'Wyślij wiadomość',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22D3EE),
                foregroundColor: const Color(0xFF07111F),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 17,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _contactInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFF1E293B),
      labelStyle: const TextStyle(color: Color(0xFFE2E8F0)),
      floatingLabelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF475569)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 1.5),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color accent,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 28),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String text,
    required IconData icon,
  }) {
    return PortfolioHoverLift(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF8B5CF6), size: 28),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
                color: Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFE2E8F0),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TechnologyData {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _TechnologyData({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _TechnologyCard extends StatelessWidget {
  final _TechnologyData data;

  const _TechnologyCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return PortfolioHoverLift(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textWidth = (constraints.maxWidth - 64).clamp(
              0.0,
              double.infinity,
            );
            return Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(data.icon, color: data.color, size: 27),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: textWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ValueRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF22D3EE), size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _ProcessStep({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.6),
          ),
        ],
      ),
    );
  }
}
