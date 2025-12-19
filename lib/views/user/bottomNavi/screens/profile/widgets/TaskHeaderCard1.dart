import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class TaskHeaderCard extends StatelessWidget {
  final String? taskTitle;
  final String? taskPrice;
  final String? taskImage;
  final String? timeAgo;

  const TaskHeaderCard({
    super.key,
    this.taskTitle,
    this.taskPrice,
    this.taskImage,
    this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = taskImage != null && taskImage!.startsWith('http');

    return CustomContainer(
      conColor: rbcolor,
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.20),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: taskImage != null && isNetworkImage
                ? Image.network(
                    taskImage!,
                    height: 80,
                    width: 106,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/sofa.png",
                        height: 80,
                        width: 106,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    taskImage ?? "assets/images/sofa.png",
                    height: 80,
                    width: 106,
                    fit: BoxFit.cover,
                  ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  taskTitle ?? "Help Move Furniture",
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                  color: blackColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    CustomText(
                      taskPrice ?? "500 SAR",
                      fontSize: 16,
                      fontWeight: FontVariant.bold,
                      color: redColor,
                    ),

                    const SizedBox(width: 25),

                    const Icon(
                      Icons.watch_later_outlined,
                      size: 16,
                      color: grey4Color,
                    ),

                    const SizedBox(width: 4),

                    CustomText(
                      timeAgo ?? "2 min ago",
                      fontSize: 13,
                      color: grey4Color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
