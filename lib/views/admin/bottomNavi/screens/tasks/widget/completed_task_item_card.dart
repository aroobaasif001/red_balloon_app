import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:intl/intl.dart';

import '../../../../../user/bottomNavi/screens/task/my_task/tabs/task_completed_screen.dart';

class CompletedTaskItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String location;
  final String dateTime;
  final String? taskId;

  const CompletedTaskItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.dateTime,
    this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(15),
      border: Border(
        bottom: BorderSide(color: bordercol, width: 1),
        right: BorderSide(color: bordercol, width: 1),
        left: BorderSide(color: bordercol, width: 1),
      ),
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

          // Amount and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                price,
                fontSize: 18,
                fontWeight: FontVariant.bold,
                color: blackColor,
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: historyGreenColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  "Completed",
                  fontSize: 14,
                  fontWeight: FontVariant.medium,
                  color: historyGreenColor,
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
                    CustomText(
                      location.isEmpty ? "No location" : location,
                      fontSize: 14,
                      fontWeight: FontVariant.regular,
                      color: grey6Color,
                    ),
                    const SizedBox(height: 8),
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
                onTap: () => _handleOnTap(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      'View Details',
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      color: redColor,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: redColor,
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

  Future<void> _handleOnTap(BuildContext context) async {
    if (taskId != null) {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: redColor)),
        barrierDismissible: false,
      );

      try {
        final firestore = FirebaseFirestore.instance;

        // 1. Fetch Task Document
        final taskDoc = await firestore.collection('tasks').doc(taskId).get();
        if (!taskDoc.exists) {
          Get.back();
          Get.snackbar("Error", "Task data not found");
          return;
        }
        final taskData = taskDoc.data()!;

        // 2. Fetch Validation Info
        final validationQuery = await firestore
            .collection('validations')
            .where('taskId', isEqualTo: taskId)
            .limit(1)
            .get();

        Map<String, dynamic> validationInfo = {};
        if (validationQuery.docs.isNotEmpty) {
          validationInfo = validationQuery.docs.first.data();
        } else {
          // Try fetching from task_proofs as fallback
          final proofQuery = await firestore
              .collection('task_proofs')
              .where('taskId', isEqualTo: taskId)
              .limit(1)
              .get();
          if (proofQuery.docs.isNotEmpty) {
            validationInfo = proofQuery.docs.first.data();
          }
        }

        // 3. Fetch Helper/Other User Data
        String helperUid = taskData['acceptedOfferUid'] ?? '';
        Map<String, dynamic> otherUserData = {
          'name': 'Unknown User',
          'photoUrl': '',
          'userId': 'RB-0000',
        };

        if (helperUid.isNotEmpty) {
          final userDoc =
              await firestore.collection('users').doc(helperUid).get();
          if (userDoc.exists) {
            final uData = userDoc.data()!;
            otherUserData = {
              'name': uData['displayName'] ??
                  uData['name'] ??
                  uData['username'] ??
                  'User',
              'photoUrl': uData['photoURL'] ??
                  uData['profileImage'] ??
                  uData['profilePicture'] ??
                  '',
              'userId': uData['userId'] ?? 'RB-0000',
              'rating': uData['rating'] ?? 5.0,
              'tasksCompleted': uData['completedTasks'] ?? 0,
            };
          }
        }

        // Close loading dialog
        if (Get.isDialogOpen ?? false) Get.back();

        // Navigate to TaskCompletedScreen
        Get.to(() => TaskCompletedScreen(
              taskId: taskId!,
              taskData: taskData,
              isRequester: true, 
              otherUserData: otherUserData,
              validationInfo: validationInfo,
            ));
      } catch (e) {
        if (Get.isDialogOpen ?? false) Get.back();
        print('Error navigating to TaskCompletedScreen: $e');
        Get.snackbar("Error", "Failed to load task details");
      }
    }
  }
}
