import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_balloon_app/model/offer_model.dart';

class OfferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get offersCollection => _firestore.collection('offers');

  String? get currentUserId => _auth.currentUser?.uid;

  /// Get all offers for a specific task
  Future<List<OfferModel>> getOffersForTask(String taskId) async {
    try {
      print('🔍 OfferService: Fetching offers for task: $taskId');
      
      // 🔥 Query root 'taskId' instead of 'taskDetails.taskId'
      final snapshot = await offersCollection
          .where('taskId', isEqualTo: taskId)
          .get();

      print('📋 OfferService: Found ${snapshot.docs.length} offers');

      final offers = snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          // print('  Offer from: ${data['offeringUserName']} | Price: ${data['offerPrice']}');
          return OfferModel.fromJson(data, doc.id);
        } catch (e) {
          print('⚠️ Error parsing offer ${doc.id}: $e');
          return null;
        }
      }).where((element) => element != null).cast<OfferModel>().toList();

      // Sort by createdAt descending (newest first)
      offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return offers;
    } catch (e) {
      print('❌ OfferService Error getting offers for task: $e');
      return [];
    }
  }

  /// Get offers made by current user
  Future<List<OfferModel>> getMyOffers() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ User not authenticated');
        return [];
      }

      print('🔍 OfferService: Fetching offers by user: $userId');

      final snapshot = await offersCollection
          .where('offeringUserUid', isEqualTo: userId)
          .get();

      print('📋 OfferService: Found ${snapshot.docs.length} offers by user');

      final offers = snapshot.docs.map((doc) {
        return OfferModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return offers;
    } catch (e) {
      print('❌ OfferService Error getting my offers: $e');
      return [];
    }
  }

  /// Get offers received by current user (for their tasks)
  Future<List<OfferModel>> getReceivedOffers() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        print('❌ User not authenticated');
        return [];
      }

      print('🔍 OfferService: Fetching offers received by user: $userId');

      final snapshot = await offersCollection
          .where('taskDetails.taskOwnerUid', isEqualTo: userId)
          .get();

      print('📋 OfferService: Found ${snapshot.docs.length} offers received');

      final offers = snapshot.docs.map((doc) {
        return OfferModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return offers;
    } catch (e) {
      print('❌ OfferService Error getting received offers: $e');
      return [];
    }
  }

  /// Update offer status
  Future<bool> updateOfferStatus(String offerId, String status) async {
    try {
      print('🔄 OfferService: Updating offer $offerId to status: $status');
      
      await offersCollection.doc(offerId).update({
        'status': status,
      });

      print('✅ OfferService: Offer status updated successfully');
      return true;
    } catch (e) {
      print('❌ OfferService Error updating offer status: $e');
      return false;
    }
  }
}
