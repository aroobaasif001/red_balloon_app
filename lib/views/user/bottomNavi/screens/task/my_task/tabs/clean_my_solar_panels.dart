import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../services/offer_service2.dart';
import '../../../../../../../services/user_service.dart';
import '../../../../../../../utils/colors.dart';
import '../../../../../../../utils/dialog_helpers.dart';
import '../../../profile/tabs/chat_screen.dart';
import '../../../profile/tabs/controller/chat_controller.dart';
import '../controller/task_detail_controller.dart';
import '../widgets/offer_card.dart';
import '../widgets/task_info_top_row.dart';
import '../widgets/task_owner_tile.dart';
import 'in_progress_view_details.dart';
import 'task_location_display_screen.dart';

class Cleanmysolarpanels extends StatefulWidget {
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
  final String? taskOwnerAuthId; // New field for robust Auth UID
  final double? latitude;
  final double? longitude;

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
    this.taskOwnerAuthId,
    this.latitude,
    this.longitude,
  });

  @override
  State<Cleanmysolarpanels> createState() => _CleanmysolarpanelsState();
}

class _CleanmysolarpanelsState extends State<Cleanmysolarpanels> {
  final controller = Get.put(TaskDetailController());
  StreamSubscription? _taskStatusListener;
  String? _dynamicDistance;

