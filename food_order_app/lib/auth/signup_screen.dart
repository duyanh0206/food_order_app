import 'package:flutter/material.dart';
import 'package:food_order_app/auth/signup_form.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E2E9),
      body: RiveLoginAnimationWrapper(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: SignupForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}