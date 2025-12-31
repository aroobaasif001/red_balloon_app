import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class StatsGrid extends StatelessWidget {
  final String rating;
  final String postedTasks;
  final String helpedTasks;

  const StatsGrid({
    super.key,
    required this.rating,
    required this.postedTasks,
    required this.helpedTasks,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      conColor: white2Color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: walletBlackColor.withOpacity(0.25),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.star,
            value: rating,
            label: 'Rating',
            iconColor: Colors.amber,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.post_add,
            value: postedTasks,
            label: 'Posted',
            iconColor: redColor,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.handshake_outlined,
            value: helpedTasks,
            label: 'Helped',
            iconColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 8),
        CustomText(
          value,
          fontSize: 18,
          fontWeight: FontVariant.bold,
          color: blackColor,
        ),
        CustomText(
          label,
          fontSize: 12,
          fontWeight: FontVariant.regular,
          color: grey2Color,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: greyLiteColor,
    );
  }
}
