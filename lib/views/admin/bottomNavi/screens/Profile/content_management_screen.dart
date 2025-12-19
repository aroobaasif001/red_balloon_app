import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../custom_widgets/custom_appbar.dart';
import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import 'controllers/content_management_controller.dart';
import 'advanced_content_editor_screen.dart';

class ContentManagementScreen extends StatelessWidget {
  const ContentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContentManagementController controller = Get.put(ContentManagementController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const CustomAppBar(titleText: 'Content Management'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              'Manage Footer Pages',
              fontSize: 18,
              fontWeight: FontVariant.bold,
              color: blackColor,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.contentPages.length,
                  itemBuilder: (context, index) {
                    final page = controller.contentPages[index];
                    return _buildContentTile(context, page, controller);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentTile(BuildContext context, ContentPageModel page, ContentManagementController controller) {
    return CustomContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      conColor: white2Color,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      child: Row(
        children: [
          Icon(_getIconForPage(page.id), color: blackColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  page.title,
                  fontSize: 16,
                  fontWeight: FontVariant.medium,
                  color: blackColor,
                ),
                CustomText(
                  page.content,
                  fontSize: 12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: greyColor,
                ),
              ],
            ),
          ),
          Switch(
            value: page.isEnabled,
            onChanged: (value) => controller.toggleVisibility(page.id, value),
            activeTrackColor: redColor,
            activeThumbColor: whiteColor,
            inactiveTrackColor: greyColor.withOpacity(0.2),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: blackColor, size: 22),
            onPressed: () {
              if (['faq', 'how_it_works', 'contact_us', 'about_app'].contains(page.id)) {
                Get.to(() => AdvancedContentEditorScreen(page: page, controller: controller));
              } else {
                _showEditDialog(context, page, controller);
              }
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForPage(String id) {
    switch (id) {
      case 'about_app':
        return Icons.info_outline;
      case 'contact_us':
        return Icons.chat_outlined;
      case 'faq':
        return Icons.help_outline;
      case 'terms_privacy':
        return Icons.description_outlined;
      case 'how_it_works':
        return Icons.history;
      default:
        return Icons.file_present_outlined;
    }
  }

  void _showEditDialog(BuildContext context, ContentPageModel page, ContentManagementController controller) {
    final titleController = TextEditingController(text: page.title);
    final contentController = TextEditingController(text: page.content);
    final isEnabled = page.isEnabled.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),
                    const CustomText(
                      'Edit Page Content',
                      fontSize: 20,
                      fontWeight: FontVariant.bold,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 20),
                const CustomText('Page Title', fontSize: 14, color: greyColor),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    fillColor: white2Color,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText('Enable Page', fontSize: 14),
                    Obx(() => Switch(
                      value: isEnabled.value,
                      onChanged: (v) => isEnabled.value = v,
                      activeTrackColor: redColor,
                    )),
                  ],
                ),
                const SizedBox(height: 20),
                const CustomText('Content', fontSize: 14, color: greyColor),
                const SizedBox(height: 8),
                // Simple Text Toolbar
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: greyColor.withOpacity(0.2)),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      _buildFormatButton(
                        icon: Icons.format_bold,
                        onTap: () => _applyFormat(contentController, '<b>', '</b>'),
                      ),
                      const SizedBox(width: 15),
                      _buildFormatButton(
                        icon: Icons.format_italic,
                        onTap: () => _applyFormat(contentController, '<i>', '</i>'),
                      ),
                      const SizedBox(width: 15),
                      _buildFormatButton(
                        icon: Icons.format_underlined,
                        onTap: () => _applyFormat(contentController, '<u>', '</u>'),
                      ),
                      const SizedBox(width: 15),
                      _buildFormatButton(
                        icon: Icons.format_list_bulleted,
                        onTap: () => _applyFormat(contentController, '• ', ''),
                      ),
                      const SizedBox(width: 15),
                      _buildFormatButton(
                        icon: Icons.format_list_numbered,
                        onTap: () => _applyFormat(contentController, '1. ', ''),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: contentController,
                  maxLines: 12,
                  decoration: InputDecoration(
                    hintText: 'Enter page content here...',
                    fillColor: white2Color,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                      borderSide: BorderSide(color: greyColor.withOpacity(0.2)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    controller.updatePageContent(
                      page.id,
                      titleController.text,
                      contentController.text,
                      isEnabled.value,
                    );
                  },
                  child: CustomContainer(
                    height: 50,
                    conColor: redColor,
                    borderRadius: BorderRadius.circular(12),
                    alignment: Alignment.center,
                    child: Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator(color: whiteColor)
                      : const CustomText(
                          'Save Page Information',
                          color: whiteColor,
                          fontSize: 16,
                          fontWeight: FontVariant.semiBold,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, size: 20, color: blackColor.withOpacity(0.7)),
    );
  }

  void _applyFormat(TextEditingController controller, String prefix, String suffix) {
    final selection = controller.selection;
    final text = controller.text;

    if (selection.isValid && !selection.isCollapsed) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(selection.start, selection.end, '$prefix$selectedText$suffix');
      controller.text = newText;
      controller.selection = TextSelection.collapsed(offset: selection.start + prefix.length + selectedText.length + suffix.length);
    } else {
      final newText = text.replaceRange(selection.baseOffset, selection.baseOffset, '$prefix$suffix');
      controller.text = newText;
      controller.selection = TextSelection.collapsed(offset: selection.baseOffset + prefix.length);
    }
  }
}
