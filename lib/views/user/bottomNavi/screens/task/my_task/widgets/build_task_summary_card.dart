import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/in_progress_task_controller.dart';

/// TASK SUMMARY CARD: title, price, location, posted time
Widget buildTaskSummaryCard(
  InProgressTaskController controller,
  String timeAgo,
  String price,
  String? userName,
  String title,
  String location, {
  String? taskImage,
}) {
  return CustomContainer(
    width: double.infinity,
    conColor: white2Color,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        if (taskImage != null && taskImage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                _showImageFullscreen(Get.context!, taskImage);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  taskImage,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/sofa.png",
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/sofa.png",
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                fontSize: 15,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
              const SizedBox(height: 8),
              CustomText(
                'SAR $price 	 $location',
                fontSize: 14,
                fontWeight: FontVariant.semiBold,
                color: rbtxColor,
              ),
              const SizedBox(height: 4),
              CustomText(
                'Posted $timeAgo',
                fontSize: 12,
                color: walletInfoTextColor,
                fontWeight: FontVariant.regular,
              ),
            ],
          ),
        ),
      ],
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
