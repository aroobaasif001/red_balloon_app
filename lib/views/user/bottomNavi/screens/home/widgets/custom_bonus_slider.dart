import 'dart:async';

import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomBonusSlider extends StatefulWidget {
  const CustomBonusSlider({super.key});

  @override
  State<CustomBonusSlider> createState() => _CustomBonusSliderState();
}

class _CustomBonusSliderState extends State<CustomBonusSlider> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  Timer? _autoSlideTimer;

  final List<Map<String, String>> bonusCards = [
    {"title": "Earn 15 SAR Bonus!", "subtitle": "Complete your first task today"},
    {"title": "Get Rewarded Instantly", "subtitle": "Finish tasks and earn more coins"},
    {"title": "Level Up Your Profile", "subtitle": "Stay active & unlock perks"},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = currentIndex + 1;

        if (nextPage == bonusCards.length) {
          nextPage = 0; // restart from first slide
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );

        setState(() {
          currentIndex = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // PAGEVIEW
        SizedBox(
          height: 214.5,
          child: PageView.builder(
            controller: _pageController,
            itemCount: bonusCards.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              return CustomContainer(
                width: double.infinity,
                conColor: redColor,
                borderRadius: BorderRadius.circular(15),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      bonusCards[index]["title"]!,
                      fontSize: 20,
                      fontWeight: FontVariant.bold,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      bonusCards[index]["subtitle"]!,
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // CUSTOM INDICATOR
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bonusCards.length, (index) {
              bool isActive = currentIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 8,
                width: isActive ? 22 : 8,
                margin: EdgeInsets.only(right: index == bonusCards.length - 1 ? 0 : 6),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
