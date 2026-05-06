import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bgPrimary     = Color(0xFF010409);
  static const Color bgSurface     = Color(0xFF0d1117);
  static const Color borderSubtle  = Color(0xFF21262d);
  static const Color borderDefault = Color(0xFF30363d);
  static const Color accentBlue    = Color(0xFF58a6ff);
  static const Color accentGreen   = Color(0xFF3fb950);
  static const Color textPrimary   = Color(0xFFe6edf3);
  static const Color textSecondary = Color(0xFF8b949e);

  static const double mobileBreakpoint  = 600;
  static const double desktopBreakpoint = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static EdgeInsets sectionPadding(BuildContext context) =>
      isMobile(context)
          ? const EdgeInsets.symmetric(vertical: 48, horizontal: 22)
          : const EdgeInsets.symmetric(vertical: 100, horizontal: 96);

  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: bgPrimary,
    colorScheme: const ColorScheme.dark(
      surface: bgPrimary,
      primary: accentBlue,
      secondary: accentGreen,
    ),
    textTheme: GoogleFonts.sourceCodeProTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
  );
}
