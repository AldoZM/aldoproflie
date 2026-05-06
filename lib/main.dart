import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'home_page.dart';
import 'theme/app_theme.dart';

void main() {
  VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 100);
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Aldo Zetina — Portfolio',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    home: const HomePage(),
  );
}
