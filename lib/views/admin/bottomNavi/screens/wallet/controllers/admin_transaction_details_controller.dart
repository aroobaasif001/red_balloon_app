import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../../../../model/task_model.dart';

class AdminTransactionDetailsController extends GetxController {
  final Map<String, dynamic> transactionData;
  final String userUid;
  final String? taskId;

  final isLoading = true.obs;
  final task = Rxn<TaskModel>();
  final userMapping = <String, String>{}.obs;

  AdminTransactionDetailsController({
    required this.transactionData,
    required this.userUid,
    this.taskId,
  });

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  Future<void> _fetchData() async {
    isLoading.value = true;
    try {
      // Fetch User Mapping for the specific user in this transaction
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userUid).get();
      if (userDoc.exists) {
        userMapping[userUid] = userDoc.data()?['userId'] ?? 'Unknown';
      }

      // Fetch Task Details if taskId exists
      if (taskId != null && taskId != 'N/A' && taskId!.isNotEmpty) {
        // Try getting by doc ID first
        var taskDoc = await FirebaseFirestore.instance.collection('tasks').doc(taskId).get();
        
        if (taskDoc.exists) {
          task.value = TaskModel.fromFirestore(taskDoc);
        } else {
           // Fallback: search by taskId field if it's a custom ID but doc ID is different (though usually they match)
           final search = await FirebaseFirestore.instance.collection('tasks').where('id', isEqualTo: taskId).limit(1).get();
           if (search.docs.isNotEmpty) {
             task.value = TaskModel.fromFirestore(search.docs.first);
           }
        }
      }
    } catch (e) {
      print('Error fetching transaction details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
