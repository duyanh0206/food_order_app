import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_texts.dart';
import '../../widget/custom_button.dart';

class OnboardingPage1 extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final void Function()? onSkip;

  const OnboardingPage1({
    required this.controller,
    this.currentIndex = 0,
    this.onSkip,
    super.key,
  });

  Future<void> _handleSkip(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (onSkip != null) {
      onSkip!(); // navigate to LoginScreen
    } else {
      controller.jumpToPage(2); // skip to last onboarding page
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(LogoApp.logoBobo.path, height: 40)],
            ),

            SizedBox(height: size.height * 0.03),

            // Illustration image
            Image.asset(LogoApp.boarding1.path, height: size.height * 0.35),

            SizedBox(height: size.height * 0.04),

            // Title
            Text(
              getContents()[0].title,
              style: AppTextStyles.onboardingTitle1.copyWith(
                color: AppColors.boardingColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              getContents()[0].description,
              style: AppTextStyles.onboardingTitle2.copyWith(
                color: AppColors.boardingColor,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Dot indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => buildDot(index: index)),
            ),

            const SizedBox(height: 20),

            // Skip and Next buttons
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomButton(
                    text: 'Skip',
                    onPressed: () => _handleSkip(context),
                    backgroundColor: Colors.white,
                    textColor: AppColors.secondaryColor,
                    border: BorderSide(color: AppColors.secondaryColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    text: 'Next',
                    onPressed:
                        () => controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                    backgroundColor: AppColors.secondaryColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot({required int index}) {
    final bool isActive = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondaryColor : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
