import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details2_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel? task; // 🔥 Made optional

  const TaskDetailsScreen({
    super.key,
    this.task, // 🔥 Optional parameter
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  StreamSubscription? _taskSubscription;

  @override
  void initState() {
    super.initState();
    _setupTaskListener();
  }

  void _setupTaskListener() {
    if (widget.task?.id == null || widget.task!.id!.isEmpty) return;

    _taskSubscription = FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.task!.id)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            final status = data?['status']?.toString().toLowerCase();

            // If task is no longer active (e.g., accepted and moved to in progress)
            if (status != null && status != 'active') {
              print(
                '🚀 TaskDetails: Status changed to $status. Navigating back...',
              );
              if (mounted) {
                Get.back();
              }
            }
          }
        });
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use provided task or create dummy fallback
    final TaskModel displayTask =
        widget.task ??
        TaskModel(
          id: 'dummy',
          uid: 'dummy',
          taskType: 'Offline Task',
          title: 'Help Move Furniture',
          description:
              'Need help moving furniture from my apartment to a new location. Items include a sofa, dining table, and several boxes. Helper should have a truck or van. Estimated time: 2-3 hours.',
          budget: 500,
          location: 'Riyadh, King Fahd Road',
          imageUrl: null,
          createdAt: DateTime.now(),
          status: 'active',
        );

    // Helper to check if image is network or asset
    final bool isNetworkImage =
        displayTask.imageUrl != null && displayTask.imageUrl!.isNotEmpty;
    final String displayImage = isNetworkImage
        ? displayTask.imageUrl!
        : "assets/images/sofa.png";

    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar1(title: 'Task Details', showRightImage: false),

              const SizedBox(height: 20),

              /// -----------------------
              /// TASK IMAGE
              /// -----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  "Task Image",
                  fontSize: 24,
                  fontWeight: FontVariant.bold,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    if (isNetworkImage) {
                      _showImageFullscreen(context, displayImage);
                    }
                  },
                  child: CustomContainer(
                    borderRadius: BorderRadius.circular(14),
                    conColor: whiteColor,
                    height: 150,
                    width: double.infinity,
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.40),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: isNetworkImage
                          ? Image.network(
                              displayImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to asset image if network image fails
                                return Image.asset(
                                  "assets/images/sofa.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(displayImage, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              /// -----------------------
              /// MAIN CARD SECTION
              /// -----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomContainer(
                  conColor: whiteColor,
                  borderRadius: BorderRadius.circular(14),
                  padding: const EdgeInsets.all(18),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.20),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      CustomText(
                        displayTask.title, // 🔥 Real title
                        fontSize: 20,
                        fontWeight: FontVariant.bold,
                      ),
                      const SizedBox(height: 12),

                      /// PRICE + TAG
                      Row(
                        children: [
                          CustomText(
                            "SAR ${displayTask.budget.toStringAsFixed(0)}", // 🔥 Real budget
                            fontSize: 28,
                            fontWeight: FontVariant.bold,
                            color: redColor,
                          ),
                          Spacer(),
                          // Commented out task type badge as per original code
                        ],
                      ),
                      const SizedBox(height: 25),

                      /// DESCRIPTION LABEL
                      CustomText(
                        "DESCRIPTION",
                        fontSize: 15,
                        fontWeight: FontVariant.regular,
                        color: walletTextGreyColor,
                      ),
                      const SizedBox(height: 10),

                      /// DESCRIPTION TEXT
                      CustomText(
                        displayTask.description, // 🔥 Real description
                        fontSize: 13,
                        color: blackLightColor,
                      ),

                      // 🔥 Only show location section if NOT Online Task
                      if (displayTask.taskType != 'Online Task') ...[
                        const SizedBox(height: 25),

                        /// LOCATION NEARBY LABEL
                        CustomText(
                          "LOCATION NEAR BY",
                          fontSize: 14,
                          fontWeight: FontVariant.regular,
                          color: walletTextGreyColor,
                        ),
                        const SizedBox(height: 10),

                        /// MAP CARD
                        CustomContainer(
                          height: 150,
                          conColor: mapBgColor,
                          borderRadius: BorderRadius.circular(22),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 1),

                              /// 📍 Center Pin (Emoji Style)
                              Image(
                                image: AssetImage('assets/icons/map-pin1.png'),
                                height: 40,
                                width: 40,
                              ),

                              /// White Input Box
                              CustomContainer(
                                conColor: whiteColor,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(16),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: CustomText(
                                  displayTask.location ??
                                      "Location not specified", // 🔥 Real location
                                  fontSize: 13,
                                  fontWeight: FontVariant.regular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              /// VIEW OFFERS BUTTON
              Center(
                child: CustomButton(
                  width: 263,
                  label: 'View Offers',
                  onPressed: () {
                    Get.to(
                      () => TaskDetails2Screen(task: displayTask),
                    ); // 🔥 Pass task object
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageFullscreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: blackColor,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(redColor),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/homedetail.png",
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: blackLightColor,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.close, color: whiteColor, size: 28),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
