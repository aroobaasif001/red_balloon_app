import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:red_balloon_app/model/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection reference
  CollectionReference get tasksCollection => _firestore.collection('tasks');

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Upload image to Firebase Storage (Optional)
  Future<String?> uploadTaskImage(File imageFile, String taskId) async {
    try {
      if (currentUserId == null) {
        print('User not authenticated');
        return null;
      }

      final fileName = 'task_$taskId.jpg';
      final ref = _storage.ref().child('tasks/$currentUserId/$fileName');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      print('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  /// Create a new task in Firestore
  Future<String?> createTask({
    required String taskType,
    required String title,
    required String description,
    required double budget,
    String? location,
    String? userId,
    File? imageFile,
  }) async {
    try {
      if (currentUserId == null) {
        print('User not authenticated');
        return null;
      }

      // Create task document
      final taskRef = tasksCollection.doc();
      final taskId = taskRef.id;

      // Upload image if provided
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadTaskImage(imageFile, taskId);
      }

      // Create task model
      final task = TaskModel(
        id: taskId,
        uid: currentUserId!,
        userId: userId,
        taskType: taskType,
        title: title,
        description: description,
        budget: budget,
        location: location,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        status: 'active',
      );

      // Save to Firestore
      await taskRef.set(task.toJson());

      print('Task created successfully with ID: $taskId');
      return taskId;
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  /// Get all tasks
  Future<List<TaskModel>> getAllTasks() async {
    try {
      print('🔍 TaskService: Fetching ALL tasks from database');
      
      final snapshot = await tasksCollection.get();

      print('📋 TaskService: Found ${snapshot.docs.length} total documents');
      
      final tasks = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            print('  Task: "${data['title']}" | UID: ${data['uid']}');
            return TaskModel.fromJson(data, doc.id);
          })
          .toList();
      
      // Sort by createdAt in memory (descending - newest first)
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      print('✅ TaskService: Returning ${tasks.length} total tasks');
      return tasks;
    } catch (e) {
      print('❌ TaskService Error getting tasks: $e');
      return [];
    }
  }

  /// Get user's tasks
  Future<List<TaskModel>> getUserTasks(String uid) async {
    try {
      print('🔍 TaskService: Fetching tasks for UID: $uid');
      
      final snapshot = await tasksCollection
          .where('uid', isEqualTo: uid)
          .get();

      print('📋 TaskService: Found ${snapshot.docs.length} documents');
      
      final tasks = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            print('  Document ID: ${doc.id} | UID in doc: ${data['uid']}');
            return TaskModel.fromJson(data, doc.id);
          })
          .toList();
      
      // Sort by createdAt in memory (descending - newest first)
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      print('✅ TaskService: Returning ${tasks.length} tasks');
      return tasks;
    } catch (e) {
      print('❌ TaskService Error getting user tasks: $e');
      return [];
    }
  }

  /// Get task by ID
  Future<Map<String, dynamic>?> getTaskById(String taskId) async {
    try {
      final doc = await tasksCollection.doc(taskId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error getting task by ID: $e');
      return null;
    }
  }

  /// Get current user's tasks
  Future<List<TaskModel>> getCurrentUserTasks() async {
    if (currentUserId == null) return [];
    return getUserTasks(currentUserId!);
  }

  /// Get single task
  Future<TaskModel?> getTask(String taskId) async {
    try {
      final doc = await tasksCollection.doc(taskId).get();
      if (doc.exists) {
        return TaskModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting task: $e');
      return null;
    }
  }

  /// Update task
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      await tasksCollection.doc(taskId).update(data);
      print('Task updated successfully');
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await tasksCollection.doc(taskId).delete();
      print('Task deleted successfully');
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  /// Stream user's tasks
  Stream<List<TaskModel>> streamUserTasks(String uid) {
    return tasksCollection
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  /// Stream all tasks
  Stream<List<TaskModel>> streamAllTasks() {
    return tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  /// Upload proof image to Firebase Storage
  Future<String?> uploadProofImage(File imageFile, String taskId, String imageType) async {
    try {
      if (currentUserId == null) {
        print('User not authenticated');
        return null;
      }

      final fileName = '${imageType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('task_proofs/$taskId/$fileName');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      print('Proof image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading proof image: $e');
      return null;
    }
  }

  /// Submit task proof to Firestore
  Future<String?> submitTaskProof({
    required String taskId,
    required String userId,
    required String username,
    String? userPhotoUrl,
    String? beforePhotoUrl,
    String? afterPhotoUrl,
    String? note,
    required String taskTitle,
    required String taskPrice,
  }) async {
    try {
      if (currentUserId == null) {
        print('User not authenticated');
        return null;
      }

      // Create proof document
      final proofRef = _firestore.collection('task_proofs').doc();
      final proofId = proofRef.id;

      final proofData = {
        'taskId': taskId,
        'userId': userId,
        'username': username,
        'userPhotoUrl': userPhotoUrl,
        'beforePhotoUrl': beforePhotoUrl,
        'afterPhotoUrl': afterPhotoUrl,
        'note': note,
        'submittedAt': DateTime.now().toIso8601String(),
        'taskTitle': taskTitle,
        'taskPrice': taskPrice,
      };

      // Save to Firestore
      await proofRef.set(proofData);

      print('Task proof submitted successfully with ID: $proofId');
      return proofId;
    } catch (e) {
      print('Error submitting task proof: $e');
      rethrow;
    }
  }
  /// Update Help Request
  Future<void> updateHelpRequest({
    required String taskId,
    required String role, // 'requester' or 'helper'
    required String reason,
    required String details,
  }) async {
    try {
      final taskDoc = tasksCollection.doc(taskId);
      final snapshot = await taskDoc.get();

      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      
      final Map<String, dynamic> updates = {
        '${role}HelpRequested': true,
        '${role}HelpReason': reason,
        '${role}HelpDetails': details,
      };

      // Check if the OTHER party has already requested help
      bool otherPartyRequested = false;
      if (role == 'requester') {
        otherPartyRequested = data['helperHelpRequested'] ?? false;
      } else {
        otherPartyRequested = data['requesterHelpRequested'] ?? false;
      }

      // If both have now requested, set status to Disputed
      if (otherPartyRequested) {
        updates['status'] = 'Disputed';
        updates['disputedStartTime'] = DateTime.now().toIso8601String(); // 🔥 Added timestamp
        print('🚨 Both parties requested help. Task $taskId moved to Disputed.');
      } else {
        print('⚠️ $role requested help. Waiting for other party.');
      }

      await taskDoc.update(updates);
    } catch (e) {
      print('Error updating help request: $e');
      rethrow;
    }
  }
}

