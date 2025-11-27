import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ReviewCard extends StatefulWidget {
  final String initials;
  final String id;
  final String review;
  final String time;

  const ReviewCard({
    super.key,
    required this.initials,
    required this.id,
    required this.review,
    required this.time,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
          blurRadius: 3,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP ROW
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: CustomText(
                  widget.initials,
                  fontSize: 16,
                  fontWeight: FontVariant.bold,
                  color: redColor,
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    widget.id,
                    fontSize: 14,
                    fontWeight: FontVariant.bold,
                    color: Colors.black,
                  ),

                  Row(
                    children: const [
                      Icon(Icons.star, size: 16, color: redColor),
                      Icon(Icons.star, size: 16, color: redColor),
                      Icon(Icons.star, size: 16, color: redColor),
                      Icon(Icons.star, size: 16, color: redColor),
                      Icon(Icons.star, size: 16, color: redColor),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// COLLAPSIBLE REVIEW TEXT
          AnimatedCrossFade(
            firstChild: CustomText(
              widget.review,
              fontSize: 14,
              color: Colors.black87,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: CustomText(
              widget.review,
              fontSize: 14,
              color: Colors.black87,
            ),
            crossFadeState:
            expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),

          const SizedBox(height: 12),

          /// TIME
          CustomText(
            widget.time,
            fontSize: 12,
            color: Colors.grey,
          ),

          const SizedBox(height: 8),

          /// VIEW FEEDBACK / SEE LESS BUTTON
          GestureDetector(
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: CustomText(
              expanded ? "See Less" : " See more",
              fontSize: 14,
              color: redColor,
              fontWeight: FontVariant.bold,
            ),
          ),
        ],
      ),
    );
  }
}
