import 'package:flutter/material.dart';
import 'package:food_order_app/auth/rive_login_animation.dart';
import 'package:food_order_app/auth/signup_screen.dart';
import 'package:food_order_app/screens/home/home_screen.dart';
import 'package:food_order_app/db/database_helper.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  
  const LoginForm({
    super.key,
    this.onLoginSuccess,
  });

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

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      // Get user from database
      final user = await DatabaseHelper.instance.getUser(email, password);
      
      if (user != null) {
        _riveController?.setSuccess();
        
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Wait for animation
        await Future.delayed(const Duration(seconds: 2));
        
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );

        // Call the success callback
        widget.onLoginSuccess?.call();
      } else {
        _riveController?.setFail();
        
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
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
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }

    try {
      // ...existing validation code...

      final user = await DatabaseHelper.instance.getUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (user != null) {
        final success = await DatabaseHelper.instance.setCurrentUserId(user.id!);
        debugPrint('Login successful, user ID saved: $success');
        widget.onLoginSuccess?.call();
      } else {
        debugPrint('Login failed: User not found');
        // Show error message
      }
    } catch (e) {
      debugPrint('Login error: $e');
      // Show error message
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final user = await DatabaseHelper.instance.getUser(
          _emailController.text,
          _passwordController.text,
        );

        if (user != null && mounted) {
          widget.onLoginSuccess?.call(); // Gọi callback khi login thành công
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        debugPrint('Login error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
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
                onChanged: (value) {
                  final controller = RiveLoginAnimationController.of(context);
                  // Move eyes based on text length
                  if (value.isNotEmpty) {
                    final progress = value.length / 20; // Adjust denominator based on expected max length
                    controller?.setLookDirection(progress);
                  }
                },
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

              /// Forgot Password
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

              /// Sign Up
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
                    onPressed: _isLoading 
                      ? null 
                      : () {
                          // Pop any existing snackbars
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          
                          // Navigate with page route
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => 
                                const SignupScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              transitionDuration: const Duration(milliseconds: 300),
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
