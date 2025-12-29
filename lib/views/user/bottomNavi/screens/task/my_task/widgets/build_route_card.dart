import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../tabs/task_location_display_screen.dart';

/// ROUTE TO DESTINATION CARD: title + map + button
Widget buildRouteCard({
  double? latitude,
  double? longitude,
  String? title,
  String? address,
}) {
  return CustomContainer(
    conColor: white2Color,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          'Route to Destination',
          fontSize: 14,
          fontWeight: FontVariant.semiBold,
          color: textcolord,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            if (latitude != null && longitude != null) {
              Get.to(
                () => TaskLocationDisplayScreen(
                  latitude: latitude,
                  longitude: longitude,
                  title: title ?? "Task Location",
                  address: address ?? "",
                ),
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: (latitude != null && longitude != null && latitude != 0.0 && longitude != 0.0)
                ? Image.network(
                    "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=14&size=600x300&markers=color:red%7C$latitude,$longitude&key=AIzaSyCOMKFm2vVK0w3FRoUWJvv6wv1NvD_s60k",
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 170,
                        color: bordercolor1,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(redColor),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/location.png',
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/location.png',
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            if (latitude != null && longitude != null) {
               Get.to(
                () => TaskLocationDisplayScreen(
                  latitude: latitude,
                  longitude: longitude,
                  title: title ?? "Task Location",
                  address: address ?? "",
                ),
              );
            }
          },
          child: CustomContainer(
            height: 46,
            conColor: whiteColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: redColor, width: 1.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 560,
                  child: const Icon(
                    Icons.navigation_outlined,
                    color: redColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const CustomText(
                  'Open Navigation',
                  fontSize: 14,
                  fontWeight: FontVariant.semiBold,
                  color: redColor,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
