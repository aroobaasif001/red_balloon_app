import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/leave_feedback_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_completed_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_disputed_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/widgets/history_task_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/validation_screen.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the TasksController
    final TasksController controller = Get.put(TasksController());

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
                  } else if (task.status.toLowerCase() == 'dispute dismissed') {
                    statusText = 'Dispute Dismissed';
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
                          // For rejected tasks, fetch validation data and navigate
                          if (task.status.toLowerCase() == 'rejected') {
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
                                String userId = 'RB-0000';
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
                                        userDoc.data()?['userId'] ?? 'RB-0000';
                                  }
                                }

                                // Navigate with validation data
                                Get.to(
                                  () => ValidationScreen(
                                    validationId:
                                        validationSnapshot.docs.first.id,
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
                          } else if (task.status.toLowerCase() == 'disputed') {
                            // 🔥 Show Loading Feedback immediately
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(color: redColor),
                              ),
                              barrierDismissible: false,
                            );

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
                                    'uid': task.uid,
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
                                    'uid': task.acceptedOfferUid,
                                    'id': helperDoc.docs.first.id,
                                    'name': data['displayName'] ?? data['name'],
                                    'photoUrl':
                                        data['photoURL'] ?? data['photoUrl'],
                                    'userId': data['userId'],
                                  };
                                }
                              }

                              // 3. Prepare Dispute Data
                              // Fetch validation photos or proof photos for dispute
                              final validationSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('validations')
                                  .where('taskId', isEqualTo: task.id)
                                  .limit(1)
                                  .get();

                              String beforeUrl = '';
                              String afterUrl = '';
                              if (validationSnapshot.docs.isNotEmpty) {
                                final vData = validationSnapshot.docs.first
                                    .data();
                                beforeUrl =
                                    vData['beforePhotoUrl'] ??
                                    vData['beforeImageUrl'] ??
                                    vData['beforePhoto'] ??
                                    '';
                                afterUrl =
                                    vData['afterPhotoUrl'] ??
                                    vData['afterImageUrl'] ??
                                    vData['afterPhoto'] ??
                                    '';
                              }

                              // Fallback to task_proofs if validations didn't have photos
                              if (beforeUrl.isEmpty || afterUrl.isEmpty) {
                                final proofSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('task_proofs')
                                    .where('taskId', isEqualTo: task.id)
                                    .orderBy('submittedAt', descending: true)
                                    .limit(5)
                                    .get();
                                if (proofSnapshot.docs.isNotEmpty) {
                                  for (var doc in proofSnapshot.docs) {
                                    final pData = doc.data();
                                    final b =
                                        pData['beforePhotoUrl'] ??
                                        pData['beforeImageUrl'] ??
                                        pData['beforePhoto'] ??
                                        '';
                                    final a =
                                        pData['afterPhotoUrl'] ??
                                        pData['afterImageUrl'] ??
                                        pData['afterPhoto'] ??
                                        '';

                                    if (b.isNotEmpty || a.isNotEmpty) {
                                      if (beforeUrl.isEmpty) beforeUrl = b;
                                      if (afterUrl.isEmpty) afterUrl = a;
                                      break;
                                    }
                                  }
                                }
                              }

                              final disputeInfo = {
                                'requesterReason': task.requesterHelpReason,
                                'requesterDetails': task.requesterHelpDetails,
                                'helperReason': task.helperHelpReason,
                                'helperDetails': task.helperHelpDetails,
                                'requesterHelpRequested':
                                    task.requesterHelpRequested,
                                'helperHelpRequested': task.helperHelpRequested,
                                'disputedStartTime': task.disputedStartTime,
                                'beforePhotoUrl': beforeUrl,
                                'afterPhotoUrl': afterUrl,
                              };

                              // 4. Prepare Task Data
                              final taskInfo = {
                                'taskId': task.id,
                                'title': task.title,
                                'category': task.taskType,
                                'budget': task.budget.toString(),
                                'createdAt': task.createdAt.toString(),
                              };

                              print(disputeInfo['disputedStartTime']);

                              // Close Loading Dialog
                              if (Get.isDialogOpen ?? false) {
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                Get.back();
                              }

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
                              // Close Loading Dialog if open
                              if (Get.isDialogOpen ?? false) {
                                Get.back();
                              }
                              print('❌ Error fetching disputed details: $e');
                              Get.snackbar(
                                'Error',
                                'Failed to load dispute details',
                              );
                            }
                          } else if (task.status.toLowerCase() == 'completed' ||
                              task.status.toLowerCase() ==
                                  'dispute dismissed') {
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser == null) return;

                            // Show Loading Feedback immediately
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(
                                  color: redColor,
                                ),
                              ),
                              barrierDismissible: false,
                            );

                            try {
                              final currentUserId = currentUser.uid;

                              // 1. Start Validation Fetch (Parallel)
                              // We can start this before fetching task details since we have task.id
                              final validationFuture = FirebaseFirestore
                                  .instance
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
                              String beforeUrl = '';
                              String afterUrl = '';

                              if (validationQuery.docs.isNotEmpty) {
                                final vData = validationQuery.docs.first.data();
                                beforeUrl =
                                    vData['beforePhotoUrl'] ??
                                    vData['beforeImageUrl'] ??
                                    vData['beforePhoto'] ??
                                    '';
                                afterUrl =
                                    vData['afterPhotoUrl'] ??
                                    vData['afterImageUrl'] ??
                                    vData['afterPhoto'] ??
                                    '';
                              }

                              // Fallback to task_proofs for completed tasks
                              if (beforeUrl.isEmpty || afterUrl.isEmpty) {
                                final proofQuery = await FirebaseFirestore
                                    .instance
                                    .collection('task_proofs')
                                    .where('taskId', isEqualTo: task.id)
                                    .orderBy('submittedAt', descending: true)
                                    .limit(5)
                                    .get();
                                if (proofQuery.docs.isNotEmpty) {
                                  for (var doc in proofQuery.docs) {
                                    final pData = doc.data();
                                    final b =
                                        pData['beforePhotoUrl'] ??
                                        pData['beforeImageUrl'] ??
                                        pData['beforePhoto'] ??
                                        '';
                                    final a =
                                        pData['afterPhotoUrl'] ??
                                        pData['afterImageUrl'] ??
                                        pData['afterPhoto'] ??
                                        '';

                                    if (b.isNotEmpty || a.isNotEmpty) {
                                      if (beforeUrl.isEmpty) beforeUrl = b;
                                      if (afterUrl.isEmpty) afterUrl = a;
                                      break;
                                    }
                                  }
                                }
                              }

                              validationInfo = {
                                'beforePhotoUrl': beforeUrl,
                                'afterPhotoUrl': afterUrl,
                                'validationId': validationQuery.docs.isNotEmpty
                                    ? validationQuery.docs.first.id
                                    : '',
                                'approvedAt': validationQuery.docs.isNotEmpty
                                    ? validationQuery.docs.first
                                          .data()['approvedAt']
                                    : null,
                              };

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
                              if (Get.isDialogOpen ?? false) {
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                Get.back();
                              }

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
                              if (Get.isDialogOpen ?? false) {
                                await Future.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                Get.back();
                              }
                              print('❌ Error in completed task navigation: $e');
                              Get.snackbar('Error', 'Something went wrong');
                            }
                          }
                        },
                        location: controller.getDistanceToTask(task.latitude, task.longitude) ?? '',
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
