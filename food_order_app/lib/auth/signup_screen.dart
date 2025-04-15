import 'package:flutter/material.dart';
import 'package:food_order_app/auth/signup_form.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';
import 'package:food_order_app/auth/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  void _handleSignupSuccess(BuildContext context) {
    // Clear any existing snackbars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    // Navigate using named route
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E2E9),
      body: SafeArea(
        child: Stack(
          children: [
            // Back button
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              child: Material(
                color: Colors.white.withOpacity(0.8),
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  color: Colors.black87,
                  splashColor: Colors.grey.withOpacity(0.5),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),

            // Form with animation
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: RiveLoginAnimationWrapper(
                child: SignupForm(
                  onSignupSuccess: () => _handleSignupSuccess(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}