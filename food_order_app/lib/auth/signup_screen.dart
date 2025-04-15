import 'package:flutter/material.dart';
import 'package:food_order_app/auth/signup_form.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E2E9),
      body: Stack(
        children: [
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.of(context).pushReplacementNamed('/login');
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

          // Form with animation
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 40,
            ),
            child: RiveLoginAnimationWrapper(
              child: SignupForm(
                onSignupSuccess: () => Navigator.of(context).pushReplacementNamed('/login'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}