import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/disputes/widget/disputecard.dart';
import '../controller/admin_disputes_controller.dart';

class AdminDisputesTab extends StatelessWidget {
  const AdminDisputesTab({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDisputesController());
    
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔴 TOP APP BAR
            CustomAppBar1(
              title: 'Disputes',
              showLeftImage: false,
              showRightImage: false,
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Obx(() => CustomText(
                "Active Disputes (${controller.disputedTasks.length})",
                fontSize: 22,
                fontWeight: FontVariant.bold,
              )),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomText(
                "Requires admin review and resolution",
                fontSize: 14,
                color: walletTextGreyColor,
              ),
            ),
            
            const SizedBox(height: 10),
            
            /// 🔵 DISPUTE LIST
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: redColor),
                  );
                }
                
                if (controller.disputedTasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.gavel, size: 64, color: fundCardBorderColor),
                        const SizedBox(height: 16),
                        CustomText(
                          "No Active Disputes",
                          fontSize: 18,
                          fontWeight: FontVariant.semiBold,
                          color: taskstatus3,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          "All disputes have been resolved",
                          fontSize: 14,
                          color: rbnewcolor!,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
                  itemCount: controller.disputedTasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.disputedTasks[index];
                      return DisputeCard(
                        task: task,
                        timeAgo: controller.getTimeAgo(
                          controller.getDisplayDate(task),
                        ),
                      );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
