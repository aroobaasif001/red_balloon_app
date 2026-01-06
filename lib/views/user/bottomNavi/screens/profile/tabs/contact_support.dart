import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import '../../../../../../utils/colors.dart';
import '../widgets/chatinputbar.dart';
import 'chat_screen.dart';

class contactsupportScreen extends StatefulWidget {
  const contactsupportScreen({super.key});

  @override
  State<contactsupportScreen> createState() => _contactsupportScreenState();
}

class _contactsupportScreenState extends State<contactsupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _startChat() async {
    setState(() => _isLoading = true);

    try {
      // 1. Find Admin UID
      final adminQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: 'admin@gmail.com')
          .limit(1)
          .get();

      if (adminQuery.docs.isEmpty) {
        Get.snackbar('Error', 'Support team is currently unavailable.');
        setState(() => _isLoading = false);
        return;
      }

      final adminDoc = adminQuery.docs.first;
      final adminUid = adminDoc.id;
      final adminName = adminDoc.data()['displayName'] ?? 'Support Team';
      final adminPhoto = adminDoc.data()['photoURL'];

      setState(() => _isLoading = false);

      // 2. Navigate to ChatScreen
      Get.off(
        () => const ChatScreen(),
        arguments: {
          'taskId': 'support_ticket',
          'taskTitle': 'Customer Support',
          'taskOwnerId': adminUid,
          'taskOwnerName': adminName,
          'taskOwnerPhoto': adminPhoto,
          'taskImage': 'assets/images/splash_logo.png', // Logo for support chat
          // conversationId is generated inside ChatController based on taskId and UIDs
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to support: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            /// 🔹 TOP APP BAR
            CustomAppBar1(
              title: 'Customer Support',
              showRightImage: false,
            ),

            /// 🔹 CONTENT
            Expanded(
              child: Container(
                color: whiteColor,
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: redColor)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/splash_logo.png',
                              height: 120,
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                'Click the button below to start a direct chat with our support team.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            /// 🔹 ACTION BUTTON (Instead of raw input bar here, we go to ChatScreen)
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: _startChat,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        'Start Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
