import 'package:flutter/material.dart';
import 'package:food_order_app/auth/login_form.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E2E9),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Form with animation
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top - 40, // Match signup's padding
            ),
            child: const RiveLoginAnimationWrapper(
              child: LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}