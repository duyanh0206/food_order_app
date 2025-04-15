import 'package:flutter/material.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';
import 'package:food_order_app/db/database_helper.dart';
import 'package:food_order_app/models/user_model.dart';
import 'dart:async'; // Add this import for TimeoutException

class SignupForm extends StatefulWidget {
  final VoidCallback? onSignupSuccess;
  
  const SignupForm({
    super.key, 
    this.onSignupSuccess,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  RiveController? get _riveController =>
      RiveLoginAnimationController.of(context);

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(_handleNameFocusChange);
    _emailFocus.addListener(_handleEmailFocusChange);
    _passwordFocus.addListener(_handlePasswordFocusChange);
    _confirmPasswordFocus.addListener(_handlePasswordFocusChange);
  }

  void _handleNameFocusChange() {
    if (_nameFocus.hasFocus) {
      _riveController?.setHandsUp(false);
      _onNameChanged(_nameController.text);
    }
  }

  void _handleEmailFocusChange() {
    if (_emailFocus.hasFocus) {
      _riveController?.setHandsUp(false);
      _onEmailChanged(_emailController.text);
    }
  }

  void _handlePasswordFocusChange() {
    _riveController?.setHandsUp(_passwordFocus.hasFocus || _confirmPasswordFocus.hasFocus);
  }

  void _onNameChanged(String value) {
    if (!_emailFocus.hasFocus && !_passwordFocus.hasFocus) {
      double lookValue = value.isEmpty ? 0 : value.length / 20.0;
      _riveController?.setLookDirection(lookValue.clamp(0, 1));
    }
  }

  void _onEmailChanged(String value) {
    if (!_passwordFocus.hasFocus && !_nameFocus.hasFocus) {
      double lookValue = value.isEmpty ? 0 : value.length / 20.0;
      _riveController?.setLookDirection(lookValue.clamp(0, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.60, // Increase height
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: [
                const SizedBox(height: 20), // Reduced top spacing
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 40,
                        offset: const Offset(0, -16),
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onChanged: _onNameChanged,
                          validator: (value) =>
                              (value == null || value.isEmpty) ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onChanged: _onEmailChanged,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegExp.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                                _riveController?.setHandsUp(!_isPasswordVisible);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          obscureText: !_isPasswordVisible,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              _riveController?.setWrongInput(true);
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _isLoading ? null : _onSignup,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSignup() async {
    if (!_formKey.currentState!.validate()) {
      _riveController?.setWrongInput(true);
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final user = UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text.trim(),
      );

      // Wrap database operation in catchError
      await DatabaseHelper.instance.createUser(user)
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Database operation timed out'),
        )
        .catchError((error) {
          throw Exception('Failed to create user: $error');
        });

      if (!mounted) return;

      _riveController?.setSuccess();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Call the success callback
      widget.onSignupSuccess?.call();

    } catch (e) {
      if (!mounted) return;
      
      _riveController?.setFail();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is TimeoutException 
                ? 'Registration timed out. Please try again.' 
                : 'Registration failed: ${e.toString()}'
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      
      debugPrint('Signup error: $e'); // Add logging for debugging
      
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
