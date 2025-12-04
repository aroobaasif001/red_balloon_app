import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../services/offer_service2.dart';
import '../../../../../../../utils/colors.dart';
import '../../../../../../../utils/dialog_helpers.dart';
import '../../../profile/tabs/chat_screen.dart';
import '../controller/task_detail_controller.dart';
import '../widgets/offer_card.dart';
import '../widgets/task_info_top_row.dart';
import '../widgets/task_owner_tile.dart';

class Cleanmysolarpanels extends StatelessWidget {
  final String? appBarTitle;
  final String? taskType;
  final String? taskId; // Required for offer submission
  final String? location; // Distance/location info

  // Task details
  final String? taskTitle;
  final String? taskDescription;
  final String? taskPrice;
  final String? taskTimeAgo;
  final String? taskImage;
  final double? taskBudget; // Task budget for OfferModel

  // User details (task owner)
  final String? userId;
  final String? userName;
  final String? userPhoto;

  final controller = Get.put(TaskDetailController());

  Cleanmysolarpanels({
    super.key,
    this.taskType,
    this.appBarTitle,
    this.taskId,
    this.location,
    this.taskTitle,
    this.taskDescription,
    this.taskPrice,
    this.taskTimeAgo,
    this.taskImage,
    this.taskBudget,
    this.userId,
    this.userName,
    this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      titleText: taskTitle ?? "Clean my Solar Panels",
                      // titleFontSize: 16,
                      // titleFontWeight: FontVariant.semiBold,
                    ),

                    const SizedBox(height: 20),

                    Divider(color: bordercolor1, thickness: 1.5, height: 1),

                    const SizedBox(height: 20),

                    TaskInfoTopRow(
                      price: taskPrice,
                      timeAgo: taskTimeAgo,
                      taskId: userId ?? 'task_${taskTimeAgo ?? 'default'}',
                    ),
                    const SizedBox(height: 15),

                    Divider(color: bordercolor1, thickness: 1.5, height: 1),
                    const SizedBox(height: 12),

                    TaskOwnerTile(name: userName, photoUrl: userPhoto),

                    const SizedBox(height: 10),
                    Divider(color: bordercolor1, thickness: 1.5, height: 1),
                    const SizedBox(height: 10),

                    /// Description
                    const CustomText(
                      "Description",
                      fontSize: 14,
                      color: textcolord,
                      fontWeight: FontVariant.semiBold,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      taskDescription == null
                          ? "Need help cleaning my solar panels. Roof access available. "
                                "Should take around 30–40 minutes."
                          : taskDescription!,
                      fontSize: 14,
                      color: rbtxColor,
                      fontWeight: FontVariant.regular,
                    ),
                    const SizedBox(height: 20),

                    /// Images
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/homedetail.png",
                              height: 160,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/map.png",
                              height: 160,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          "Offers Received",
                          fontSize: 16,
                          fontWeight: FontVariant.semiBold,
                        ),
                        // CustomContainer(
                        //   height: 35,
                        //   conColor: bordercolor1,
                        //   borderRadius: BorderRadius.circular(15),
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: blackColor.withOpacity(0.25),
                        //       offset: Offset(0, 4),
                        //       blurRadius: 4,
                        //       spreadRadius: 0,
                        //     ),
                        //   ],
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Center(
                        //       child: CustomText(
                        //         taskType ?? '',
                        //         color: walletGrey600Color,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    /// Offers - Real-time from Firebase
                    _buildOffersSection(),

                    const SizedBox(
                      height: 20,
                    ), // Extra spacing before bottom buttons
                  ],
                ),
              ),
            ),

            // Fixed bottom buttons
            CustomContainer(
              height: 100,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
              conColor: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
              child: SafeArea(
                top: false,
                child: RefreshButtonWithData(
                  taskId: taskId,
                  taskTitle: taskTitle,
                  taskDescription: taskDescription,
                  taskTimeAgo: taskTimeAgo,
                  taskType: taskType,
                  taskImage: taskImage,
                  location: location,
                  taskOwnerUid: userId,
                  taskOwnerName: userName,
                  taskOwnerPhoto: userPhoto,
                  taskBudget: taskBudget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build real-time offers section
  Widget _buildOffersSection() {
    if (taskId == null) {
      return const CustomText(
        'No offers available',
        fontSize: 14,
        color: Colors.grey,
      );
    }

    // Initialize the controller
    final offersController = Get.put(
      TaskOffersController(taskId: taskId!),
      tag: taskId,
    );

    return Obx(() {
      if (offersController.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: redColor),
          ),
        );
      }

      if (offersController.offers.isEmpty) {
        return const CustomText(
          'No offers received yet',
          fontSize: 14,
          color: Colors.grey,
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: offersController.offers.map((offer) {
          return _OfferCardWithTimer(
            offerData: offer,
            key: ValueKey(offer['offerId']),
          );
        }).toList(),
      );
    });
  }
}

