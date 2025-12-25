import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

class AdminBeforeTab extends StatelessWidget {
  final String? imageUrl;

  const AdminBeforeTab({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomContainer(
        padding: const EdgeInsets.all(0),
        height: 320,
        width: double.infinity,
        borderRadius: BorderRadius.circular(20),
        conColor: whiteColor,
        image: imageUrl != null && imageUrl!.isNotEmpty
            ? DecorationImage(
                image: CachedNetworkImageProvider(imageUrl!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/Rectangle 34625290 (1).png'),
                scale: 4,
              ),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.20),
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
