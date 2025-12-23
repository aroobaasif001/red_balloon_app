import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../controller/home_controller.dart';

class CustomBonusSlider extends StatefulWidget {
  const CustomBonusSlider({super.key});

  @override
  State<CustomBonusSlider> createState() => _CustomBonusSliderState();
}

class _CustomBonusSliderState extends State<CustomBonusSlider> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final controller = Get.find<HomeController>();
        final itemCount = controller.activeBanners.isNotEmpty 
            ? controller.activeBanners.length 
            : 3; // Default bonus cards count

        int nextPage = currentIndex + 1;
        if (nextPage >= itemCount) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
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
    final controller = Get.find<HomeController>();

    return Obx(() {
      final banners = controller.activeBanners;
      final bool hasBanners = banners.isNotEmpty;
      final int itemCount = hasBanners ? banners.length : 3;

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // PAGEVIEW
          SizedBox(
            height: 214.5,
            child: PageView.builder(
              controller: _pageController,
              itemCount: itemCount,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                if (hasBanners) {
                  final banner = banners[index];
                  return CustomContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            banner.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: redColor),
                          ),
                          // Overlay for text if provided
                          if (banner.title.isNotEmpty || banner.description.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (banner.title.isNotEmpty)
                                    CustomText(
                                      banner.title,
                                      fontSize: 18,
                                      fontWeight: FontVariant.bold,
                                      color: whiteColor,
                                    ),
                                  if (banner.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: CustomText(
                                        banner.description,
                                        fontSize: 13,
                                        color: whiteColor.withOpacity(0.9),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Default bonus cards
                  final List<Map<String, String>> defaultCards = [
                    {"title": "Earn 15 SAR Bonus!", "subtitle": "Complete your first task today"},
                    {"title": "Get Rewarded Instantly", "subtitle": "Finish tasks and earn more coins"},
                    {"title": "Level Up Your Profile", "subtitle": "Stay active & unlock perks"},
                  ];
                  return CustomContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    conColor: redColor,
                    borderRadius: BorderRadius.circular(15),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          defaultCards[index]["title"]!,
                          fontSize: 20,
                          fontWeight: FontVariant.bold,
                          color: whiteColor,
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          defaultCards[index]["subtitle"]!,
                          fontSize: 14,
                          color: whiteColor.withOpacity(0.9),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),

          // CUSTOM INDICATOR
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(itemCount, (index) {
                bool isActive = currentIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 8,
                  width: isActive ? 22 : 8,
                  margin: EdgeInsets.only(right: index == itemCount - 1 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? whiteColor.withOpacity(0.9)
                        : whiteColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }
}
