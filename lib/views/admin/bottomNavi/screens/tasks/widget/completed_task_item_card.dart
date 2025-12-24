import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../user/bottomNavi/screens/task/my_task/tabs/task_completed_screen.dart';

class CompletedTaskItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String completedAgo;
  final String image;
  final String? taskId;

  const CompletedTaskItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.completedAgo,
    required this.image,
    this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      border: Border(
        bottom: BorderSide(color: bordercol, width: 1),
        right: BorderSide(color: bordercol, width: 1),
        left: BorderSide(color: bordercol, width: 1),
      ),
      conColor: whiteColor,
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.25),
          blurRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      price,
                      fontSize: 17,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      "Completed · $completedAgo",
                      fontSize: 14,
                      color: timeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CustomContainer(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: image.startsWith('http')
                      ? Image.network(
                          image,
                          width: 105,
                          height: 105,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            "assets/images/Rectangle 34625307.png",
                            width: 105,
                            height: 105,
                            fit: BoxFit.cover,
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 105,
                              height: 105,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: redColor,
                                ),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          image.isNotEmpty ? image : "assets/images/Rectangle 34625307.png",
                          width: 105,
                          height: 105,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            "assets/images/Rectangle 34625307.png",
                            width: 105,
                            height: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: CustomButton(
              label: "Task Completed",
              textColor: whiteColor,
              fontSize: 16,
              borderRadius: BorderRadius.circular(10),
              onPressed: () async {
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
                      final userDoc = await firestore.collection('users').doc(helperUid).get();
                      if (userDoc.exists) {
                        final uData = userDoc.data()!;
                        otherUserData = {
                          'name': uData['displayName'] ?? uData['name'] ?? uData['username'] ?? 'User',
                          'photoUrl': uData['photoURL'] ?? uData['profileImage'] ?? uData['profilePicture'] ?? '',
                          'userId': uData['userId'] ?? 'RB-0000',
                          'rating': uData['rating'] ?? 5.0,
                          'tasksCompleted': uData['completedTasks'] ?? 0,
                        };
                      }
                    }

                    // Close loading dialog
                    Get.back();

                    // Navigate to TaskCompletedScreen
                    Get.to(() => TaskCompletedScreen(
                          taskId: taskId!,
                          taskData: taskData,
                          isRequester: true, //perspective doesn't matter much for admin view
                          otherUserData: otherUserData,
                          validationInfo: validationInfo,
                        ));
                  } catch (e) {
                    Get.back();
                    print('Error navigating to TaskCompletedScreen: $e');
                    Get.snackbar("Error", "Failed to load task details");
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
