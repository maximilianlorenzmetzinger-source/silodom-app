// lib/screens/placeholder_screen.dart

import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    if (title == 'Love & Peace') {
      return const LovePeaceScreen();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 18,
            letterSpacing: 6,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class LovePeaceScreen extends StatelessWidget {
  const LovePeaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 60, 28, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LOVE & PEACE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 40),

              // Regeln
              _buildText(
                '❗️ NO HATE ❗️\n❗️ NO RACISM ❗️\n❗️ NO SEXISM ❗️\n❗️ NO HOMOPHOBIA ❗️\n❗️ NO TRANSPHOBIA ❗️\n❗️ NO VIOLENCE ❗️\n❗️ NO DISCRIMINATION ❗️\n❗️ NO HARASSMENT ❗️',
              ),

              _buildDivider(),

              _buildText(
                '🖤 Respect every human.\n🤝 Look out for each other.\n🫶 Consent is mandatory.\n🌈 Diversity makes us stronger.\n🕊 Freedom, tolerance & solidarity.',
              ),

              _buildDivider(),

              _buildText(
                '✌️ Peace, Love & Osthafen.\n🕊 Freiheit & Frieden für alle Völker.\n🎵 Ein Floor. Eine Community. Ein Vibe.',
              ),

              const SizedBox(height: 24),

              _buildText(
                'Wer unsere Werte nicht respektiert, hat auf unserem Dancefloor keinen Platz. 🖤⛓️🔥',
                bold: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          height: 1.9,
          letterSpacing: 0.3,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        '──────────────',
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 14,
        ),
      ),
    );
  }
}