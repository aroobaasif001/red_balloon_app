import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/model/offer_model.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/model/user_model.dart'; // 🔥 Import UserModel
import 'package:red_balloon_app/services/offer_service.dart';
import 'package:red_balloon_app/services/offer_service2.dart';
import 'package:red_balloon_app/services/user_service.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/profile/tabs/chat_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/profile/tabs/controller/chat_controller.dart';

import '../../../../../../../utils/dialog_helpers.dart';
import '../widgets/providercard.dart';
import 'user_profile_screen.dart'; // 🔥 Import profile screen

class TaskDetails2Screen extends StatefulWidget {
  final TaskModel task; // 🔥 Accept task data

  const TaskDetails2Screen({
    super.key,
    required this.task, // 🔥 Required parameter
  });

  @override
  State<TaskDetails2Screen> createState() => _TaskDetails2ScreenState();
}

class _TaskDetails2ScreenState extends State<TaskDetails2Screen> {
  final OfferService _offerService = OfferService();
  final OfferService2 _offerService2 = OfferService2();
  final UserService _userService = UserService(); // 🔥 Add UserService
  List<OfferModel> offers = [];
  Map<String, UserModel?> offerUsers = {}; // 🔥 Cache for user data
  bool isLoading = true;
  StreamSubscription? _offersSubscription;

  @override
  void initState() {
    super.initState();
    _setupRealtimeOffers();
  }

  void _setupRealtimeOffers() {
    if (!mounted) return;

    setState(() => isLoading = true);
    print(
      '🔍 TaskDetails2Screen: Setting up real-time offers for Task ID: ${widget.task.id}',
    );

    _offersSubscription = _offerService2
        .streamTaskOffers(widget.task.id ?? '')
        .listen(
          (offersData) async {
            if (!mounted) return;

            try {
              final fetchedOffers = offersData
                  .map(
                    (data) => OfferModel.fromJson(data, data['offerId'] ?? ''),
                  )
                  .toList();

              // 🔥 Pre-fetch user data for each offer
              Map<String, UserModel?> usersMap = {};
              for (var offer in fetchedOffers) {
                if (!usersMap.containsKey(offer.offeringUserUid)) {
                  final user = await _userService.getUserByUid(
                    offer.offeringUserUid,
                  );
                  usersMap[offer.offeringUserUid] = user;
                }
              }

              if (!mounted) return;

              setState(() {
                offers = fetchedOffers;
                offerUsers = usersMap;
                isLoading = false;
              });

              print(
                '✅ Real-time offers updated: ${fetchedOffers.length} offers',
              );
            } catch (e) {
              print("Error processing real-time offers: $e");
              if (mounted) {
                setState(() => isLoading = false);
              }
            }
          },
          onError: (error) {
            print("❌ Error in real-time offers stream: $error");
            if (mounted) {
              setState(() => isLoading = false);
            }
          },
        );
  }

  @override
  void dispose() {
    _offersSubscription?.cancel();
    super.dispose();
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Helper to check if image is network or asset
    final bool isNetworkImage =
        widget.task.imageUrl != null && widget.task.imageUrl!.isNotEmpty;
    final String displayImage = isNetworkImage
        ? widget.task.imageUrl!
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

              /// ===========================
              /// TOP TASK SUMMARY CARD
              /// ===========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomContainer(
                  conColor: white2Color,
                  borderRadius: BorderRadius.circular(18),
                  padding: const EdgeInsets.all(14),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.20),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: isNetworkImage
                            ? Image.network(
                                displayImage,
                                height: 70,
                                width: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/sofa.png",
                                    height: 70,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                displayImage,
                                height: 70,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              widget.task.title, // 🔥 Real title
                              fontSize: 18,
                              fontWeight: FontVariant.bold,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                CustomText(
                                  "${widget.task.budget.toStringAsFixed(0)} SAR", // 🔥 Real budget
                                  fontSize: 16,
                                  fontWeight: FontVariant.bold,
                                  color: redColor,
                                ),
                                const SizedBox(width: 14),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 15,
                                      color: walletGrey600Color,
                                    ),
                                    const SizedBox(width: 5),
                                    CustomText(
                                      _getTimeAgo(
                                        widget.task.createdAt,
                                      ), // 🔥 Real time
                                      fontSize: 13,
                                      color: walletGrey600Color,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// ===========================
              /// PROVIDER LIST CARDS
              /// ===========================
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (offers.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined, size: 60, color: rbnewcolor),
                        const SizedBox(height: 15),
                        CustomText(
                          'No offers yet',
                          fontSize: 18,
                          fontWeight: FontVariant.bold,
                          color: grey6Color!,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          'Offers from helpers will appear here',
                          fontSize: 14,
                          color: taskstatus3!,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...offers.map((offer) {
                  // 🔥 Get pre-fetched user
                  final user = offerUsers[offer.offeringUserUid];

                  // Get first letter of name for initials
                  final initials = offer.offeringUserName.isNotEmpty
                      ? offer.offeringUserName[0].toUpperCase()
                      : 'U';

                  return ProviderCard(
                    userPhoto:
                        user?.photoURL ??
                        displayImage, // 🔥 Use user photo if available
                    initials: initials,
                    name: offer.offeringUserName,
                    id: user!.userId ?? '',

                    rating: "4.9",
                    description: "(25 Tasks Completed)",
                    price: "SAR ${offer.offerPrice}",
                    distance: "34.5 km away",
                    onViewProfile: () async {
                      if (user != null) {
                        try {
                          final stats = await _userService.getUserStatistics(
                            offer.offeringUserUid,
                          );

                          Get.to(
                            () => UserProfileScreen(
                              userName: user.displayName,
                              userInitials: user.initials,
                              userPhoto: user.photoURL,
                              userId: user.userId,
                              userUid: user.uid,
                              rating: (stats['rating'] ?? 4.9).toDouble(),
                              tasksCompleted: stats['tasksCompleted'] ?? 0,
                              tasksRequested: stats['tasksRequested'] ?? 0,
                            ),
                          );
                        } catch (e) {
                          print('Error loading user profile stats: $e');
                        }
                      }
                    },
                    onAccept: () {
                      DialogHelpers.showOfferConfirmationDialog(
                        context: context,
                        offerId: offer.offerId,
                        taskId: widget.task.id ?? '',
                        onAccepted: () {
                          // Real-time listener will automatically update offers
                        },
                      );
                    },
                    onChat: () {
                      Get.to(
                        () => const ChatScreen(),
                        binding: BindingsBuilder(() {
                          Get.put(
                            ChatController(
                              taskId: widget.task.id ?? '',
                              taskTitle: widget.task.title,
                              taskOwnerId: offer.offeringUserUid,
                              taskOwnerName: offer.offeringUserName,
                              taskOwnerPhoto: user?.photoURL,
                              taskImage: widget.task.imageUrl,
                            ),
                          );
                        }),
                      );
                    },
                  );
                }).toList(),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