  Future<void> _calculateLiveDistance() async {
    if (widget.taskType == 'Online Task') return;
    if (widget.latitude != null &&
        widget.longitude != null &&
        widget.latitude != 0.0) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        final distMeters = Geolocator.distanceBetween(
          widget.latitude!,
          widget.longitude!,
          position.latitude,
          position.longitude,
        );
        if (mounted) {
          setState(() {
            _dynamicDistance = (distMeters / 1000).toStringAsFixed(1);
          });
        }
      } catch (e) {
        debugPrint('⚠️ Error calculating distance: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Setup listener for task status changes
    if (widget.taskId != null && widget.taskId!.isNotEmpty) {
      _setupTaskStatusListener(widget.taskId!);
    }

    // 🔥 Calculate live distance
    _calculateLiveDistance();

    // 🔥 Fetch real owner data
    if (widget.taskOwnerAuthId != null && widget.taskOwnerAuthId!.isNotEmpty) {
      controller.fetchOwnerData(widget.taskOwnerAuthId!);
    }
  }

  void _setupTaskStatusListener(String taskId) {
    _taskStatusListener = FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.exists) {
            final data = snapshot.data();
            final status = data?['status']?.toString().toLowerCase() ?? '';

            // If status changed to "accepted" or "in_progress", navigate to InProgressViewDetails
            if (status == 'accepted' || status == 'in_progress') {
              print(
                '✅ Task status changed to: $status - Navigating to InProgressViewDetails',
              );

              if (mounted) {
                // Extract all necessary data from the task
                final taskTitle = data?['title'] ?? widget.taskTitle ?? '';
                final taskPrice =
                    data?['budget']?.toString() ?? widget.taskPrice ?? '0';
                final taskTimeAgo = widget.taskTimeAgo ?? '';
                final taskLocation = data?['location'] ?? widget.location ?? '';
                final taskImage = data?['imageUrl'] ?? widget.taskImage ?? '';
                final taskType = data?['taskType'] ?? widget.taskType ?? '';
                final latitude =
                    data?['latitude']?.toDouble() ?? widget.latitude ?? 0.0;
                final longitude =
                    data?['longitude']?.toDouble() ?? widget.longitude ?? 0.0;
                final acceptedOfferUid = data?['acceptedOfferUid'] ?? '';
                final phoneNumber = data?['phoneNumber'] ?? '';

                // 🔥 Calculate Distance
                String? distanceString;
                if (taskType != 'Online Task' &&
                    latitude != 0.0 &&
                    longitude != 0.0) {
                  try {
                    final position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.medium,
                    );
                    final distMeters = Geolocator.distanceBetween(
                      latitude,
                      longitude,
                      position.latitude,
                      position.longitude,
                    );
                    distanceString =
                        "${(distMeters / 1000).toStringAsFixed(1)} km away";
                  } catch (e) {
                    print('⚠️ Could not fetch location for distance calc: $e');
                  }
                }
                Get.back();
                // Navigate to InProgressViewDetails with full data
                Get.to(
                  () => InProgressViewDetails(
                    taskId: taskId,
                    taskTitle: taskTitle,
                    price: taskPrice,
                    timeAgo: taskTimeAgo,
                    location: taskLocation,
                    taskImage: taskImage,
                    taskType: taskType,
                    latitude: latitude,
                    longitude: longitude,
                    helperUid: acceptedOfferUid,
                    phoneNumber: phoneNumber,
                    userName: widget.userName,
                    photoUrl: widget.userPhoto,
                    userId: widget.userId,
                    distance: distanceString,
                  ),
                );
              }
            } else if (status.isNotEmpty && status != 'active') {
              // For other status changes (cancelled, etc), just navigate back
              print('✅ Task status changed to: $status');
              if (mounted) {
                // Extract all necessary data from the task
                final taskTitle = data?['title'] ?? widget.taskTitle ?? '';
                final taskPrice =
                    data?['budget']?.toString() ?? widget.taskPrice ?? '0';
                final taskTimeAgo = widget.taskTimeAgo ?? '';
                final taskLocation = data?['location'] ?? widget.location ?? '';
                final taskImage = data?['imageUrl'] ?? widget.taskImage ?? '';
                final taskType = data?['taskType'] ?? widget.taskType ?? '';
                final latitude =
                    data?['latitude']?.toDouble() ?? widget.latitude ?? 0.0;
                final longitude =
                    data?['longitude']?.toDouble() ?? widget.longitude ?? 0.0;
                final acceptedOfferUid = data?['acceptedOfferUid'] ?? '';
                final phoneNumber = data?['phoneNumber'] ?? '';

                // 🔥 Calculate Distance
                String? distanceString;
                if (taskType != 'Online Task' &&
                    latitude != 0.0 &&
                    longitude != 0.0) {
                  try {
                    final position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.medium,
                    );
                    final distMeters = Geolocator.distanceBetween(
                      latitude,
                      longitude,
                      position.latitude,
                      position.longitude,
                    );
                    distanceString =
                        "${(distMeters / 1000).toStringAsFixed(1)} km away";
                  } catch (e) {
                    print('⚠️ Could not fetch location for distance calc: $e');
                  }
                }
                Get.back();
                // Navigate to InProgressViewDetails with full data
                Get.to(
                  () => InProgressViewDetails(
                    taskId: taskId,
                    taskTitle: taskTitle,
                    price: taskPrice,
                    timeAgo: taskTimeAgo,
                    location: taskLocation,
                    taskImage: taskImage,
                    taskType: taskType,
                    latitude: latitude,
                    longitude: longitude,
                    helperUid: acceptedOfferUid,
                    phoneNumber: phoneNumber,
                    userName: widget.userName,
                    photoUrl: widget.userPhoto,
                    userId: widget.userId,
                    distance: distanceString,
                  ),
                );
              }
            }
          }
        });
  }

  @override
  void dispose() {
    _taskStatusListener?.cancel();
    super.dispose();
  }

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
                      titleText: widget.taskTitle ?? "Clean my Solar Panels",
                      // titleFontSize: 16,
                      // titleFontWeight: FontVariant.semiBold,
                    ),

                    const SizedBox(height: 20),

                    Divider(color: bordercolor1, thickness: 1.5, height: 1),

                    const SizedBox(height: 20),

                    TaskInfoTopRow(
                      price: widget.taskPrice,
                      timeAgo: widget.taskTimeAgo,
                      taskId:
                          widget.userId ??
                          'task_${widget.taskTimeAgo ?? 'default'}',
                      isOnline: widget.taskType == 'Online Task',
                      distance: _dynamicDistance,
                    ),
                    const SizedBox(height: 15),

                    Divider(color: bordercolor1, thickness: 1.5, height: 1),
                    const SizedBox(height: 12),

                    Obx(
                      () => TaskOwnerTile(
                        name: controller.ownerName.value.isEmpty
                            ? widget.userName
                            : controller.ownerName.value,
                        photoUrl: controller.ownerPhotoUrl.value.isEmpty
                            ? widget.userPhoto
                            : controller.ownerPhotoUrl.value,
                        id: controller.ownerUserId.value.isEmpty
                            ? widget.userId
                            : controller.ownerUserId.value,
                        authUid: widget.taskOwnerAuthId,
                        rating: controller.ownerRating.value,
                        tasksCompleted: controller.ownerTasksCompleted.value,
                        tasksRequested: controller.ownerTasksRequested.value,
                      ),
                    ),

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
                      widget.taskDescription == null
                          ? "Need help cleaning my solar panels. Roof access available. "
                                "Should take around 30–40 minutes."
                          : widget.taskDescription!,
                      fontSize: 14,
                      color: rbtxColor,
                      fontWeight: FontVariant.regular,
                    ),
                    const SizedBox(height: 20),

                    /// Images
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.taskImage != null &&
                                  widget.taskImage!.isNotEmpty) {
                                _showImageFullscreen(
                                  context,
                                  widget.taskImage!,
                                );
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  widget.taskImage != null &&
                                      widget.taskImage!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: widget.taskImage!,
                                      height: 160,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        height: 160,
                                        color: bordercolor1,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  redColor,
                                                ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            "assets/images/homedetail.png",
                                            height: 160,
                                            fit: BoxFit.cover,
                                          ),
                                    )
                                  : Image.asset(
                                      "assets/images/homedetail.png",
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (widget.taskType != 'Online Task')
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (widget.latitude != null &&
                                    widget.longitude != null) {
                                  Get.to(
                                    () => TaskLocationDisplayScreen(
                                      latitude: widget.latitude!,
                                      longitude: widget.longitude!,
                                      title:
                                          widget.taskTitle ?? "Task Location",
                                      address: widget.location ?? "",
                                      showDirections:
                                          false, // 🔥 Hide for helper
                                    ),
                                  );
                                } else {
                                  Get.snackbar(
                                    "Info",
                                    "Location coordinates not available",
                                  );
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    (widget.latitude != null &&
                                        widget.longitude != null &&
                                        widget.latitude != 0.0 &&
                                        widget.longitude != 0.0)
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "https://maps.googleapis.com/maps/api/staticmap?center=${widget.latitude},${widget.longitude}&zoom=14&size=400x400&markers=color:red%7C${widget.latitude},${widget.longitude}&key=AIzaSyCOMKFm2vVK0w3FRoUWJvv6wv1NvD_s60k",
                                        height: 160,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          height: 160,
                                          color: bordercolor1,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    redColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                              "assets/images/map.png",
                                              height: 160,
                                              fit: BoxFit.cover,
                                            ),
                                      )
                                    : Image.asset(
                                        "assets/images/map.png",
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
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
                  taskId: widget.taskId,
                  taskTitle: widget.taskTitle,
                  taskDescription: widget.taskDescription,
                  taskTimeAgo: widget.taskTimeAgo,
                  taskType: widget.taskType,
                  taskImage: widget.taskImage,
                  location: widget.location,
                  taskOwnerUid:
                      widget.taskOwnerAuthId ??
                      widget.userId, // Prefer AuthUID for functional logic
                  taskOwnerName: widget.userName,
                  taskOwnerPhoto: widget.userPhoto,
                  taskBudget: widget.taskBudget,
                ),
              ),
            ),
          ],
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
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(redColor),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/homedetail.png",
                    fit: BoxFit.contain,
                  ),
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

  /// Build real-time offers section
  Widget _buildOffersSection() {
    if (widget.taskId == null) {
      return const CustomText(
        'No offers available',
        fontSize: 14,
        color: taskstatus3,
      );
    }

    // Initialize the controller
    final offersController = Get.put(
      TaskOffersController(taskId: widget.taskId!),
      tag: widget.taskId,
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
          color: taskstatus3,
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: offersController.offers.map((offer) {
          return _OfferCardWithTimer(
            offerData: offer,
            key: ValueKey(offer['offerId']),
            userId: widget.userId ?? '',
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
  final RxMap<String, Map<String, dynamic>> offerUserStats =
      <String, Map<String, dynamic>>{}.obs; // 🔥 Store real ratings
  final UserService _userService = UserService();

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
          (newOffers) async {
            // 🔥 Fetch stats for each NEW user we haven't seen yet
            for (var offer in newOffers) {
              final uid = offer['offeringUserUid'];
              if (uid != null && !offerUserStats.containsKey(uid)) {
                final stats = await _userService.getUserStatistics(uid);
                final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get();
                if (userDoc.exists) {
                  stats['customId'] = userDoc.data()?['userId'] ?? '';
                }
                offerUserStats[uid] = stats;
              }
            }

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
  final String userId;
  final Map<String, dynamic> offerData;

  const _OfferCardWithTimer({
    super.key,
    required this.offerData,
    required this.userId,
  });

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
    final offeringUserUid = offerData['offeringUserUid'];

    // Find the TaskOffersController to get pre-fetched stats
    final TaskOffersController? offersController =
        Get.isRegistered<TaskOffersController>(tag: offerData['taskId'])
        ? Get.find<TaskOffersController>(tag: offerData['taskId'])
        : null;

    return Obx(() {
      if (!controller.isVisible.value) {
        return const SizedBox.shrink();
      }

      // 🔥 Get real stats from controller if available
      double rating = 5.0;
      int completed = 0;
      int requested = 0;
      String customId = '';
      if (offersController != null && offeringUserUid != null) {
        final stats = offersController.offerUserStats[offeringUserUid];
        if (stats != null) {
          rating = (stats['rating'] ?? 5.0).toDouble();
          completed = stats['tasksCompleted'] ?? 0;
          requested = stats['tasksRequested'] ?? 0;
          customId = stats['customId'] ?? '';
        }
      }

      return OfferCard(
        name: userName,
        price: offerPrice,
        stars: rating.round(), // OfferCard uses int for stars
        rating: rating,
        tasksCompleted: completed,
        tasksRequested: requested,
        photoUrl: userPhoto,
        authUid: offeringUserUid,
        customId: customId,
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
            child: GestureDetector(
              onTap: () {
                if (taskId != null && taskOwnerUid != null) {
                  print(
                    "Navigating to ChatScreen with taskId: $taskId, ownerId: $taskOwnerUid",
                  );
                  Get.to(
                    () => const ChatScreen(),
                    binding: BindingsBuilder(() {
                      Get.put(
                        ChatController(
                          taskId: taskId!,
                          taskTitle: taskTitle ?? 'Clean my Solar Panels',
                          taskOwnerId: taskOwnerUid!,
                          taskOwnerName: taskOwnerName ?? 'User',
                          taskOwnerPhoto: taskOwnerPhoto,
                          taskImage: taskImage,
                        ),
                      );
                    }),
                  );
                } else {
                  print(
                    "Chat tap failed: taskId=$taskId, taskOwnerUid=$taskOwnerUid",
                  );
                  Get.snackbar(
                    "Error",
                    "Cannot start chat: Missing task details",
                  );
                }
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
                  color: isButtonDisabled ? rbnewcolor : pricecolor,
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
            child: GestureDetector(
              onTap: () {
                if (taskId != null && taskOwnerUid != null) {
                  print(
                    "Navigating to ChatScreen with taskId: $taskId, ownerId: $taskOwnerUid",
                  );
                  Get.to(
                    () => const ChatScreen(),
                    binding: BindingsBuilder(() {
                      Get.put(
                        ChatController(
                          taskId: taskId!,
                          taskTitle: taskTitle ?? 'Clean my Solar Panels',
                          taskOwnerId: taskOwnerUid!,
                          taskOwnerName: taskOwnerName ?? 'User',
                          taskOwnerPhoto: taskOwnerPhoto,
                          taskImage: taskImage,
                        ),
                      );
                    }),
                  );
                } else {
                  print(
                    "Chat tap failed: taskId=$taskId, taskOwnerUid=$taskOwnerUid",
                  );
                  Get.snackbar(
                    "Error",
                    "Cannot start chat: Missing task details",
                  );
                }
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
