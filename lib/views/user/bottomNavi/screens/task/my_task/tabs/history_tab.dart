import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/widgets/history_task_card.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the TasksController
    final TasksController controller = Get.find<TasksController>();

    // Real-time updates are already active from controller's onInit
    // No need to fetch again here

    return RefreshIndicator(
      backgroundColor: whiteColor,
      color: redColor,
      onRefresh: () => controller.fetchHistoryTasks(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Column(
          children: [
            Obx(() {
              // Show loading indicator
              if (controller.isLoadingHistoryTasks.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: redColor),
                  ),
                );
              }

              // Show empty state if no history tasks
              if (controller.historyTasks.isEmpty) {
                return Container(
                  width: double.infinity,
                  height: 500,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 50, color: rbnewcolor),
                        const SizedBox(height: 10),
                        CustomText(
                          'No history yet',
                          fontSize: 16,
                          color: grey6Color!,
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          'Completed and cancelled tasks \nwill appear here',
                          fontSize: 14,
                          color: taskstatus3!,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show list of history tasks
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.historyTasks.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final task = controller.historyTasks[index];
                  String statusText;
                  Color statusTextColor;
                  Color statusBgColor;
                  if (task.status.toLowerCase() == 'rejected') {
                    statusText = 'Validation';
                    statusTextColor = redColor;
                    statusBgColor = redColor.withOpacity(0.25);
                  } else if (task.status.toLowerCase() == 'completed') {
                    statusText = 'Completed';
                    statusTextColor = greenColor;
                    statusBgColor = greenColor.withOpacity(0.25);
                  } else if (task.status.toLowerCase() == 'disputed') {
                    statusText = 'Disputed';
                    statusTextColor = redColor;
                    statusBgColor = redColor.withOpacity(0.25);
                  } else {
                    statusText = 'Cancelled';
                    statusTextColor = redColor;
                    statusBgColor = redColor.withOpacity(0.25);
                  }
                  // if (task.status)
                  print(task.createdAt.toString());
                  String time = DateFormat(
                    'dd MMM \'at\' hh:mm a',
                    'en_US',
                  ).format(task.createdAt);

                  return FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    delay: Duration(milliseconds: index * 700),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: HistoryTaskCard(
                        title: task.title,
                        amount: controller.formatBudget(task.budget),
                        statusText: statusText,
                        statusTextColor: statusTextColor,
                        statusBgColor: statusBgColor,

                        onViewDetails: () async {
                          // 🔥🔥 TEMPORARILY DISABLED - Restore when needed 🔥🔥
                          // For rejected tasks, fetch validation data and navigate
                          if (task.status.toLowerCase() == 'rejected') {
                            Get.snackbar(
                              'Info',
                              'Validation screen temporarily disabled',
                            );
                            /* 🔥 COMMENTED OUT - Restore Later
                            try {
                              // Fetch validation data from validations collection
                              final validationSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('validations')
                                  .where('taskId', isEqualTo: task.id)
                                  .limit(1)
                                  .get();

                              if (validationSnapshot.docs.isNotEmpty) {
                                final validationData = validationSnapshot
                                    .docs
                                    .first
                                    .data();

                                // Fetch userId from users collection using rejectedBy
                                String userId = 'RB-00000';
                                final rejectedBy = validationData['rejectedBy'];
                                if (rejectedBy != null &&
                                    rejectedBy.isNotEmpty) {
                                  final userDoc = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(rejectedBy)
                                      .get();
                                  if (userDoc.exists) {
                                    userId =
                                        userDoc.data()?['userId'] ?? 'RB-00000';
                                  }
                                }

                                // Navigate with validation data
                                Get.to(
                                  () => ValidationScreen(
                                    taskId: task.id,
                                    userId: userId,
                                    beforePhotoUrl:
                                        validationData['beforePhotoUrl'] ?? '',
                                    afterPhotoUrl:
                                        validationData['afterPhotoUrl'] ?? '',
                                  ),
                                );
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Validation data not found',
                                );
                              }
                            } catch (e) {
                              print('❌ Error fetching validation data: $e');
                              Get.snackbar(
                                'Error',
                                'Failed to load validation details',
                              );
                            }
                            */ // END COMMENTED VALIDATION
                          } else if (task.status.toLowerCase() == 'disputed') {
                            Get.snackbar(
                              'Info',
                              'Dispute screen temporarily disabled',
                            );
                            /* 🔥 COMMENTED OUT - Restore Later
                            try {
                              // 1. Fetch Requester Details (using task user uid)
                              Map<String, dynamic> requesterInfo = {};
                              if (task.uid != null) {
                                final reqDoc = await FirebaseFirestore.instance
                                    .collection('users')
                                    .where('uid', isEqualTo: task.uid)
                                    .limit(1)
                                    .get();

                                if (reqDoc.docs.isNotEmpty) {
                                  final data = reqDoc.docs.first.data();
                                  requesterInfo = {
                                    'id': reqDoc.docs.first.id,
                                    'name': data['displayName'] ?? data['name'],
                                    'photoUrl':
                                        data['photoURL'] ?? data['photoUrl'],
                                    'userId': data['userId'],
                                  };
                                }
                              }

                              // 2. Fetch Helper Details (using acceptedOfferUid)
                              Map<String, dynamic> helperInfo = {};
                              if (task.acceptedOfferUid != null) {
                                final helperDoc = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where(
                                      'uid',
                                      isEqualTo: task.acceptedOfferUid,
                                    )
                                    .limit(1)
                                    .get();

                                if (helperDoc.docs.isNotEmpty) {
                                  final data = helperDoc.docs.first.data();
                                  helperInfo = {
                                    'id': helperDoc.docs.first.id,
                                    'name': data['displayName'] ?? data['name'],
                                    'photoUrl':
                                        data['photoURL'] ?? data['photoUrl'],
                                    'userId': data['userId'],
                                  };
                                }
                              }

                              // 3. Prepare Dispute Data
                              final disputeInfo = {
                                'requesterReason': task.requesterHelpReason,
                                'requesterDetails': task.requesterHelpDetails,
                                'helperReason': task.helperHelpReason,
                                'helperDetails': task.helperHelpDetails,
                                'requesterHelpRequested':
                                    task.requesterHelpRequested,
                                'helperHelpRequested': task.helperHelpRequested,
                                'disputedStartTime': task.disputedStartTime,
                              };

                              // 4. Prepare Task Data
                              final taskInfo = {
                                'id': task.id,
                                'title': task.title,
                                'type': task.taskType,
                                'price': task.budget.toString(),
                                'createdAt': task.createdAt.toString(),
                              };

                              print(disputeInfo['disputedStartTime']);

                              // Navigate
                              Get.to(
                                () => TaskDisputedScreen(
                                  requesterData: requesterInfo,
                                  helperData: helperInfo,
                                  disputeData: disputeInfo,
                                  taskData: taskInfo,
                                ),
                              );
                            } catch (e) {
                              print('❌ Error fetching disputed details: $e');
                              Get.snackbar(
                                'Error',
                                'Failed to load dispute details',
                              );
                            }
                            */ // END COMMENTED DISPUTE
                          } else if (task.status.toLowerCase() == 'completed') {
                            Get.snackbar(
                              'Info',
                              'Completed screen temporarily disabled',
                            );
                            /* 🔥 COMMENTED OUT - Restore Later
                            final currentUser = FirebaseAuth.instance.currentUser;
                            if (currentUser == null) return;

                            // Show Loading Feedback immediately
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(color: redColor),
                              ),
                              barrierDismissible: false,
                            );

                            try {
                              final currentUserId = currentUser.uid;

                              // 1. Start Validation Fetch (Parallel)
                              // We can start this before fetching task details since we have task.id
                              final validationFuture = FirebaseFirestore.instance
                                  .collection('validations')
                                  .where('taskId', isEqualTo: task.id)
                                  .where('status', isEqualTo: 'approved')
                                  .limit(1)
                                  .get();

                              // 2. Fetch Fresh Task Data
                              final taskDoc = await FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(task.id)
                                  .get();

                              if (!taskDoc.exists) {
                                Get.back(); // Close loader
                                return;
                              }
                              final taskData = taskDoc.data()!;

                              // 3. Identified User Role
                              bool isRequester =
                                  taskData['uid'] == currentUserId;
                              bool isHelper =
                                  taskData['acceptedOfferUid'] == currentUserId;

                              // 4. Check for existing feedback
                              bool hasFeedback = false;
                              if (isRequester) {
                                hasFeedback =
                                    taskData['requesterFeedback'] != null;
                              } else if (isHelper) {
                                hasFeedback =
                                    taskData['helperFeedback'] != null;
                              }

                              // 5. Fetch Other User Details
                              // (We need taskDoc first to know who the other user is)
                              String otherUserId = isRequester
                                  ? (taskData['acceptedOfferUid'] ?? '')
                                  : (taskData['uid'] ?? '');

                              Map<String, dynamic> otherUserData = {};
                              if (otherUserId.isNotEmpty) {
                                final userQuery = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where('uid', isEqualTo: otherUserId)
                                    .limit(1)
                                    .get();

                                if (userQuery.docs.isNotEmpty) {
                                  final data = userQuery.docs.first.data();
                                  otherUserData = {
                                    'name': data['displayName'] ?? data['name'],
                                    'photoUrl':
                                        data['photoURL'] ?? data['photoUrl'],
                                    'userId': data['userId'],
                                  };
                                }
                              }

                              // 6. Await Validation Data (if not already done)
                              final validationQuery = await validationFuture;
                              Map<String, dynamic> validationInfo = {};
                              if (validationQuery.docs.isNotEmpty) {
                                final vData = validationQuery.docs.first.data();
                                validationInfo = {
                                  'beforePhotoUrl':
                                      vData['beforePhotoUrl'] ?? '',
                                  'afterPhotoUrl': vData['afterPhotoUrl'] ?? '',
                                  'validationId': validationQuery.docs.first.id,
                                  'approvedAt': vData['approvedAt'],
                                };
                              }

                              // 7. Prepare Final Data Maps
                              final taskInfo = {
                                'taskId': task.id,
                                'title': taskData['title'] ?? task.title,
                                'budget': taskData['budget'] ?? task.budget,
                                'taskType':
                                    taskData['taskType'] ?? task.taskType,
                                'location': taskData['location'] ?? '',
                                'completedAt': taskData['completedAt'],
                              };

                              // Close Loading Dialog
                              Get.back();

                              // 8. Navigate
                              if (!hasFeedback) {
                                Get.to(
                                  () => LeaveFeedbackScreen(
                                    taskInfo: taskInfo,
                                    otherUserData: otherUserData,
                                    isRequester: isRequester,
                                  ),
                                );
                              } else {
                                Get.to(
                                  () => TaskCompletedScreen(
                                    taskId: task.id!,
                                    taskData: taskData,
                                    isRequester: isRequester,
                                    otherUserData: otherUserData,
                                    validationInfo: validationInfo,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (Get.isDialogOpen ?? false) Get.back();
                              print('❌ Error in completed task navigation: $e');
                              Get.snackbar('Error', 'Something went wrong');
                            }
                            */ // END COMMENTED COMPLETED
                          }
                        },
                        location: '2.5 km away',
                        dateTime: time,
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}
