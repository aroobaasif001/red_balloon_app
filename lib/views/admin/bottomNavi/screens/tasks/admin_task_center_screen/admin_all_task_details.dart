import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'controller/admin_all_task_details_controller.dart';
import 'widgets/admin_all_task_details_widgets.dart';

class AdminAllTaskDetails extends StatefulWidget {
  final String? taskId;
  const AdminAllTaskDetails({super.key, this.taskId});

  @override
  State<AdminAllTaskDetails> createState() => _AdminAllTaskDetailsState();
}

class _AdminAllTaskDetailsState extends State<AdminAllTaskDetails> {
  int selectedTab = 0; // 0 = DETAILS, 1 = OFFERS
  late final AdminAllTaskDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AdminAllTaskDetailsController());
    if (widget.taskId != null) {
      controller.fetchTaskDetails(widget.taskId!);
    }
  }

  @override
  void dispose() {
    Get.delete<AdminAllTaskDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: redColor),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar1(
                title: 'Task Details',
                showRightImage: false,
              ),
              const SizedBox(height: 15),

              /// TASK INFO CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => TaskInfoCard(
                  title: controller.taskTitle.value,
                  description: controller.taskDescription.value,
                  location: controller.taskLocation.value,
                  completedTime: controller.taskCompletedAt.value.isEmpty
                      ? controller.taskCreatedAt.value
                      : 'Completed ${controller.taskCompletedAt.value}',
                  taskId: controller.requesterUserId.value,
                  budget: controller.taskBudget.value,
                  status: controller.taskStatus.value,
                  imageUrl: controller.taskImageUrl.value,
                )),
              ),

              const SizedBox(height: 20),

              /// PARTICIPANTS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  "Participants",
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// REQUESTER CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => ParticipantCard(
                  name: controller.requesterName.value,
                  userId: controller.requesterUserId.value,
                  imageUrl: controller.requesterImage.value,
                  role: "Requester",
                  stats: {
                    "Tasks Posted": "${controller.requesterTasksPosted.value}",
                    "Rating": controller.requesterRating.value.toStringAsFixed(1),
                  },
                )),
              ),

              const SizedBox(height: 16),

              /// HELPER CARD (if exists)
              Obx(() {
                if (controller.helperName.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ParticipantCard(
                    name: controller.helperName.value,
                    userId: controller.helperUserId.value,
                    imageUrl: controller.helperImage.value,
                    role: "Helper",
                    stats: {
                      "Tasks": "${controller.helperTasksCompleted.value}",
                      "Rating": controller.helperRating.value.toStringAsFixed(1),
                      "Response": controller.helperResponseTime.value,
                    },
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// TABS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = 0),
                        child: CustomContainer(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          borderRadius: BorderRadius.circular(12),
                          conColor: selectedTab == 0 ? redColor : whiteColor,
                          border: Border.all(
                            color: selectedTab == 0 ? redColor : bordercol,
                          ),
                          child: Center(
                            child: CustomText(
                              "Task Details",
                              fontSize: 14,
                              fontWeight: FontVariant.semiBold,
                              color: selectedTab == 0 ? whiteColor : blackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = 1),
                        child: CustomContainer(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          borderRadius: BorderRadius.circular(12),
                          conColor: selectedTab == 1 ? redColor : whiteColor,
                          border: Border.all(
                            color: selectedTab == 1 ? redColor : bordercol,
                          ),
                          child: Center(
                            child: CustomText(
                              "Offers",
                              fontSize: 14,
                              fontWeight: FontVariant.semiBold,
                              color: selectedTab == 1 ? whiteColor : blackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// TAB CONTENT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: selectedTab == 0
                    ? _buildTaskDetailsTab()
                    : _buildOffersTab(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTaskDetailsTab() {
    return Obx(() => CustomContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      conColor: whiteColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Description",
            fontSize: 16,
            fontWeight: FontVariant.semiBold,
          ),
          const SizedBox(height: 12),
          CustomText(
            controller.taskDescription.value,
            fontSize: 14,
            color: timeColor,
            height: 1.5,
          ),
          const SizedBox(height: 20),
          CustomText(
            "Task Information",
            fontSize: 16,
            fontWeight: FontVariant.semiBold,
          ),
          const SizedBox(height: 12),
          InfoRow(label: "Budget", value: controller.taskBudget.value),
          InfoRow(label: "Status", value: controller.taskStatus.value),
          InfoRow(label: "Type", value: controller.taskType.value),
          InfoRow(label: "Location", value: controller.taskLocation.value),
          InfoRow(label: "Posted", value: controller.taskCreatedAt.value),
          if (controller.taskCompletedAt.value.isNotEmpty)
            InfoRow(label: "Completed", value: controller.taskCompletedAt.value),
        ],
      ),
    ));
  }

  Widget _buildOffersTab() {
    return Obx(() {
      if (controller.offers.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                CustomText(
                  "No offers yet",
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      }

      return CustomContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(16),
        conColor: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "All Offers (${controller.offers.length})",
              fontSize: 16,
              fontWeight: FontVariant.semiBold,
            ),
            const SizedBox(height: 16),
            
            // Scrollable offers list (shows ~3 offers)
            SizedBox(
              height: 250, // Reduced height to show ~3 offers
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.offers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final offer = controller.offers[index];
                  return OfferCard(
                    name: offer.offeringUserName,
                    userId: offer.offeringUserUid,
                    amount: 'SAR ${offer.offerPrice}',
                    isAccepted: offer.status == 'accepted',
                    imageUrl: offer.offeringUserPhoto,
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
