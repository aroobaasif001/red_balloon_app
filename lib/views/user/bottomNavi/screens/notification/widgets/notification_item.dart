import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/expandable_text.dart';
import 'package:red_balloon_app/utils/colors.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final String? type; // success, danger, info, warning
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    this.type,
    required this.onTap,
  });

  Color _getTypeColor() {
    switch (type) {
      case 'success':
        return greenColor;
      case 'danger':
        return redColor;
      case 'warning':
        return orangeColor;
      case 'info':
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case 'success':
        return Icons.check_circle_outline;
      case 'danger':
        return Icons.error_outline;
      case 'warning':
        return Icons.warning_amber_outlined;
      case 'info':
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: isRead
              ? []
              : [
                  BoxShadow(
                    color: blackColor.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
          border:
              isRead ? null : Border.all(color: grey2Color.withOpacity(0.5)),
        ),
        child: Material(
          color: isRead ? white2Color : whiteColor,
          borderRadius: BorderRadius.circular(15),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(),
                      color: _getTypeColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                title,
                                fontSize: 16,
                                fontWeight: isRead
                                    ? FontVariant.medium
                                    : FontVariant.bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            CustomText(
                              time,
                              fontSize: 12,
                              color: grey4Color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ExpandableText(
                          text: body,
                          fontSize: 14,
                          color: isRead ? grey5Color : blackLightColor,
                          maxLines: 2,
                          fontWeight: FontVariant.regular,
                        ),
                      ],
                    ),
                  ),
                  if (!isRead)
                    Container(
                      margin: const EdgeInsets.only(left: 8, top: 4),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: redColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
