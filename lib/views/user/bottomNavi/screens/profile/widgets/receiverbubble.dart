import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ReceiverBubble extends StatelessWidget {
  final String text;
  final String time;
  final String? profilePhoto;
  final String? userName;

  const ReceiverBubble({
    super.key,
    required this.text,
    required this.time,
    this.profilePhoto,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage =
        profilePhoto != null &&
        profilePhoto!.isNotEmpty &&
        profilePhoto!.startsWith('http');
    final userInitial = userName != null && userName!.isNotEmpty
        ? userName!.substring(0, 1).toUpperCase()
        : 'A';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isNetworkImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      profilePhoto!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: redColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomText(
                              userInitial,
                              fontSize: 14,
                              fontWeight: FontVariant.bold,
                              color: whiteColor,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomText(
                        userInitial,
                        fontSize: 14,
                        fontWeight: FontVariant.bold,
                        color: whiteColor,
                      ),
                    ),
                  ),
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                conColor: white2Color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                borderRadius: BorderRadius.circular(22),
                // constraints: const BoxConstraints(
                //   maxWidth: 262,
                // ),
                child: CustomText(text, fontSize: 15, color: grey50Color),
              ),

              const SizedBox(height: 6),

              CustomText(time, fontSize: 11, color: timeColor),
            ],
          ),
        ),
      ],
    );
  }
}
