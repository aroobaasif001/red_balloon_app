import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../custom_widgets/custom_appbar.dart';
import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import 'controllers/content_management_controller.dart';

class AdvancedContentEditorScreen extends StatefulWidget {
  final ContentPageModel page;
  final ContentManagementController controller;

  const AdvancedContentEditorScreen({
    super.key,
    required this.page,
    required this.controller,
  });

  @override
  State<AdvancedContentEditorScreen> createState() => _AdvancedContentEditorScreenState();
}

class _AdvancedContentEditorScreenState extends State<AdvancedContentEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late RxBool _isEnabled;
  
  // Specific data for different pages
  List<Map<String, String>> _faqItems = [];
  List<Map<String, String>> _steps = [];
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.page.title);
    _contentController = TextEditingController(text: widget.page.content);
    _isEnabled = widget.page.isEnabled.obs;

    // Initialize structured data
    final extraData = widget.page.extraData ?? {};
    
    if (widget.page.id == 'faq') {
      final items = extraData['items'] as List? ?? [];
      _faqItems = items
          .where((e) => e != null)
          .map((e) => Map<String, String>.from(e as Map))
          .toList();
    } else if (widget.page.id == 'how_it_works') {
      final steps = extraData['steps'] as List? ?? [];
      _steps = steps
          .where((e) => e != null)
          .map((e) => Map<String, String>.from(e as Map))
          .toList();
    } else if (widget.page.id == 'contact_us') {
      _emailController = TextEditingController(text: (extraData['email'] ?? '').toString());
      _phoneController = TextEditingController(text: (extraData['phone'] ?? '').toString());
      _addressController = TextEditingController(text: (extraData['address'] ?? '').toString());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    if (widget.page.id == 'contact_us') {
      _emailController.dispose();
      _phoneController.dispose();
      _addressController.dispose();
    }
    super.dispose();
  }

  void _save() {
    Map<String, dynamic> extraData = {};
    if (widget.page.id == 'faq') {
      extraData['items'] = _faqItems;
    } else if (widget.page.id == 'how_it_works') {
      extraData['steps'] = _steps;
    } else if (widget.page.id == 'contact_us') {
      extraData['email'] = _emailController.text;
      extraData['phone'] = _phoneController.text;
      extraData['address'] = _addressController.text;
    }

    widget.controller.updatePageContent(
      widget.page.id,
      _titleController.text,
      _contentController.text,
      _isEnabled.value,
      extraData: extraData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        titleText: 'Edit ${widget.page.title}',
        action: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check, color: redColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Basic Configuration'),
            const SizedBox(height: 15),
            _buildTextField(label: 'Page Title', controller: _titleController),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText('Enable Page', fontSize: 16),
                Obx(() => Switch(
                  value: _isEnabled.value,
                  onChanged: (v) => _isEnabled.value = v,
                  activeTrackColor: redColor,
                )),
              ],
            ),
            const SizedBox(height: 25),
            
            if (widget.page.id == 'faq') ...[
              _buildSectionHeader('Frequently Asked Questions'),
              const SizedBox(height: 15),
              _buildFaqEditor(),
            ] else if (widget.page.id == 'how_it_works') ...[
              _buildSectionHeader('Steps (Process)'),
              const SizedBox(height: 15),
              _buildStepsEditor(),
            ] else if (widget.page.id == 'contact_us') ...[
              _buildSectionHeader('Contact Information'),
              const SizedBox(height: 15),
              _buildContactUsEditor(),
            ],

            const SizedBox(height: 25),
            _buildSectionHeader('Introduction Text'),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Description',
              controller: _contentController,
              maxLines: 5,
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: _save,
              child: CustomContainer(
                height: 55,
                conColor: redColor,
                borderRadius: BorderRadius.circular(12),
                alignment: Alignment.center,
                child: Obx(() => widget.controller.isLoading.value
                    ? const CircularProgressIndicator(color: whiteColor)
                    : const CustomText(
                        'Save Configuration',
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontVariant.semiBold,
                      )),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return CustomText(
      title,
      fontSize: 18,
      fontWeight: FontVariant.bold,
      color: blackColor,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, fontSize: 14, color: greyColor),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            fillColor: white2Color,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: greyColor.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: greyColor.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: redColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaqEditor() {
    return Column(
      children: [
        ...List.generate(_faqItems.length, (index) {
          return CustomContainer(
            key: ValueKey('faq_$index'),
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            conColor: white1Color,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText('FAQ #${index + 1}', fontWeight: FontVariant.bold),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: redColor),
                      onPressed: () {
                        setState(() {
                          _faqItems.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                TextFormField(
                  initialValue: _faqItems[index]['question'],
                  decoration: const InputDecoration(hintText: 'Question'),
                  onChanged: (v) => _faqItems[index]['question'] = v,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _faqItems[index]['answer'],
                  decoration: const InputDecoration(hintText: 'Answer'),
                  maxLines: 3,
                  onChanged: (v) => _faqItems[index]['answer'] = v,
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        _buildAddButton('Add New FAQ Pair', () {
          setState(() {
            _faqItems.add({'question': '', 'answer': ''});
          });
        }),
      ],
    );
  }

  Widget _buildStepsEditor() {
    return Column(
      children: [
        ...List.generate(_steps.length, (index) {
          return CustomContainer(
            key: ValueKey('step_$index'),
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            conColor: white1Color,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText('Step ${index + 1}', fontWeight: FontVariant.bold),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: redColor),
                      onPressed: () {
                        setState(() {
                          _steps.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                TextFormField(
                  initialValue: _steps[index]['title'],
                  decoration: const InputDecoration(hintText: 'Step Title'),
                  onChanged: (v) => _steps[index]['title'] = v,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _steps[index]['description'],
                  decoration: const InputDecoration(hintText: 'Description'),
                  maxLines: 2,
                  onChanged: (v) => _steps[index]['description'] = v,
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        _buildAddButton('Add New Step', () {
          setState(() {
            _steps.add({'title': '', 'description': ''});
          });
        }),
      ],
    );
  }

  Widget _buildContactUsEditor() {
    return Column(
      children: [
        _buildTextField(label: 'Support Email', controller: _emailController),
        const SizedBox(height: 15),
        _buildTextField(label: 'Contact Number', controller: _phoneController),
        const SizedBox(height: 15),
        _buildTextField(label: 'Office Address', controller: _addressController, maxLines: 2),
      ],
    );
  }

  Widget _buildAddButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        conColor: redColor.withOpacity(0.1),
        border: Border.all(color: redColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: redColor, size: 20),
            const SizedBox(width: 8),
            CustomText(label, color: redColor, fontWeight: FontVariant.medium),
          ],
        ),
      ),
    );
  }
}
