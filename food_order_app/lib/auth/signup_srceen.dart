import 'package:flutter/material.dart';
import 'package:food_order_app/auth/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(16.0), child: SignupForm()),
      ),
    );
  }
}
