import 'dart:async';

import 'package:flutter/material.dart';

import '../onboarding/onboarding.screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds and then navigate to the onboarding screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/logo1.png',
                width: 1435,
                fit: BoxFit.cover,
                color: Colors.green,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 400,
              height: 400,
            ),
          ),
        ],
      ),
    );
  }
}
