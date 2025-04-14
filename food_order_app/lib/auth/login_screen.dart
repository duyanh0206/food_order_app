import 'package:flutter/material.dart';
import 'package:food_order_app/auth/login_form.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFD9E2E9), // Match bear background color
      body: RiveLoginAnimationWrapper(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(children: [SizedBox(height: 24), LoginForm()]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}