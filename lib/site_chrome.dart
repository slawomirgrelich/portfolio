import 'package:flutter/material.dart';

class PortfolioHoverLift extends StatefulWidget {
  final Widget child;

  const PortfolioHoverLift({super.key, required this.child});

  @override
  State<PortfolioHoverLift> createState() => _PortfolioHoverLiftState();
}

class _PortfolioHoverLiftState extends State<PortfolioHoverLift> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.015 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedSlide(
          offset: _isHovered ? const Offset(0, -0.015) : Offset.zero,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

class PortfolioAvailabilityStatus extends StatefulWidget {
  const PortfolioAvailabilityStatus({super.key});

  @override
  State<PortfolioAvailabilityStatus> createState() =>
      _PortfolioAvailabilityStatusState();
}

class _PortfolioAvailabilityStatusState
    extends State<PortfolioAvailabilityStatus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = Curves.easeInOut.transform(_controller.value);
        return Transform.scale(
          scale: 0.86 + pulse * 0.14,
          child: Opacity(opacity: 0.55 + pulse * 0.45, child: child),
        );
      },
      child: Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF34D399),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF34D399).withValues(alpha: 0.65),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioNavbar extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onAbout;
  final VoidCallback onServices;
  final VoidCallback onProjects;
  final VoidCallback onContact;
  final VoidCallback onGithub;
  final VoidCallback onLinkedIn;
  final bool showBackButton;

  const PortfolioNavbar({
    super.key,
    required this.onHome,
    required this.onAbout,
    required this.onServices,
    required this.onProjects,
    required this.onContact,
    required this.onGithub,
    required this.onLinkedIn,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final menu = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _NavigationChip(text: 'Start', onTap: onHome),
        _NavigationChip(text: 'O mnie', onTap: onAbout),
        _NavigationChip(text: 'Usługi', onTap: onServices),
        _NavigationChip(text: 'Projekty', onTap: onProjects),
        _NavigationChip(text: 'Kontakt', onTap: onContact),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: MediaQuery.of(context).size.width <= 800
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildBrand(),
                    const Spacer(),
                    if (showBackButton) _buildBackButton(context),
                  ],
                ),
                const SizedBox(height: 12),
                menu,
                const SizedBox(height: 4),
                _buildSocialActions(),
              ],
            )
          : Row(
              children: [
                _buildBrand(),
                const Spacer(),
                menu,
                const SizedBox(width: 12),
                _buildSocialActions(),
                if (showBackButton) ...[
                  const SizedBox(width: 8),
                  _buildBackButton(context),
                ],
              ],
            ),
    );
  }

  Widget _buildBrand() {
    return InkWell(
      onTap: onHome,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          const Text(
            'Sławomir Grelich',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialActions() {
    return Wrap(
      spacing: 2,
      children: [
        IconButton(
          tooltip: 'GitHub',
          onPressed: onGithub,
          icon: const Icon(Icons.code_rounded),
          color: const Color(0xFFE2E8F0),
        ),
        IconButton(
          tooltip: 'LinkedIn',
          onPressed: onLinkedIn,
          icon: const Icon(Icons.business_center_rounded),
          color: const Color(0xFF60A5FA),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      tooltip: 'Wróć na stronę główną',
      onPressed: onHome,
      icon: const Icon(Icons.arrow_back_rounded),
      color: Colors.white,
    );
  }
}

class PortfolioFooter extends StatelessWidget {
  final VoidCallback onGithub;
  final VoidCallback onLinkedIn;

  const PortfolioFooter({
    super.key,
    required this.onGithub,
    required this.onLinkedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final copyright = const Text(
                '© 2026 Sławomir Grelich. Wszystkie prawa zastrzeżone.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              );
              final socialActions = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FooterIconButton(
                    tooltip: 'LinkedIn',
                    icon: Icons.business_center_rounded,
                    color: const Color(0xFF60A5FA),
                    onTap: onLinkedIn,
                  ),
                  const SizedBox(width: 8),
                  _FooterIconButton(
                    tooltip: 'GitHub',
                    icon: Icons.code_rounded,
                    color: const Color(0xFFE2E8F0),
                    onTap: onGithub,
                  ),
                ],
              );

              return constraints.maxWidth <= 800
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        copyright,
                        const SizedBox(height: 12),
                        socialActions,
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [copyright, socialActions],
                    );
            },
          ),
        ),
      ),
    );
  }
}

class _NavigationChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _NavigationChip({required this.text, required this.onTap});

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
            color: Colors.white.withValues(alpha: 0.03),
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

class _FooterIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FooterIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      color: color,
      splashRadius: 24,
      hoverColor: color.withValues(alpha: 0.14),
      splashColor: color.withValues(alpha: 0.22),
      highlightColor: color.withValues(alpha: 0.1),
      style: IconButton.styleFrom(
        minimumSize: const Size(42, 42),
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
      ),
    );
  }
}
