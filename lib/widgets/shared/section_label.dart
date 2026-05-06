import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../theme/app_theme.dart';
import 'typewriter_text.dart';

class SectionLabel extends StatefulWidget {
  final String text;
  const SectionLabel({super.key, required this.text});

  @override
  State<SectionLabel> createState() => _SectionLabelState();
}

class _SectionLabelState extends State<SectionLabel> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('label-${widget.text}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5 && !_started) {
          setState(() => _started = true);
        }
      },
      child: SizedBox(
        height: 16,
        child: _started
            ? TypewriterText(
                text: widget.text,
                charDelayMs: 28,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.accentGreen,
                  letterSpacing: 3,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
