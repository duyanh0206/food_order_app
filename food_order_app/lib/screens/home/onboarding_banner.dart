import 'dart:async';

import 'package:flutter/cupertino.dart';

class OnboardingBanner extends StatefulWidget {
  @override
  _OnboardingBannerState createState() => _OnboardingBannerState();
}

class _OnboardingBannerState extends State<OnboardingBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _images = [
    'assets/images/boarding_home1.png',
    'assets/images/boarding_home2.png',
    'assets/images/boarding_home1.png',
    'assets/images/boarding_home2.png',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 335,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Image.asset(_images[index], fit: BoxFit.cover);
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
