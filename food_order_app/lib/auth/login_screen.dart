import 'package:flutter/material.dart';
import 'package:food_order_app/auth/login_form.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';
import 'package:food_order_app/screens/home/home_screen.dart'; // Add this import

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

      // Short delay for animation and snackbar
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!context.mounted) return;

      // Use pushReplacement instead of pushReplacementNamed
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      
    } catch (e) {
      debugPrint('Navigation error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation failed: ${e.toString()}'),
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