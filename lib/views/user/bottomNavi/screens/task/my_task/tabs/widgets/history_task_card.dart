import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class HistoryTaskCard extends StatelessWidget {
  final String title;
  final String amount;
  final String location;
  final String dateTime;
  final String statusText;
  final Color statusBgColor;
  final Color statusTextColor;
  final VoidCallback? onViewDetails;

  const HistoryTaskCard({
    super.key,
    required this.title,
    required this.amount,
    required this.location,
    required this.dateTime,
    required this.statusText,
    required this.statusBgColor,
    required this.statusTextColor,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.1),
          offset: const Offset(0, 2),
          blurRadius: 8,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          CustomText(
            title,
            fontSize: 18,
            fontWeight: FontVariant.bold,
            color: blackColor,
          ),
          const SizedBox(height: 8),

          // Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                amount,
                fontSize: 18,
                fontWeight: FontVariant.bold,
                color: blackColor,
              ),
              // Status Badge (Circular/Pill-shaped)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  statusText,
                  fontSize: 14,
                  fontWeight: FontVariant.medium,
                  color: statusTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Location and DateTime Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (location.isNotEmpty) ...[
                      CustomText(
                        location,
                        fontSize: 14,
                        fontWeight: FontVariant.regular,
                        color: grey6Color,
                      ),
                      const SizedBox(height: 8),
                    ],
                    CustomText(
                      dateTime,
                      fontSize: 14,
                      fontWeight: FontVariant.regular,
                      color: grey6Color,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onViewDetails,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      'View Details',
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      color: const Color(0xFFE53935),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xFFE53935),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // View Details Link
        ],
      ),
    );
  }
}
