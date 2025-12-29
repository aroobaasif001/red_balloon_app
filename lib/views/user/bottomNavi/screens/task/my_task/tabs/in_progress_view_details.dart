import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../controller/in_progress_task_controller.dart';
import '../widgets/build_bottom_upload_bar.dart';
import '../widgets/build_helper_info_card.dart';
import '../widgets/build_route_card.dart';
import '../widgets/build_status_card.dart';
import '../widgets/build_task_summary_card.dart';

class InProgressViewDetails extends StatelessWidget {
  final String? taskId;
  final String? taskTitle;
  final String? price;
  final String? timeAgo;
  final String? userName;
  final String? photoUrl;
  final String? location;
  final String? userId;
  final String? phoneNumber;
  final String? helperUid;
  final String? taskImage;
  final double? latitude;
  final double? longitude;

  const InProgressViewDetails({
    super.key,
    this.taskId,
    this.userName,
    this.photoUrl,
    this.timeAgo,
    this.price,
    this.taskTitle,
    this.location,
    this.userId,
    this.phoneNumber,
    this.helperUid,
    this.taskImage,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final InProgressTaskController controller = Get.put(
      InProgressTaskController(),
    );

    // Check if proof exists and start listening for task updates
    if (taskId != null && taskId!.isNotEmpty) {
      controller.currentTaskTitle = taskTitle; // 🔥 Store for notification
      controller.taskOwnerId = helperUid;      // 🔥 Store for notification
      controller.checkProofExists(taskId!);
      controller.startTaskListener(taskId!);
      controller.startStatusListener(taskId!);

      // 🔥 Fetch helper details if helperUid is present
      if (helperUid != null && helperUid!.isNotEmpty) {
        controller.fetchUserData(helperUid!);
      }
      
      // 🔥 Fetch Accepted Offer Price
      controller.fetchAcceptedOfferPrice(taskId!);
    }

    // Debug: Log the helper UID being used
    print('🔍 InProgressViewDetails Debug:');
    print('   taskId: $taskId');
    print('   helperUid (Firebase Auth UID): $helperUid');
    print('   userId (custom ID): $userId');
    print('   Using for chat: $helperUid');

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: const CustomAppBar(titleText: 'Task Progress'),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    buildStatusCard(controller),
                    const SizedBox(height: 16),
                    buildRouteCard(
                      latitude: latitude,
                      longitude: longitude,
                      title: taskTitle,
                      address: location,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => buildTaskSummaryCard(
                      controller,
                      timeAgo!,
                      controller.acceptedOfferPrice.value.isNotEmpty 
                          ? controller.acceptedOfferPrice.value 
                          : price!,
                      userName,
                      taskTitle!, // Ensure taskTitle is not null or handled
                      location ?? '',
                      taskImage: taskImage,
                    )),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),
                    Obx(() => buildHelperInfoCard(
                      controller,
                      controller.helperPhotoUrl.value.isEmpty ? photoUrl : controller.helperPhotoUrl.value,
                      controller.helperName.value,
                      controller.helperUserId.value, 
                      helperUid: helperUid,
                      taskId: taskId,
                      taskTitle: taskTitle,
                      phoneNumber: phoneNumber,
                      taskImage: taskImage,
                    )),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            buildBottomUploadBar(
              context,
              controller,
              taskId: taskId,
              taskTitle: taskTitle,
              price: price,
              taskOwnerUid: helperUid, // 🔥 In this context, helperUid is the owner
            ),
          ],
        ),
      ),
    );
  }
}
