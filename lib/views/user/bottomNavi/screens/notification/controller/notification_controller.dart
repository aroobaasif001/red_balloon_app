import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxInt selectedTabIndex = 0.obs;
  RxList<Map<String, dynamic>> allNotifications = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> offerNotifications =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> validationNotifications =
      <Map<String, dynamic>>[].obs;

  RxInt unreadCount = 0.obs;
  StreamSubscription? _notificationsSubscription;

  @override
  void onInit() {
    super.onInit();
    print('🚀 NotificationController: onInit');
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
          final docs = snapshot.docs
              .map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              })
              .where((n) => n['category'] != 'chat_message')
              .toList(); // 🔥 Filter out chat messages

          allNotifications.assignAll(docs);

          // Filter Offers
          offerNotifications.assignAll(
            docs
                .where(
                  (n) =>
                      n['category'] == 'offer_received' ||
                      n['category'] == 'offer_accepted',
                )
                .toList(),
          );

          // Filter Validation Hub
          validationNotifications.assignAll(
            docs
                .where(
                  (n) =>
                      n['category'] == 'validation_hub_alert' ||
                      n['category'] == 'proof_rejected',
                )
                .toList(),
          );

          // Calculate unread
          unreadCount.value = docs.where((n) => n['read'] == false).length;
        });
  }

  void switchTab(int index) {
    tabController.animateTo(index);
  }

  Future<void> markAllAsRead() async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final unreadItems = allNotifications
        .where((n) => n['read'] == false)
        .toList();
    if (unreadItems.isEmpty) return;

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
    print('🛑 NotificationController: onClose');
    _notificationsSubscription?.cancel();
    tabController.dispose();
    super.onClose();
  }
}
