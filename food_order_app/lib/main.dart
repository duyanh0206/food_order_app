import 'package:flutter/material.dart';
import 'package:food_order_app/screens/onboarding/onboarding.screen.dart';
import 'package:food_order_app/screens/splash/splash.screen.dart';
import 'package:food_order_app/auth/login_screen.dart';
import 'package:food_order_app/auth/signup_screen.dart';
import 'package:food_order_app/screens/home/home_screen.dart';
import 'package:food_order_app/screens/search/search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Order App',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      initialRoute: '/splash',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
