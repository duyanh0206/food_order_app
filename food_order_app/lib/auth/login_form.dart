import 'package:flutter/material.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';
import 'package:food_order_app/auth/signup_screen.dart';
import 'package:food_order_app/screens/home/home_screen.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  RiveController? get _riveController =>
      RiveLoginAnimationController.of(context);

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_handleEmailFocusChange);
    _passwordFocus.addListener(_handlePasswordFocusChange);
  }

  void _handleEmailFocusChange() {
    if (_emailFocus.hasFocus) {
      _riveController?.setHandsUp(false);
    }
  }

  void _handlePasswordFocusChange() {
    _riveController?.setHandsUp(_passwordFocus.hasFocus);
  }

  void _onEmailChanged(String value) {
    if (!_passwordFocus.hasFocus) {
      double lookValue = value.isEmpty ? 0 : value.length / 20.0;
      _riveController?.setLookDirection(lookValue.clamp(0, 1));
    }
  }

  void _onPasswordChanged(String _) {
    // No animation needed for password changes
  }

  Future<void> _onLogin() async {
  if (!_formKey.currentState!.validate()) {
    _riveController?.setWrongInput(true);
    return;
  }

  final email = _emailController.text.trim();
  final password = _passwordController.text;

  setState(() => _isLoading = true);

  try {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'test@example.com' && password == 'password123') {
      _riveController?.setSuccess();
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;

      // Navigate to home screen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      _riveController?.setFail();
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;
    
    _riveController?.setFail();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login failed: ${e.toString()}'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Reduced padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(5, -85), // Move form up more
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.zero, // Remove margin
                padding: const EdgeInsets.fromLTRB(30, 64, 24, 32), // Adjusted padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 40,
                      offset: const Offset(0, -32),
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// Email
                          TextFormField(
                            focusNode: _emailFocus,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
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
                            validator: (value) =>
                                (value == null || value.isEmpty) ? 'Please enter your email' : null,
                          ),
                          const SizedBox(height: 20),

                          /// Password
                          TextFormField(
                            focusNode: _passwordFocus,
                            controller: _passwordController,
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
                            onChanged: _onPasswordChanged,
                            validator: (value) =>
                                (value == null || value.isEmpty) ? 'Please enter your password' : null,
                            onFieldSubmitted: (_) => _onLogin(),
                          ),
                          const SizedBox(height: 15),
                          /// Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Reset Password')),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// Login Button
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                              ),
                              onPressed: _isLoading ? null : _onLogin,
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
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          /// Sign Up Row - Now inside the form container
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}