import 'package:flutter/material.dart';

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
          titleMedium: TextStyle(
            color: Color(0xFFE2E8F0),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFCBD5E1),
          ),
        ),
      ),
      home: const PortfolioHomePage(),
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

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 30),
                Container(key: _heroKey, child: _buildHeroSection()),
                const SizedBox(height: 30),
                _buildStatsRow(),
                const SizedBox(height: 40),
                Container(key: _aboutKey, child: _buildAboutSection()),
                const SizedBox(height: 40),
                Container(key: _servicesKey, child: _buildServicesSection()),
                const SizedBox(height: 40),
                _buildProcessSection(),
                const SizedBox(height: 40),
                Container(key: _contactKey, child: _buildContactBanner()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 700;

          return isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'SG',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Sławomir Grelich',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MenuChip(text: 'Start', onTap: () => _scrollTo(_heroKey)),
                        _MenuChip(text: 'O mnie', onTap: () => _scrollTo(_aboutKey)),
                        _MenuChip(text: 'Usługi', onTap: () => _scrollTo(_servicesKey)),
                        _MenuChip(text: 'Kontakt', onTap: () => _scrollTo(_contactKey)),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'SG',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Sławomir Grelich',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MenuChip(text: 'Start', onTap: () => _scrollTo(_heroKey)),
                        _MenuChip(text: 'O mnie', onTap: () => _scrollTo(_aboutKey)),
                        _MenuChip(text: 'Usługi', onTap: () => _scrollTo(_servicesKey)),
                        _MenuChip(text: 'Kontakt', onTap: () => _scrollTo(_contactKey)),
                      ],
                    ),
                  ],
                );
        },
      ),
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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 850;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.25)),
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
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Napisz do mnie',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
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
                                  color: const Color(0xFF8B5CF6).withOpacity(0.25),
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
                      const Text(
                        'Dostępny do współpracy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Zaczynam od małych projektów, a z czasem rozwijam swoje portfolio i buduję profesjonalne realizacje.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.25)),
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
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Napisz do mnie',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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
              const SizedBox(width: 30),
              Container(
                width: 420,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
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
                                color: const Color(0xFF8B5CF6).withOpacity(0.25),
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
                    const Text(
                      'Dostępny do współpracy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Zaczynam od małych projektów, a z czasem rozwijam swoje portfolio i buduję profesjonalne realizacje.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        height: 1.7,
                      ),
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(label: 'Lat doświadczenia', value: '1+', accent: const Color(0xFF8B5CF6)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(label: 'Projektów', value: '5+', accent: const Color(0xFF22D3EE)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(label: 'Cel', value: 'Freelance', accent: const Color(0xFF34D399)),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 280,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                  _ValueRow(icon: Icons.auto_awesome, label: 'Nowoczesny design'),
                  _ValueRow(icon: Icons.speed, label: 'Wydajność i ergonomia'),
                  _ValueRow(icon: Icons.psychology_alt_rounded, label: 'Ciągły rozwój'),
                  _ValueRow(icon: Icons.lightbulb_rounded, label: 'Pomysłowość i zaangażowanie'),
                ],
              ),
            ),
          ),
        ],
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

            return Row(
              children: [
                Expanded(
                  child: _buildServiceCard(
                    title: 'Aplikacje mobilne',
                    text: 'Tworzenie responsywnych i nowoczesnych aplikacji mobilnych w technologii Flutter z naciskiem na wygodę użytkownika.',
                    icon: Icons.phone_iphone_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildServiceCard(
                    title: 'Strony internetowe',
                    text: 'Projektowanie i wdrażanie estetycznych stron internetowych, które dobrze działają na komputerze, tablecie i telefonie.',
                    icon: Icons.language_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
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

  Widget _buildProcessSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
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
          Row(
            children: const [
              Expanded(child: _ProcessStep(number: '01', title: 'Analiza', subtitle: 'Rozumiem cel i potrzeby projektu.')),
              SizedBox(width: 16),
              Expanded(child: _ProcessStep(number: '02', title: 'Projekt', subtitle: 'Tworzę strukturę i wygląd interfejsu.')),
              SizedBox(width: 16),
              Expanded(child: _ProcessStep(number: '03', title: 'Realizacja', subtitle: 'Buduję działający efekt końcowy.')),
            ],
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
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 700;

          final textColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Chcesz współpracować?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Zacznijmy od pierwszego projektu i zbudujmy coś naprawdę dobrego.',
                style: TextStyle(
                  color: Color(0xFFE9D5FF),
                  fontSize: 16,
                ),
              ),
            ],
          );

          final actionButton = ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F2937),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Kontakt',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          );

          if (isNarrow) {
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [textColumn, actionButton],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: textColumn),
              actionButton,
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
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
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 14,
            ),
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
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.15),
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
    );
  }
}

class _MenuChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _MenuChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFFE2E8F0),
              fontWeight: FontWeight.w600,
            ),
          ),
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
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 15,
              ),
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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
