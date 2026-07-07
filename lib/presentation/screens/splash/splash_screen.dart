// TODO Implement this library.
// lib/presentation/screens/splash/splash_screen.dart

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.engineering_rounded, // Ícono de engranaje/soporte mecánico
              size: 80,
              color: Color(0xFFF97316), // Nuestro naranja de acento
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF97316)),
            ),
          ],
        ),
      ),
    );
  }
}
