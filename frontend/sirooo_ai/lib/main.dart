import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
