import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int charDelayMs;
  final int startDelayMs;
  final bool autoStart;
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDelayMs = 40,
    this.startDelayMs = 0,
    this.autoStart = true,
    this.onComplete,
  });

  @override
  State<TypewriterText> createState() => TypewriterTextState();
}

class TypewriterTextState extends State<TypewriterText> {
  String _displayed = '';
  bool _showCursor = true;
  bool _done = false;
  Timer? _charTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startCursorBlink();
    if (widget.autoStart) start();
  }

  void start() {
    if (widget.startDelayMs > 0) {
      Future.delayed(Duration(milliseconds: widget.startDelayMs), _typeChars);
    } else {
      _typeChars();
    }
  }

  void _typeChars() {
    int i = 0;
    _charTimer = Timer.periodic(Duration(milliseconds: widget.charDelayMs), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _displayed = widget.text.substring(0, i + 1));
      i++;
      if (i >= widget.text.length) {
        t.cancel();
        setState(() => _done = true);
        _cursorTimer?.cancel();
        widget.onComplete?.call();
      }
    });
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      if (mounted) setState(() => _showCursor = !_showCursor);
    });
  }

  @override
  void dispose() {
    _charTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const TextStyle(color: AppTheme.textPrimary);
    final cursorHeight = (style.fontSize ?? 16) * 1.2;

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: _displayed),
          if (!_done)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: AnimatedOpacity(
                opacity: _showCursor ? 1.0 : 0.0,
                duration: Duration.zero,
                child: Container(
                  width: 2,
                  height: cursorHeight,
                  color: AppTheme.accentBlue,
                  margin: const EdgeInsets.only(left: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
