import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class SenderBubble extends StatelessWidget {
  final String text;
  final String time;
  final String? imageUrl; // 🔥 Added for images
  final VoidCallback? onTapImage; // 🔥 Added for fullscreen

  const SenderBubble({
    super.key,
    required this.text,
    required this.time,
    this.imageUrl,
    this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomContainer(
                  conColor: redColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  // constraints: const BoxConstraints(
                  //   maxWidth: 292,
                  // ),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? GestureDetector(
                          onTap: onTapImage,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl!,
                              width: 200,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: whiteColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, color: whiteColor);
                              },
                            ),
                          ),
                        )
                      : CustomText(text, fontSize: 15, color: whiteColor),
                ),

                const SizedBox(height: 6),

                CustomText(time, fontSize: 11, color: timeColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
