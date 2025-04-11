import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/user_model.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _signup() async {
    final user = UserModel(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    await DatabaseHelper().insertUser(user);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User registered successfully')),
    );
    Navigator.pushReplacementNamed(context, '/home', arguments: user.name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        ElevatedButton(onPressed: _signup, child: const Text('Signup')),
      ],
    );
  }
}
