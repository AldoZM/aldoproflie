import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
import '../../../data/portfolio_data.dart';
import '../shared/typewriter_text.dart';
import '../shared/terminal_card.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _showPre = false, _showName = false, _showTitle = false,
       _showDesc = false, _showTerminal = false, _terminalCmd = false;
  final List<bool> _outputs = [false, false, false, false];
  bool _showButtons = false, _showHint = false;

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  Future<void> _runSequence() async {
    await _delay(300);
    _set(() => _showPre = true);
    await _delay(580);
    _set(() => _showName = true);
    await _delay(870);
    _set(() => _showTitle = true);
    await _delay(940);
    _set(() => _showDesc = true);
    await _delay(1140);
    _set(() => _showTerminal = true);
    await _delay(400);
    _set(() => _terminalCmd = true);
    await _delay(830);
    for (int i = 0; i < _outputs.length; i++) {
      await _delay(220);
      _set(() => _outputs[i] = true);
    }
    await _delay(400);
    _set(() => _showButtons = true);
    await _delay(200);
    _set(() => _showHint = true);
  }

  Future<void> _delay(int ms) => Future.delayed(Duration(milliseconds: ms));
  void _set(VoidCallback fn) { if (mounted) setState(fn); }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppTheme.isMobile(context);
    return Container(
      padding: isMobile
          ? const EdgeInsets.fromLTRB(22, 52, 22, 40)
          : const EdgeInsets.fromLTRB(96, 100, 96, 100),
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 58),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_showPre) TypewriterText(
            text: '\$ whoami',
            charDelayMs: 40,
            style: const TextStyle(fontSize: 13, color: AppTheme.accentGreen, letterSpacing: 1),
          ),
          const SizedBox(height: 10),
          if (_showName) TypewriterText(
            text: 'Aldo Zetina Muciño',
            charDelayMs: 45,
            style: TextStyle(
              fontSize: isMobile ? 30 : 60,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          if (_showTitle) TypewriterText(
            text: 'Flutter Engineer · QA Automation · Infrastructure',
            charDelayMs: 18,
            style: TextStyle(fontSize: isMobile ? 13 : 20, color: AppTheme.accentBlue),
          ),
          const SizedBox(height: 16),
          if (_showDesc) TypewriterText(
            text: 'Computer Engineer from UNAM. Building reliable mobile\nexperiences and automated systems. Currently @ Banco de México.',
            charDelayMs: 12,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.9),
          ),
          const SizedBox(height: 32),
          AnimatedOpacity(
            opacity: _showTerminal ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: TerminalCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text('aldo@dev:~\$ ', style: TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                      if (_terminalCmd) TypewriterText(
                        text: ' cat about.txt',
                        charDelayMs: 55,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                      ),
                    ]),
                    if (_outputs[0]) const TerminalOutput(text: '📍 Mexico City, Mexico'),
                    if (_outputs[1]) const TerminalOutput(text: '🎓 B.S. Computer Engineering — UNAM (2025)'),
                    if (_outputs[2]) const TerminalOutput(text: '💼 Network Infra Intern — Banco de México'),
                    if (_outputs[3]) const TerminalOutput(text: '▸ Open to opportunities', color: AppTheme.accentGreen),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Text('aldo@dev:~\$ ', style: TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                      _BlinkingCursor(),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          if (_showButtons)
            (isMobile
                ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    _HeroBtn(label: './view_projects', primary: true, onTap: () {}),
                    const SizedBox(height: 10),
                    _HeroBtn(label: './download_cv', primary: false,
                        onTap: () => launchUrl(Uri.parse(PortfolioData.githubUrl))),
                  ])
                : Row(children: [
                    _HeroBtn(label: './view_projects', primary: true, onTap: () {}),
                    const SizedBox(width: 12),
                    _HeroBtn(label: './download_cv', primary: false,
                        onTap: () => launchUrl(Uri.parse(PortfolioData.githubUrl))),
                  ])
            ).animate().fadeIn(duration: 500.ms),
          const SizedBox(height: 40),
          if (_showHint)
            const Text('▼  scroll to explore',
                style: TextStyle(fontSize: 11, color: Color(0xFF3D4451)))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideY(begin: 0, end: 0.3, duration: 1200.ms, curve: Curves.easeInOut),
        ],
      ),
    );
  }
}

class _HeroBtn extends StatefulWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;
  const _HeroBtn({required this.label, required this.primary, required this.onTap});

  @override
  State<_HeroBtn> createState() => _HeroBtnState();
}

class _HeroBtnState extends State<_HeroBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
        decoration: BoxDecoration(
          color: widget.primary
              ? (_hovered ? AppTheme.accentBlue.withOpacity(0.8) : AppTheme.accentBlue)
              : Colors.transparent,
          border: Border.all(color: AppTheme.accentBlue),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(widget.label,
            style: TextStyle(
              fontSize: 12, letterSpacing: 1,
              color: widget.primary ? AppTheme.bgPrimary : AppTheme.accentBlue,
              fontWeight: widget.primary ? FontWeight.bold : FontWeight.normal,
            )),
      ),
    ),
  );
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 530),
        (_) { if (mounted) setState(() => _visible = !_visible); });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: _visible ? 1.0 : 0.0,
    duration: Duration.zero,
    child: Container(width: 2, height: 14, color: AppTheme.accentBlue),
  );
}
