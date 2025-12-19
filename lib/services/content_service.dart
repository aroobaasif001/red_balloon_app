import 'package:cloud_firestore/cloud_firestore.dart';

class ContentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'app_content';

  /// Fetch all content settings
  Stream<QuerySnapshot> getContentSettings() {
    return _firestore.collection(_collection).snapshots();
  }

  /// Update a specific content page
  Future<void> updateContentPage({
    required String pageId,
    required String title,
    required String content,
    required bool isEnabled,
    Map<String, dynamic>? extraData,
  }) async {
    await _firestore.collection(_collection).doc(pageId).set({
      'title': title,
      'content': content,
      'isEnabled': isEnabled,
      'extraData': extraData ?? {},
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Toggle page visibility
  Future<void> togglePageVisibility(String pageId, bool isVisible) async {
    await _firestore.collection(_collection).doc(pageId).update({
      'isEnabled': isVisible,
    });
  }

  /// Get specific page content
  Future<DocumentSnapshot> getPageContent(String pageId) async {
    return await _firestore.collection(_collection).doc(pageId).get();
  }
}
