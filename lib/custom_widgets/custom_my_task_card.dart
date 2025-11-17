import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomMyTaskCard extends StatelessWidget {
  final String title;
  final String amount;
  final String status;
  final String postedTime;
  final String image;

  final String? btnText;
  final VoidCallback? onEdit;
  final VoidCallback? onViewDetails;

  final bool showButton; // 🔥 NEW OPTIONAL BUTTON

  const CustomMyTaskCard({
    super.key,
    required this.title,
    required this.amount,
    required this.status,
    required this.postedTime,
    required this.image,
    this.onEdit,
    this.btnText,
    this.onViewDetails,
    this.showButton = false, // default -> hidden
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.maxFinite,
      padding: const EdgeInsets.all(14),
      conColor: white2Color,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [BoxShadow(color: blackColor.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4)],

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- TITLE + EDIT BUTTON -----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(title, fontSize: 20, fontWeight: FontVariant.semiBold),
              InkWell(onTap: onEdit, child: Image.asset('assets/icons/edit.png', height: 19)),
            ],
          ),

          const SizedBox(height: 16),

          // ----------------- AMOUNT + IMAGE -----------------
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText('Amount Offered', fontWeight: FontVariant.semiBold),

                    const SizedBox(height: 3),

                    CustomText(amount, fontWeight: FontVariant.bold, fontSize: 18, color: redColor),

                    const SizedBox(height: 3),

                    CustomContainer(
                      padding: const EdgeInsets.all(8.5),
                      conColor: whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      child: CustomText(status, fontSize: 10, fontWeight: FontVariant.semiBold),
                    ),
                  ],
                ),
              ),

              // IMAGE
              Expanded(
                child: CustomContainer(
                  height: 104,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),

          CustomText(postedTime, fontWeight: FontVariant.semiBold),

          // ----------------- OPTIONAL BUTTON -----------------
          if (showButton) ...[
            const SizedBox(height: 21),
            Center(
              child: MaterialButton(
                onPressed: onViewDetails,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: CustomContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  conColor: redColor,
                  borderRadius: BorderRadius.circular(15),
                  child: CustomText(
                    btnText ?? "View Details",
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontVariant.semiBold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
