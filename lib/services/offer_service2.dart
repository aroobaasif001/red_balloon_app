import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OfferService2 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get offersCollection => _firestore.collection('offers');

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Submit an offer for a task
  Future<bool> submitOffer({
    required String taskId,
    required double offerPrice,
    required double taskBudget,
    required Map<String, dynamic> taskDetails,
    required String taskOwnerUid,
    required String taskOwnerName,
    String? taskOwnerPhoto,
    required String offeringUserName,
    String? offeringUserPhoto,
  }) async {
    try {
      if (currentUserId == null) {
        print('User not authenticated');
        return false;
      }

      // Create offer document
      final offerRef = offersCollection.doc();
      final offerId = offerRef.id;

      // Structure the offer data according to OfferModel
      final offerData = {
        'offerId': offerId,
        'taskId': taskId, // taskId at root level as per OfferModel
        'offerPrice': offerPrice.toString(),
        'offeringUserUid': currentUserId,
        'offeringUserName': offeringUserName,
        'offeringUserPhoto': offeringUserPhoto,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        // All task details nested as per OfferModel.toJson()
        'taskDetails': {
          'taskId': taskId,
          'title': taskDetails['title'] ?? '',
          'description': taskDetails['description'] ?? '',
          'taskType': taskDetails['taskType'] ?? '',
          'budget': taskBudget,
          'taskOwnerUid': taskOwnerUid,
          'taskOwnerName': taskOwnerName,
          'taskOwnerPhoto': taskOwnerPhoto,
          if (taskDetails['image'] != null) 'image': taskDetails['image'],
          if (taskDetails['location'] != null) 'location': taskDetails['location'],
        },
        'timeAgo': taskDetails['timeAgo'] ?? '',
      };

      // Save to Firestore
      await offerRef.set(offerData);

      print('✅ Offer submitted successfully with ID: $offerId');
      return true;
    } catch (e) {
      print('❌ Error submitting offer: $e');
      return false;
    }
  }

  /// Get offers for a specific task
  Future<List<Map<String, dynamic>>> getTaskOffers(String taskId) async {
    try {
      final snapshot = await offersCollection
          .where('taskId', isEqualTo: taskId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting task offers: $e');
      return [];
    }
  }

  /// Get offers made by current user
  Future<List<Map<String, dynamic>>> getMyOffers() async {
    try {
      if (currentUserId == null) return [];

      final snapshot = await offersCollection
          .where('offeringUserUid', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting my offers: $e');
      return [];
    }
  }

  /// Update offer status (pending, accepted, rejected)
  Future<bool> updateOfferStatus(String offerId, String status) async {
    try {
      await offersCollection.doc(offerId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('Offer status updated to: $status');
      return true;
    } catch (e) {
      print('Error updating offer status: $e');
      return false;
    }
  }

  /// Delete offer
  Future<bool> deleteOffer(String offerId) async {
    try {
      await offersCollection.doc(offerId).delete();
      print('Offer deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting offer: $e');
      return false;
    }
  }

  /// Stream offers for a task
  Stream<List<Map<String, dynamic>>> streamTaskOffers(String taskId) {
    return offersCollection
        .where('taskId', isEqualTo: taskId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }
}
