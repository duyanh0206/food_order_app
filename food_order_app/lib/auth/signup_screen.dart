import 'package:flutter/material.dart';
import 'package:food_order_app/auth/signup_form.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  Future<void> _handleSignupSuccess(BuildContext context) async {
    try {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // Wait for animation
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!context.mounted) return;
      
      // Navigate to login
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E2E9),
      body: Stack(
        fit: StackFit.expand, // Add this to ensure Stack fills screen
        children: [
          // Form with animation
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top - 40,  // Move form up
            ),
            child: RiveLoginAnimationWrapper(
              child: SignupForm(
                onSignupSuccess: () => _handleSignupSuccess(context),
              ),
            ),
          ),

          // Back button - Move it to be on top of other widgets
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: Material(
              color: Colors.white.withOpacity(0.8), // Add background color
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.of(context).pop(); // Use pop() instead
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}