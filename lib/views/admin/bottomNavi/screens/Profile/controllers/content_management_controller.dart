import 'package:get/get.dart';
import '../../../../../../services/content_service.dart';

class ContentManagementController extends GetxController {
  final ContentService _contentService = ContentService();

  RxList<ContentPageModel> contentPages = <ContentPageModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContentPages();
  }

  void fetchContentPages() {
    _contentService.getContentSettings().listen((snapshot) {
      contentPages.value = snapshot.docs
          .map((doc) => ContentPageModel.fromFirestore(doc))
          .where((page) => page.id != 'terms_privacy') // Filter out Terms & Privacy
          .toList();
      
      // Initialize default pages if empty
      if (contentPages.isEmpty) {
        _initializeDefaultPages();
      }
    });
  }

  Future<void> _initializeDefaultPages() async {
    final defaultPages = [
      {
        'id': 'about_app',
        'title': 'About the app',
        'content': 'Welcome to Red Balloon, your ultimate platform for connecting people who need tasks done with those who can do them. Our mission is to empower individuals by providing a secure and efficient way to outsource micro-tasks, while offering helpers a chance to earn by sharing their skills.',
        'isEnabled': true,
        'extraData': {
          'sections': [
            {'title': 'Our Mission', 'content': 'Red Balloon is dedicated to connecting people...'}
          ]
        }
      },
      {
        'id': 'contact_us',
        'title': 'Contact Us',
        'content': 'Have questions or need help? Our team is here for you.',
        'isEnabled': true,
        'extraData': {
          'email': 'support@redballoon.com',
          'phone': '+1 (123) 456-7890',
          'address': '123 Business Street, Tech City, ST 12345'
        }
      },
      {
        'id': 'faq',
        'title': 'FAQ\'s',
        'content': 'Frequently Asked Questions',
        'isEnabled': true,
        'extraData': {
          'items': [
            {'question': 'How do I post a task?', 'answer': 'Simply click the floating "+" button on the home screen, fill in the requirements, and set your budget.'},
            {'question': 'Is my payment secure?', 'answer': 'Yes, Red Balloon uses a secure escrow system. Your payment is held safely until you approve the completed task.'},
            {'question': 'How do I withdraw earnings?', 'answer': 'You can request a withdrawal from your wallet section once your task balance is cleared.'}
          ]
        }
      },
      {
        'id': 'how_it_works',
        'title': 'How it works',
        'content': 'Getting started with Red Balloon is easy...',
        'isEnabled': true,
        'extraData': {
          'steps': [
            {'title': 'Post your Requirement', 'description': 'Describe the task you need help with in simple words.'},
            {'title': 'Compare Offers', 'description': 'Review bids from verified helpers and choose the best one.'},
            {'title': 'Approve & Pay', 'description': 'Once the work is done, release the payment from escrow.'}
          ]
        }
      }
    ];

    for (var page in defaultPages) {
      await _contentService.updateContentPage(
        pageId: page['id'] as String,
        title: page['title'] as String,
        content: page['content'] as String,
        isEnabled: page['isEnabled'] as bool,
        extraData: page['extraData'] as Map<String, dynamic>?,
      );
    }
  }

  Future<void> toggleVisibility(String id, bool value) async {
    try {
      await _contentService.togglePageVisibility(id, value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update visibility');
    }
  }

  Future<void> updatePageContent(String id, String title, String content, bool isEnabled, {Map<String, dynamic>? extraData}) async {
    try {
      isLoading.value = true;
      await _contentService.updateContentPage(
        pageId: id,
        title: title,
        content: content,
        isEnabled: isEnabled,
        extraData: extraData,
      );
      Get.back(); // Close dialog
      Get.snackbar('Success', 'Page updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update page');
    } finally {
      isLoading.value = false;
    }
  }
}

class ContentPageModel {
  final String id;
  final String title;
  final String content;
  final bool isEnabled;
  final Map<String, dynamic>? extraData;

  ContentPageModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isEnabled,
    this.extraData,
  });

  factory ContentPageModel.fromFirestore(var doc) {
    final Map<String, dynamic> data = (doc.data() as Map<String, dynamic>?) ?? {};
    
    final Map<String, dynamic> extra = {};
    final dynamic rawExtra = data['extraData'];
    if (rawExtra != null && rawExtra is Map) {
      rawExtra.forEach((key, value) {
        extra[key.toString()] = value;
      });
    }

    return ContentPageModel(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      isEnabled: data['isEnabled'] ?? true,
      extraData: extra,
    );
  }
}
