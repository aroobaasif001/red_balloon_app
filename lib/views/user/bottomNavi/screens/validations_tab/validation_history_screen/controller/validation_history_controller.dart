import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ValidationHistoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<Map<String, dynamic>> earnings = <Map<String, dynamic>>[].obs;
  RxDouble totalEarning = 0.0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchValidationHistory();
  }

  Future<void> fetchValidationHistory() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    isLoading.value = true;
    try {
      // Listen to transactions real-time
      _firestore
          .collection('wallet')
          .doc(uid)
          .collection('transactions')
          .where(
            'title',
            whereIn: ['Validation Reward', 'Validation Win - Payment'],
          )
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
            double total = 0;
            final List<Map<String, dynamic>> items = [];

            for (var doc in snapshot.docs) {
              final data = doc.data();
              final amount = (data['amount'] ?? 0.0).toDouble();
              total += amount;

              final DateTime date =
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
              final formattedDate = DateFormat('MMM dd · h a').format(date);

              final isWin = data['title'] == 'Validation Win - Payment';

              items.add({
                'title': data['description'] ?? data['title'],
                'date': formattedDate,
                'amount': '+${amount.toStringAsFixed(1)} SAR',
                'status': isWin ? 'Win' : 'Correct',
              });
            }

            earnings.value = items;
            totalEarning.value = total;
            isLoading.value = false;
          });
    } catch (e) {
      print('Error fetching validation history: $e');
      isLoading.value = false;
    }
  }
}
