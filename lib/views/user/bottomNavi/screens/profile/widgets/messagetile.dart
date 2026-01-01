import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

class MessageTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final String message;
  final String time;
  final String image;
  final int unreadCount;
  final VoidCallback? onTap;
  final bool isSuspended;

  const MessageTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.message,
    required this.time,
    required this.image,
    this.unreadCount = 0,
    this.onTap,
    this.isSuspended = false,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = image.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // USER IMAGE + ONLINE DOT
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: ColorFiltered(
                        colorFilter: isSuspended
                            ? const ColorFilter.matrix([
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                              ])
                            : const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              ),
                        child: isNetworkImage
                            ? Image.network(
                                image,
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/user1.png',
                                    height: 48,
                                    width: 48,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                image,
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (!isSuspended) // 🔥 Hide dot if suspended
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: greenColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: whiteColor, width: 2),
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
                        isSuspended ? "Suspended Account" : name,
                        fontSize: 16,
                        fontWeight: FontVariant.semiBold,
                        color: isSuspended ? greyColor : blackColor,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(time, fontSize: 12, color: timeColor),
                    if (unreadCount > 0) ...[
                      const SizedBox(height: 6),
                      Container(
                        height: 22,
                        width: 22,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: redColor,
                          shape: BoxShape.circle,
                        ),
                        child: CustomText(
                          unreadCount > 9 ? "9+" : "$unreadCount",
                          fontSize: 12,
                          color: whiteColor,
                          fontWeight: FontVariant.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
