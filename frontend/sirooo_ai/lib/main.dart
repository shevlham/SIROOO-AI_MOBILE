import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const SiroooAiApp());
}

class SiroooAiApp extends StatelessWidget {
  const SiroooAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIROOO AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          primary: AppConstants.primaryColor,
          secondary: AppConstants.accentColor,
        ),
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        fontFamily: 'Inter', // Assuming Inter or similar is used
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
