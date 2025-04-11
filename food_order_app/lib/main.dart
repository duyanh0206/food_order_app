import 'package:flutter/material.dart';
import 'package:food_order_app/screens/onboarding/onboarding.screen.dart';
import 'package:food_order_app/screens/splash/splash.screen.dart';

import 'auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Order App',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Roboto'),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
