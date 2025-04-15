import 'package:flutter/material.dart';
import 'package:food_order_app/screens/onboarding/onboarding.screen.dart';
import 'package:food_order_app/screens/splash/splash.screen.dart';
import 'package:food_order_app/auth/login_screen.dart';
import 'package:food_order_app/auth/signup_screen.dart';

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
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/splash': (_) => const SplashScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
