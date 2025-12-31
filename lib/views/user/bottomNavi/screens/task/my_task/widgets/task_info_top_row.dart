import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../utils/colors.dart';

class TaskInfoTopRow extends StatelessWidget {
  final String? distance;
  final String? price;
  final String? timeAgo;
  final String? taskId; // Unique identifier for each task
  final bool isOnline;

  const TaskInfoTopRow({
    super.key,
    this.distance,
    this.price,
    this.timeAgo,
    this.taskId,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller with unique tag if timeAgo is provided
    if (timeAgo != null && taskId != null) {
      final controller = Get.put(
        TimeAgoController(timeAgo: timeAgo!),
        tag: taskId,
      );
      controller.startTimer();
    }

    return Row(
      mainAxisAlignment: isOnline
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceBetween,
      children: [
        /// ---- Left Side ----
        if (!isOnline) ...[
          Row(
            children: [
              Image.asset("assets/icons/location2.png", height: 16),
              const SizedBox(width: 6),
              CustomText(
                "${distance ?? '--'} km away",
                fontSize: 12,
                fontWeight: FontVariant.medium,
              ),
            ],
          ),
          Image.asset("assets/icons/dot.png", height: 16, width: 7),
        ],

        Row(
          children: [
            CustomText(
              "${price ?? 'SAR 5000'}",
              fontSize: 12,
              fontWeight: FontVariant.semiBold,
              color: pricecolor,
            ),
          ],
        ),
        if (!isOnline) ...[
          Image.asset("assets/icons/dot.png", height: 6, width: 6),
        ],
        Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: walletGrey600Color),
            const SizedBox(width: 6),
            _buildTimeText(),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeText() {
    if (timeAgo != null && taskId != null) {
      try {
        final controller = Get.find<TimeAgoController>(tag: taskId);
        return Obx(
          () => CustomText(
            controller.timeAgoText.value,
            fontSize: 12,
            fontWeight: FontVariant.regular,
            color: walletGrey600Color,
          ),
        );
      } catch (e) {
        return CustomText(
          timeAgo ?? "15 mins ago",
          fontSize: 12,
          fontWeight: FontVariant.regular,
          color: walletGrey600Color,
        );
      }
    }

    return CustomText(
      timeAgo ?? "15 mins ago",
      fontSize: 12,
      fontWeight: FontVariant.regular,
      color: walletGrey600Color,
    );
  }
}

class TimeAgoController extends GetxController {
  final String timeAgo;
  final timeAgoText = ''.obs;
  Timer? _timer;
  DateTime? _createdAt;

  TimeAgoController({required this.timeAgo});

  @override
  void onInit() {
    super.onInit();
    _createdAt = _parseTimeAgo(timeAgo);
    timeAgoText.value = timeAgo;
  }

  DateTime _parseTimeAgo(String timeAgoStr) {
    final now = DateTime.now();

    // Parse different formats: "15 mins ago", "2h ago", "3d ago", "45s ago"
    final regExp = RegExp(
      r'(\d+)\s*(s|sec|second|m|min|minute|h|hour|d|day)s?\s*ago',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(timeAgoStr);

    if (match != null) {
      final value = int.parse(match.group(1)!);
      final unit = match.group(2)!.toLowerCase();

      if (unit.startsWith('s')) {
        return now.subtract(Duration(seconds: value));
      } else if (unit.startsWith('m')) {
        return now.subtract(Duration(minutes: value));
      } else if (unit.startsWith('h')) {
        return now.subtract(Duration(hours: value));
      } else if (unit.startsWith('d')) {
        return now.subtract(Duration(days: value));
      }
    }

    // Default: assume it was created just now
    return now;
  }

  void startTimer() {
    _updateTimeAgo();
    _scheduleNextUpdate();
  }

  void _updateTimeAgo() {
    if (_createdAt == null) return;

    final now = DateTime.now();
    final difference = now.difference(_createdAt!);

    if (difference.inSeconds < 60) {
      timeAgoText.value = '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      timeAgoText.value = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      timeAgoText.value = '${difference.inHours}h ago';
    } else {
      timeAgoText.value = '${difference.inDays}d ago';
    }
  }

  void _scheduleNextUpdate() {
    _timer?.cancel();

    if (_createdAt == null) return;

    final now = DateTime.now();
    final difference = now.difference(_createdAt!);

    Duration updateInterval;

    if (difference.inSeconds < 60) {
      updateInterval = const Duration(seconds: 1);
    } else if (difference.inMinutes < 60) {
      updateInterval = const Duration(minutes: 1);
    } else if (difference.inHours < 24) {
      updateInterval = const Duration(hours: 1);
    } else {
      updateInterval = const Duration(days: 1);
    }

    _timer = Timer(updateInterval, () {
      _updateTimeAgo();
      _scheduleNextUpdate();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