/// Controller to manage task offers and synchronization
class TaskOffersController extends GetxController {
  final String taskId;
  final RxList<Map<String, dynamic>> offers = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  // For button cooldown synchronization
  final RxBool isCooldownActive = false.obs;
  final RxInt cooldownSeconds = 0.obs;
  Timer? _cooldownTimer;

  StreamSubscription? _offersSubscription;
  final OfferService2 _offerService = OfferService2();

  TaskOffersController({required this.taskId});

  @override
  void onInit() {
    super.onInit();
    _subscribeToOffers();
  }

  void _subscribeToOffers() {
    isLoading.value = true;
    _offersSubscription = _offerService
        .streamTaskOffers(taskId)
        .listen(
          (newOffers) {
            offers.value = newOffers;
            isLoading.value = false;
            _checkMyLatestOffer();
          },
          onError: (error) {
            print("Error streaming offers: $error");
            isLoading.value = false;
          },
        );
  }

  void _checkMyLatestOffer() {
    final currentUserId = _offerService.currentUserId;
    if (currentUserId == null) return;

    // Find my latest offer
    Map<String, dynamic>? myLatestOffer;
    try {
      // Offers are already sorted by createdAt descending from the service
      myLatestOffer = offers.firstWhere(
        (offer) => offer['offeringUserUid'] == currentUserId,
      );
    } catch (_) {
      // No offer found from me
      myLatestOffer = null;
    }

    if (myLatestOffer != null) {
      _syncCooldownWithOffer(myLatestOffer);
    }
  }

  void _syncCooldownWithOffer(Map<String, dynamic> offer) {
    final Timestamp? createdAt = offer['createdAt'] as Timestamp?;
    if (createdAt == null) return;

    final now = DateTime.now();
    final created = createdAt.toDate();
    final difference = now.difference(created).inSeconds;
    final remaining = 15 - difference;

    // Cancel existing timer to avoid duplicates
    _cooldownTimer?.cancel();

    if (remaining > 0) {
      isCooldownActive.value = true;
      cooldownSeconds.value = remaining;

      _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        cooldownSeconds.value--;
        if (cooldownSeconds.value <= 0) {
          isCooldownActive.value = false;
          timer.cancel();
        }
      });
    } else {
      isCooldownActive.value = false;
      cooldownSeconds.value = 0;
    }
  }

  @override
  void onClose() {
    _offersSubscription?.cancel();
    _cooldownTimer?.cancel();
    super.onClose();
  }
}

/// Controller for offer card timer
class OfferTimerController extends GetxController {
  final RxBool isVisible = true.obs;
  final RxInt remainingSeconds = 15.obs;
  final Timestamp? createdAt;
  Timer? _countdownTimer;

  OfferTimerController({this.createdAt});

  @override
  void onInit() {
    super.onInit();
    _calculateRemainingTime();
    if (remainingSeconds.value > 0) {
      _startCountdownTimer();
    } else {
      isVisible.value = false;
    }
  }

