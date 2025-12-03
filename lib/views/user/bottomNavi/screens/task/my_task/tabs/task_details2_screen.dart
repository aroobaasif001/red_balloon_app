import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/model/offer_model.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/services/offer_service.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../../utils/dialog_helpers.dart';
import '../widgets/providercard.dart';

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
  List<OfferModel> offers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    setState(() => isLoading = true);
    print('🔍 TaskDetails2Screen: Fetching offers for Task ID: ${widget.task.id}');
    
    final fetchedOffers = await _offerService.getOffersForTask(widget.task.id ?? '');
    
    setState(() {
      offers = fetchedOffers;
      isLoading = false;
    });
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
    final bool isNetworkImage = widget.task.imageUrl != null && widget.task.imageUrl!.isNotEmpty;
    final String displayImage = isNetworkImage ? widget.task.imageUrl! : "assets/images/sofa.png";

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
                      color: Colors.black.withOpacity(0.20),
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
                                      _getTimeAgo(widget.task.createdAt), // 🔥 Real time
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
                        Icon(
                          Icons.inbox_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 15),
                        CustomText(
                          'No offers yet',
                          fontSize: 18,
                          fontWeight: FontVariant.bold,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          'Offers from helpers will appear here',
                          fontSize: 14,
                          color: Colors.grey[500]!,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...offers.map((offer) {
                  // Get first letter of name for initials
                  final initials = offer.offeringUserName.isNotEmpty
                      ? offer.offeringUserName[0].toUpperCase()
                      : 'U';

                  return ProviderCard(
                    initials: initials,
                    name: offer.offeringUserName, // 🔥 Real offering user name
                    id: "RB-452",
                    // id: offer.offerId, // 🔥 Real offer ID
                    rating: "4.9", // TODO: Add rating to offer model
                    description: "(25 Tasks Completed)", // TODO: Add task count
                    price: "SAR ${offer.offerPrice}", // 🔥 Real offer price
                    distance: "34.5 km away", // TODO: Calculate distance
                    onViewProfile: () {
                      DialogHelpers.showHelperProfileDialog(context);
                    },
                    onAccept: () {
                      DialogHelpers.showOfferAcceptedDialog(context: context);
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
