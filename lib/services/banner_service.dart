import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:red_balloon_app/model/banner_model.dart';

class BannerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference get _bannerCollection => _firestore.collection('banners');

  /// Upload banner image to Firebase Storage
  Future<String?> uploadBannerImage(File imageFile) async {
    try {
      final fileName = 'banner_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('banners/$fileName');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading banner image: $e');
      return null;
    }
  }

  /// Add a new banner at the top (index 0)
  Future<void> addBanner(BannerModel banner) async {
    try {
      final batch = _firestore.batch();
      
      // Shift all existing banners' indices by +1
      final snapshots = await _bannerCollection.get();
      for (var doc in snapshots.docs) {
        final currentIdx = (doc.data() as Map<String, dynamic>)['index'] ?? 0;
        batch.update(doc.reference, {'index': currentIdx + 1});
      }
      
      // Add new banner at index 0
      final newDocRef = _bannerCollection.doc();
      batch.set(newDocRef, banner.copyWith(index: 0).toJson());
      
      await batch.commit();
    } catch (e) {
      print('Error adding banner: $e');
      rethrow;
    }
  }

  /// Update an existing banner
  Future<void> updateBanner(BannerModel banner) async {
    try {
      if (banner.id == null) return;
      await _bannerCollection.doc(banner.id).update(banner.toJson());
    } catch (e) {
      print('Error updating banner: $e');
      rethrow;
    }
  }

  /// Delete a banner
  Future<void> deleteBanner(String bannerId) async {
    try {
      await _bannerCollection.doc(bannerId).delete();
    } catch (e) {
      print('Error deleting banner: $e');
      rethrow;
    }
  }

  /// Toggle banner active status
  Future<void> toggleBannerStatus(String bannerId, bool isActive) async {
    try {
      await _bannerCollection.doc(bannerId).update({'isActive': isActive});
    } catch (e) {
      print('Error toggling banner status: $e');
      rethrow;
    }
  }

  /// Update banners order in a batch
  Future<void> updateBannersOrder(List<BannerModel> banners) async {
    final batch = _firestore.batch();
    for (int i = 0; i < banners.length; i++) {
      final docRef = _bannerCollection.doc(banners[i].id);
      batch.update(docRef, {'index': i});
    }
    await batch.commit();
  }

  /// Stream all banners (ordered in-memory to support legacy docs without index)
  Stream<List<BannerModel>> streamBanners() {
    return _bannerCollection.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => BannerModel.fromFirestore(doc))
          .toList();
      // Sort in-memory: primarily by index, then by createdAt
      list.sort((a, b) {
        int cmp = a.index.compareTo(b.index);
        if (cmp != 0) return cmp;
        return b.createdAt.compareTo(a.createdAt);
      });
      return list;
    });
  }
}
