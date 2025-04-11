import 'package:flutter/material.dart';

import 'onboarding.page1.dart';
import 'onboarding.page2.dart';
import 'onboarding.page3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final index = _controller.page?.round() ?? 0;
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _controller.removeListener(_onPageChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        children: [
          OnboardingPage1(
            controller: _controller,
            currentIndex: _currentIndex,
            onSkip: () => _goToLogin(context),
          ),
          OnboardingPage2(
            controller: _controller,
            currentIndex: _currentIndex,
            onSkip: () => _goToLogin(context),
          ),
          OnboardingPage3(
            currentIndex: _currentIndex,
            onStart: () => _goToLogin(context),
          ),
        ],
      ),
    );
  }
}
