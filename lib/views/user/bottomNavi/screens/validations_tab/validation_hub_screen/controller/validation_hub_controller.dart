import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/task_service.dart';

class ValidationHubController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TaskService _taskService = TaskService();

  StreamSubscription<QuerySnapshot>? _subscription;

  RxList<Map<String, dynamic>> validations = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  Timer? _timer;
  RxMap<String, String> remainingTimes = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // First time load: 2 seconds delay
    fetchValidations(minDelay: const Duration(seconds: 2));
    _startTimer();
  }
  
  @override
  void onClose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateRemainingTimes();
    });
  }

  void _updateRemainingTimes() {
    for (var validation in validations) {
      final rejectedAtTimestamp = validation['rejectedAt'];
      if (rejectedAtTimestamp != null) {
        final rejectedAt = (rejectedAtTimestamp as Timestamp).toDate();
        final now = DateTime.now();
        final difference = now.difference(rejectedAt);
        final remainingMinutes = 15 - difference.inMinutes;

        if (remainingMinutes <= 0) {
          remainingTimes[validation['validationId']] = "0 min left to validate";
          // Optional: remove validation if time expired locally or let backend handle it
        } else {
          remainingTimes[validation['validationId']] = "$remainingMinutes min left to validate";
        }
      }
    }
  }

  // Fetch validations from Firestore with real-time updates
  Future<void> fetchValidations({Duration minDelay = Duration.zero}) async {
    try {
      // Cancel previous subscription to avoid duplicates
      await _subscription?.cancel();
      
      isLoading.value = true;
      final Completer<void> completer = Completer<void>();

      // Start the delay timer
      final delayFuture = Future.delayed(minDelay);

      // 🔥 Stream validations where isVotingCompleted is false
      _subscription = _firestore
          .collection('validations')
          .where('isVotingCompleted', isEqualTo: false)
          .snapshots()
          .listen((snapshot) async {
            
        try {
          final List<Map<String, dynamic>> fetchedValidations = [];

          for (var doc in snapshot.docs) {
            final validationData = doc.data();
            final taskId = validationData['taskId'];
            final rejectedBy =
                validationData['rejectedBy']; // UID of user who rejected

            // Fetch userId from users collection using rejectedBy UID
            String userId = 'RB-00000'; // Default
            if (rejectedBy != null && rejectedBy.isNotEmpty) {
              try {
                final userDoc = await _firestore
                    .collection('users')
                    .doc(rejectedBy)
                    .get();

                if (userDoc.exists) {
                  final userData = userDoc.data();
                  userId = userData?['userId'] ?? 'RB-00000';
                }
              } catch (e) {
                print('Error fetching user data: $e');
              }
            }

            // Fetch task details using taskId
            if (taskId != null) {
              final taskData = await _taskService.getTaskById(taskId);
              if (taskData != null) {
                final validationMap = {
                  'validationId': doc.id,
                  'taskId': taskId,
                  'taskTitle': taskData['title'] ?? 'No Title',
                  'userId': userId, // From users collection
                  'beforePhotoUrl': validationData['beforePhotoUrl'] ?? '',
                  'afterPhotoUrl': validationData['afterPhotoUrl'] ?? '',
                  'proofId': validationData['proofId'] ?? '',
                  'status': validationData['status'] ?? 'pending',
                  'rejectedAt': validationData['rejectedAt'] ?? Timestamp.now(),
                };
                fetchedValidations.add(validationMap);
              }
            }
          }

          // If this is the initial load (completer not done), wait for delay
          if (!completer.isCompleted) {
            await delayFuture;
          }

          validations.value = fetchedValidations;
          _updateRemainingTimes(); // Initial calculation
          isLoading.value = false;

          // Complete the future if it hasn't been completed
          if (!completer.isCompleted) {
            completer.complete();
          }
          
        } catch (e) {
          print('Error processing validation stream: $e');
          // Even on error, we should complete to stop listeners waiting indefinitely
          if (!completer.isCompleted) { 
             isLoading.value = false; // ensure loader hides
             completer.complete(); 
          }
        }
      }, onError: (e) {
         print('Stream error: $e');
         isLoading.value = false;
         if (!completer.isCompleted) completer.complete();
      });

      return completer.future;
    } catch (e) {
      print('Error initializing validation stream: $e');
      isLoading.value = false;
    }
  }
}
