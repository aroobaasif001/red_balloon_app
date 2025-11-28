import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../tabs/chat_screen.dart';

class MessageTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String message;
  final String time;
  final String image;

  const MessageTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.message,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          Get.to(() => ChatScreen());
        },
        child: CustomContainer(
          conColor:whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          padding: const EdgeInsets.all(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // USER IMAGE + ONLINE DOT
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      image,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color:greenColor,
                        shape: BoxShape.circle,
                        border: Border.all(color:whiteColor, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // NAME + SUBTITLE + MESSAGE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      name,
                      fontSize: 16,
                      fontWeight: FontVariant.semiBold,
                      color: blackColor,
                    ),

                    const SizedBox(height: 5),

                    CustomText(subtitle, fontSize: 12, color: timeColor),

                    const SizedBox(height: 6),

                    CustomText(
                      message,
                      fontSize: 14,
                      color: grey50Color,
                      fontWeight: FontVariant.regular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // TIME + BADGE
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(time, fontSize: 12, color: timeColor),
                  const SizedBox(width: 6),
                  Container(
                    height: 22,
                    width: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: redColor,
                      shape: BoxShape.circle,
                    ),
                    child: const CustomText(
                      "1",
                      fontSize: 12,
                      color: whiteColor,
                      fontWeight: FontVariant.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
