import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/in_progress_task_controller.dart';
import '../widgets/build_bottom_upload_bar.dart';
import '../widgets/build_helper_info_card.dart';
import '../widgets/build_route_card.dart';
import '../widgets/build_status_card.dart';
import '../widgets/build_task_summary_card.dart';

class InProgressViewDetails extends StatelessWidget {
  const InProgressViewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final InProgressTaskController controller = Get.put(
      InProgressTaskController(),
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: const CustomAppBar(titleText: 'Task Progress'),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildStatusCard(controller),
                    const SizedBox(height: 16),
                    buildRouteCard(),
                    const SizedBox(height: 16),
                    buildTaskSummaryCard(controller),
                    const SizedBox(height: 16),
                    buildHelperInfoCard(controller),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            buildBottomUploadBar(context, controller),
          ],
        ),
      ),
    );
  }
}