  void _calculateRemainingTime() {
    if (createdAt == null) {
      // If no timestamp, assume new offer (fallback)
      remainingSeconds.value = 15;
      return;
    }

    final now = DateTime.now();
    final created = createdAt!.toDate();
    final difference = now.difference(created).inSeconds;
    final remaining = 15 - difference;

    if (remaining <= 0) {
      remainingSeconds.value = 0;
      isVisible.value = false;
    } else {
      remainingSeconds.value = remaining;
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds.value--;
      if (remainingSeconds.value <= 0) {
        isVisible.value = false;
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }
}

/// Offer card with 15-second auto-hide timer and countdown display
class _OfferCardWithTimer extends StatelessWidget {
  final Map<String, dynamic> offerData;

  const _OfferCardWithTimer({super.key, required this.offerData});

  @override
  Widget build(BuildContext context) {
    // Extract timestamp from offer data
    final Timestamp? createdAt = offerData['createdAt'] as Timestamp?;

    final controller = Get.put(
      OfferTimerController(createdAt: createdAt),
      tag: offerData['offerId']?.toString(),
    );

    final offerPrice = offerData['offerPrice']?.toString() ?? '0';
    final userName = offerData['offeringUserName'] ?? 'Unknown';
    final userPhoto = offerData['offeringUserPhoto'];

    return Obx(() {
      if (!controller.isVisible.value) {
        return const SizedBox.shrink();
      }

      return OfferCard(
        name: userName,
        price: offerPrice,
        stars: 5,
        ratingCount: 0,
        photoUrl: userPhoto,
        timerWidget: CustomText(
          '00:${controller.remainingSeconds.value.toString().padLeft(2, '0')}',
          fontSize: 12,
          color: walletInfoTextColor,
          fontWeight: FontVariant.regular,
        ),
      );
    });
  }
}

// Wrapper to pass data to RefreshButton -> DialogHelpers
class RefreshButtonWithData extends StatelessWidget {
  final String? taskId;
  final String? taskTitle;
  final String? taskDescription;
  final String? taskTimeAgo;
  final String? taskType;
  final String? taskImage;
  final String? location;
  final String? taskOwnerUid;
  final String? taskOwnerName;
  final String? taskOwnerPhoto;
  final double? taskBudget;

  RefreshButtonWithData({
    super.key,
    this.taskId,
    this.taskTitle,
    this.taskDescription,
    this.taskTimeAgo,
    this.taskType,
    this.taskImage,
    this.location,
    this.taskOwnerUid,
    this.taskOwnerName,
    this.taskOwnerPhoto,
    this.taskBudget,
  });

  @override
  Widget build(BuildContext context) {
    // Find the controller that was initialized in _buildOffersSection
    // We use the tag if taskId is available, otherwise we might need a fallback
    // But since this widget is used in the same screen where _buildOffersSection is called,
    // the controller should be available.

    TaskOffersController? controller;
    if (taskId != null && Get.isRegistered<TaskOffersController>(tag: taskId)) {
      controller = Get.find<TaskOffersController>(tag: taskId);
    }

    // If controller is not available, show a simple button without Obx
    if (controller == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Show the dialog
                DialogHelpers.showSendOfferBottomSheet(
                  context,
                  taskId: taskId,
                  taskTitle: taskTitle,
                  taskDescription: taskDescription,
                  taskTimeAgo: taskTimeAgo,
                  taskType: taskType,
                  taskImage: taskImage,
                  location: location,
                  taskOwnerUid: taskOwnerUid,
                  taskOwnerName: taskOwnerName,
                  taskOwnerPhoto: taskOwnerPhoto,
                  taskBudget: taskBudget,
                );
              },
              child: Container(
                height: 51,
                decoration: BoxDecoration(
                  color: pricecolor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: CustomText(
                    "Send Offer",
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontVariant.medium,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () {
                Get.to(() => ChatScreen());
              },
              child: Container(
                height: 51,
                decoration: BoxDecoration(
                  color: pricecolor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: pricecolor, width: 1),
                ),
                child: const Center(
                  child: CustomText(
                    "Chat",
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontVariant.medium,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Obx(() {
      final isButtonDisabled = controller!.isCooldownActive.value;
      final cooldownSeconds = controller!.cooldownSeconds.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: isButtonDisabled
                  ? null
                  : () {
                      // Show the dialog
                      DialogHelpers.showSendOfferBottomSheet(
                        context,
                        taskId: taskId,
                        taskTitle: taskTitle,
                        taskDescription: taskDescription,
                        taskTimeAgo: taskTimeAgo,
                        taskType: taskType,
                        taskImage: taskImage,
                        location: location,
                        taskOwnerUid: taskOwnerUid,
                        taskOwnerName: taskOwnerName,
                        taskOwnerPhoto: taskOwnerPhoto,
                        taskBudget: taskBudget,
                      );
                      // Cooldown is now handled automatically by the stream listener in the controller
                    },
              child: Container(
                height: 51,
                decoration: BoxDecoration(
                  color: isButtonDisabled ? Colors.grey.shade400 : pricecolor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: CustomText(
                    isButtonDisabled
                        ? "Wait $cooldownSeconds sec"
                        : "Send Offer",
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontVariant.medium,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () {
                Get.to(() => ChatScreen());
              },
              child: Container(
                height: 51,
                decoration: BoxDecoration(
                  color: pricecolor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: pricecolor, width: 1),
                ),
                child: const Center(
                  child: CustomText(
                    "Chat",
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontVariant.medium,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
