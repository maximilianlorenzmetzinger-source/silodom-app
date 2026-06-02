// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 500 * 1024 * 1024;
  runApp(const SilodomApp());
}

class SilodomApp extends StatelessWidget {
  const SilodomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silodom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          surface: Colors.black,
          primary: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}