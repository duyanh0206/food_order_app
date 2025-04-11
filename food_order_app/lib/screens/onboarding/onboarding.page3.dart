import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_texts.dart';

class OnboardingPage3 extends StatelessWidget {
  final int currentIndex;
  final void Function()? onStart;

  const OnboardingPage3({this.currentIndex = 2, this.onStart, super.key});

  Future<void> _handleStart(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (onStart != null) {
      onStart!(); // navigate to LoginScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(LogoApp.logoBobo.path, height: 40)],
            ),

            SizedBox(height: size.height * 0.03),

            // Illustration image
            Image.asset(LogoApp.boarding3.path, height: size.height * 0.35),

            SizedBox(height: size.height * 0.04),

            // Title
            Text(
              getContents()[2].title,
              style: AppTextStyles.onboardingTitle1.copyWith(
                color: AppColors.boardingColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              getContents()[2].description,
              style: AppTextStyles.onboardingTitle2.copyWith(
                color: AppColors.boardingColor,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Dot indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => _buildDot(isActive: index == currentIndex),
              ),
            ),

            const SizedBox(height: 20),

            // Start button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _handleStart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Icon(
        isActive ? Icons.check_circle : Icons.circle_outlined,
        color: isActive ? AppColors.secondaryColor : Colors.grey.shade400,
        size: isActive ? 20 : 16,
      ),
    );
  }
}
