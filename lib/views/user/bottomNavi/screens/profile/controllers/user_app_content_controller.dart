import 'package:get/get.dart';
import '../../../../../../services/content_service.dart';

class UserAppContentController extends GetxController {
  final ContentService _contentService = ContentService();
  
  RxMap<String, dynamic> contentSettings = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    listenToContentSettings();
  }

  void listenToContentSettings() {
    _contentService.getContentSettings().listen((snapshot) {
      final Map<String, dynamic> settings = {};
      for (var doc in snapshot.docs) {
        settings[doc.id] = doc.data();
      }
      contentSettings.value = settings;
    });
  }

  bool isVisible(String pageId) {
    if (contentSettings.containsKey(pageId)) {
      return contentSettings[pageId]['isEnabled'] ?? true;
    }
    return true; // Default to visible if not found
  }

  String getTitle(String pageId, String defaultTitle) {
    if (contentSettings.containsKey(pageId)) {
      return contentSettings[pageId]['title'] ?? defaultTitle;
    }
    return defaultTitle;
  }

  String getContent(String pageId, String defaultContent) {
    if (contentSettings.containsKey(pageId)) {
      return contentSettings[pageId]['content'] ?? defaultContent;
    }
    return defaultContent;
  }

  Map<String, dynamic> getExtraData(String pageId) {
    if (contentSettings.containsKey(pageId)) {
      final data = contentSettings[pageId]['extraData'];
      return data != null ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    }
    return <String, dynamic>{};
  }

  List<dynamic> getList(String pageId, String key) {
    final data = getExtraData(pageId);
    return data[key] as List? ?? [];
  }
}
