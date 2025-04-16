import 'package:flutter/material.dart';
import 'package:food_order_app/auth/login_form.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';
import 'package:food_order_app/screens/home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleLoginSuccess(BuildContext context) async {
    try {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // Wait for snackbar
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!context.mounted) return;

      // Clear navigation stack and go to HomeScreen
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Login navigation error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E2E9),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top - 40,
            ),
            child: RiveLoginAnimationWrapper(
              child: LoginForm(
                onLoginSuccess: () => _handleLoginSuccess(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}