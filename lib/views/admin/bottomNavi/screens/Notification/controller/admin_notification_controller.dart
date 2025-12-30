import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminNotificationController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxInt selectedTabIndex = 0.obs;
  RxList<Map<String, dynamic>> allNotifications = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> offerNotifications = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> validationNotifications = <Map<String, dynamic>>[].obs;

  StreamSubscription? _notificationsSubscription;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabChange);
    _bindNotifications();
  }

  void _handleTabChange() {
    selectedTabIndex.value = tabController.index;
  }

  void _bindNotifications() {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _notificationsSubscription?.cancel();
    _notificationsSubscription = _firestore
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final docs = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      allNotifications.assignAll(docs);

      // Filter Offers
      offerNotifications.assignAll(
        docs.where((n) => 
          n['category'] == 'offer_received' || 
          n['category'] == 'offer_accepted' ||
          n['category'] == 'withdrawal_update' // Adding this for admin context if relevant
        ).toList(),
      );

      // Filter Validation Hub + "validation" word match
      validationNotifications.assignAll(
        docs.where((n) {
          final titleMatch = (n['title']?.toString().toLowerCase().contains('validation') ?? false);
          final bodyMatch = (n['body']?.toString().toLowerCase().contains('validation') ?? false);
          final categoryMatch = (n['category'] == 'validation_hub_alert' || n['category'] == 'proof_rejected');
          
          return categoryMatch || titleMatch || bodyMatch;
        }).toList(),
      );
    });
  }

  void switchTab(int index) {
    tabController.animateTo(index);
  }

  Future<void> clearAll() async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Get current list based on selected tab or just all?
    // User said "Clear All", usually implies the current view or everything.
    // Let's go with all as it's a global action usually.
    
    final itemsToClear = allNotifications.toList();
    if (itemsToClear.isEmpty) return;

    try {
      final batch = _firestore.batch();
      for (var item in itemsToClear) {
        final docRef = _firestore
            .collection('notifications')
            .doc(uid)
            .collection('items')
            .doc(item['id']);
        batch.delete(docRef);
      }
      await batch.commit();
      Get.snackbar('Success', 'All notifications cleared');
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear notifications: $e');
    }
  }

  Future<void> markAllAsRead() async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final unreadItems = allNotifications.where((n) => n['read'] == false).toList();
    if (unreadItems.isEmpty) return;

    try {
      final batch = _firestore.batch();
      for (var item in unreadItems) {
        final docRef = _firestore
            .collection('notifications')
            .doc(uid)
            .collection('items')
            .doc(item['id']);
        batch.update(docRef, {'read': true});
      }
      await batch.commit();
    } catch (e) {
      print('Error marking all as read: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .doc(notificationId)
        .update({'read': true});
  }

  String formatTimeAgo(dynamic createdAt) {
    if (createdAt == null) return "Just now";
    DateTime dateTime;
    if (createdAt is Timestamp) {
      dateTime = createdAt.toDate();
    } else if (createdAt is String) {
      dateTime = DateTime.tryParse(createdAt) ?? DateTime.now();
    } else {
      dateTime = DateTime.now();
    }

    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays < 7) return "${diff.inDays}d ago";
    return DateFormat('MMM dd').format(dateTime);
  }

  @override
  void onClose() {
    _notificationsSubscription?.cancel();
    tabController.dispose();
    super.onClose();
  }
}
