// lib/screens/placeholder_screen.dart

import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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