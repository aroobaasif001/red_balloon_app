import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../../services/offer_service2.dart';
import '../../../../../../../utils/dialog_helpers.dart';

class SendOfferBottomSheet extends StatefulWidget {
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
  final double? taskBudget; // Task budget for OfferModel

  const SendOfferBottomSheet({
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
  State<SendOfferBottomSheet> createState() => _SendOfferBottomSheetState();
}

class _SendOfferBottomSheetState extends State<SendOfferBottomSheet> {
  late TextEditingController _priceController;
  final OfferService2 _offerService = OfferService2();
  final AuthService _authService = AuthService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.taskBudget?.toInt().toString(),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: whiteColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ================= TITLE =================
            const CustomText(
              "Send an offer",
              fontSize: 20,
              fontWeight: FontVariant.bold,
              color: textcolord,
            ),

            const SizedBox(height: 24),

            // ================= PRICE DISPLAY =================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const CustomText(
                  "SAR",
                  fontSize: 28,
                  fontWeight: FontVariant.semiBold,
                  color: grayColor,
                ),
                const SizedBox(width: 7),
                CustomContainer(
                  conColor: blackColor,
                  width: 1,
                  height: 30,
                  margin: EdgeInsets.only(top: 10),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            // ================= DIVIDER =================
            Container(
              height: 1,
              color: blackColor,
              margin: const EdgeInsets.symmetric(vertical: 12),
            ),

            const SizedBox(height: 5),

            // ================= INFO TEXT =================
            CustomText(
              "Your offer must be reasonable. Very low or very high offers reduce acceptance chance.",
              fontSize: 12,
              color: blackColor.withOpacity(0.35),
              fontWeight: FontVariant.regular,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            CustomButton(
              label: _isSubmitting ? 'Submitting...' : 'Place Your Offer',
              onPressed: _isSubmitting ? null : _submitOffer,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _submitOffer() async {
    // // Validate task data
    // if (widget.taskId == null || widget.taskOwnerUid == null) {
    //   Get.snackbar(
    //     'Error',
    //     'Missing task information',
    //   );
    //   return;
    // }

    // Validate price input
    final priceText = _priceController.text.trim();
    if (priceText.isEmpty) {
      Get.snackbar('Error', 'Please enter your offer price');
      return;
    }

    final offerPrice = int.tryParse(priceText);
    if (offerPrice == null || offerPrice <= 0) {
      Get.snackbar('Error', 'Please enter a valid price (integers only)');
      return;
    }

    // Validation: 30% limit check (Minimum 70% of budget)
    final double budget = widget.taskBudget ?? 0.0;
    if (budget > 0) {
      final double minLimit = budget * 0.7; // 70% of budget (30% less)
      final double maxLimit = budget * 3.0; // 3 times the budget

      if (offerPrice < minLimit) {
        Get.snackbar(
          'Invalid Offer',
          'Offer cannot be less than SAR ${minLimit.toInt()} (70% of budget)',
        );
        return;
      }

      if (offerPrice > maxLimit) {
        Get.snackbar(
          'Invalid Offer',
          'Offer cannot be more than SAR ${maxLimit.toInt()} (3x of budget)',
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      // Get current user data
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'You must be logged in to submit an offer');
        setState(() => _isSubmitting = false);
        return;
      }

      final userData = await _authService.getUserData(currentUser.uid);
      final userName =
          userData?['displayName'] ?? currentUser.displayName ?? 'Unknown';
      final userPhoto = userData?['photoURL'] ?? currentUser.photoURL;

      // Prepare task details
      final taskDetails = {
        'title': widget.taskTitle ?? '',
        'description': widget.taskDescription ?? '',
        'timeAgo': widget.taskTimeAgo ?? '',
        'taskType': widget.taskType ?? '',
        'image': widget.taskImage ?? '',
        'location': widget.location ?? '',
      };

      // Submit offer to Firebase
      final success = await _offerService.submitOffer(
        taskId: widget.taskId!,
        offerPrice: offerPrice.toDouble(),
        taskBudget: widget.taskBudget ?? 0.0,
        taskDetails: taskDetails,
        taskOwnerUid: widget.taskOwnerUid!,
        taskOwnerName: widget.taskOwnerName ?? 'Unknown',
        taskOwnerPhoto: widget.taskOwnerPhoto,
        offeringUserName: userName,
        offeringUserPhoto: userPhoto,
      );

      setState(() => _isSubmitting = false);

      if (success) {
        Get.back(); // Close bottom sheet
        DialogHelpers.showPaymentSuccessDialog(
          context: context,
          message: 'Your Offer has been sent successfully',
          showButton: false,
        );
      } else {
        Get.snackbar('Error', 'Failed to submit offer. Please try again.');
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      Get.snackbar('Error', 'An error occurred: ${e.toString()}');
    }
  }
}
