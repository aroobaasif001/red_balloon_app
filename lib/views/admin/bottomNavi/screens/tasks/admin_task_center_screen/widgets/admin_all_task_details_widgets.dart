import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

/// Task Info Card Widget
class TaskInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String completedTime;
  final String taskId;
  final String budget;
  final String status;
  final String? imageUrl;

  const TaskInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.completedTime,
    required this.taskId,
    required this.budget,
    required this.status,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      borderRadius: BorderRadius.circular(20),
      conColor: whiteColor,
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.20),
          blurRadius: 3,
          offset: const Offset(0, 4),
        ),
      ],
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 15,
                  color: walletTextGreyColor,
                ),
                const SizedBox(width: 1),
                CustomText(
                  location,
                  fontSize: 12,
                  color: timeColor,
                  fontWeight: FontVariant.medium,
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: 40,
                width: 33,
                color: rdBgColor,
                borderRadius: BorderRadius.circular(14),
                alignment: Alignment.center,
                child: Image.asset("assets/icons/div (3).png", height: 28),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    CustomText(
                      title,
                      fontSize: 15,
                      fontWeight: FontVariant.semiBold,
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      description,
                      fontSize: 14,
                      color: timeColor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      completedTime,
                      fontSize: 12,
                      color: walletGrey600Color,
                    ),
                    CustomText(
                      "Task ID: $taskId",
                      fontSize: 12,
                      color: timeColor,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CustomText(
                          budget,
                          fontSize: 14,
                          fontWeight: FontVariant.semiBold,
                          color: redColor,
                        ),
                        const SizedBox(width: 12),
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          conColor: _getStatusColor(status).withOpacity(0.1),
                          child: CustomText(
                            status,
                            fontSize: 11,
                            color: _getStatusColor(status),
                            fontWeight: FontVariant.medium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return historyGreenColor;
      case 'in progress':
        return orangeColor;
      case 'disputed':
        return redColor;
      default:
        return taskstatus3;
    }
  }
}

/// Participant Card Widget
class ParticipantCard extends StatelessWidget {
  final String name;
  final String userId;
  final String? imageUrl;
  final String role; // "Requester" or "Helper"
  final Map<String, String> stats; // {"label": "value"}

  const ParticipantCard({
    super.key,
    required this.name,
    required this.userId,
    this.imageUrl,
    required this.role,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      conColor: whiteColor,
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.20),
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: redColor,
                backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? NetworkImage(imageUrl!)
                    : null,
                child: (imageUrl == null || imageUrl!.isEmpty)
                    ? CustomText(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        fontSize: 20,
                        color: whiteColor,
                        fontWeight: FontVariant.bold,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: CustomText(
                            name,
                            fontSize: 16,
                            fontWeight: FontVariant.semiBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.check_circle,
                          color: historyGreenColor,
                          size: 18,
                        ),
                      ],
                    ),
                    CustomText(
                      "$role ID: $userId",
                      fontSize: 12,
                      color: timeColor,
                    ),
                  ],
                ),
              ),
              CustomContainer(
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                borderRadius: BorderRadius.circular(10),
                conColor: role == "Helper" ? helpBgColor : rdBgColor,
                child: CustomText(
                  role,
                  fontSize: 12,
                  color: role == "Helper" ? blackColor : redColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stats.entries.map((entry) {
              return Column(
                children: [
                  CustomText(
                    entry.value,
                    fontSize: 16,
                    fontWeight: FontVariant.semiBold,
                  ),
                  CustomText(entry.key, fontSize: 12, color: timeColor),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Offer Card Widget
class OfferCard extends StatelessWidget {
  final String name;
  final String userId;
  final String amount;
  final bool isAccepted;
  final String? imageUrl;

  const OfferCard({
    super.key,
    required this.name,
    required this.userId,
    required this.amount,
    required this.isAccepted,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      conColor: whiteColor,
      border: Border.all(
        color: isAccepted ? historyGreenColor : bordercol,
        width: isAccepted ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.10),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: redColor,
            backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                ? NetworkImage(imageUrl!)
                : null,
            child: (imageUrl == null || imageUrl!.isEmpty)
                ? CustomText(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    fontSize: 18,
                    color: whiteColor,
                    fontWeight: FontVariant.bold,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  name,
                  fontSize: 15,
                  fontWeight: FontVariant.semiBold,
                ),
                CustomText(userId, fontSize: 12, color: timeColor),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                amount,
                fontSize: 16,
                fontWeight: FontVariant.bold,
                color: redColor,
              ),
              if (isAccepted)
                CustomText(
                  "Accepted",
                  fontSize: 11,
                  color: historyGreenColor,
                  fontWeight: FontVariant.medium,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Info Row Widget
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, fontSize: 14, color: timeColor),
          Flexible(
            child: CustomText(
              value,
              fontSize: 14,
              fontWeight: FontVariant.medium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
