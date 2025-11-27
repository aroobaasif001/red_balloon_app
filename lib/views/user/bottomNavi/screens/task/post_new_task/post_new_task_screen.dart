import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/post_new_task/widgets/custom_dropdown.dart';

import 'confirm_payment_screen.dart';
import 'controller/post_new_task_controller.dart';

class PostNewTaskScreen extends StatelessWidget {
  const PostNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostNewTaskController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        title: CustomText(
          'Post New Task',
          fontSize: 24,
          fontWeight: FontVariant.bold,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- Task Type ----------------
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 10),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/icons/category-solid.png'),
                      height: 20,
                    ),
                    SizedBox(width: 10),
                    CustomText(
                      'Task Type',
                      fontSize: 20,
                      fontWeight: FontVariant.semiBold,
                    ),
                  ],
                ),
              ),

              // ---- Custom Dropdown (GetX reactive) ----
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropdown(
                      hint: "Select Task Type",
                      selectedValue: controller.selectedTaskType.value,
                      items: controller.taskTypes,
                      onChanged: (value) {
                        controller.selectedTaskType.value = value;
                      },
                    ),
                    if (controller.taskTypeError.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 8, top: 6),
                        child: CustomText(
                          controller.taskTypeError.value,
                          color: redColor,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 38),

              // ---------------- Task Title ----------------
              CustomTextField(
                controller: controller.taskTitle, // ADD THIS
                labelIcon: 'assets/icons/pen-line.png',
                label: 'Task Title',
                hintText: 'What do you need help with?',
              ),
              Obx(
                () => controller.titleError.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(left: 8, top: 6),
                        child: CustomText(
                          controller.titleError.value,
                          color: redColor,
                          fontSize: 12,
                        ),
                      )
                    : SizedBox.shrink(),
              ),

              SizedBox(height: 17),

              // ---------------- Description ----------------
              CustomTextField(
                controller: controller.taskDescription, // ADD THIS
                maxLines: 5,
                labelIcon: 'assets/icons/icon-park-solid.png',
                label: 'Description',
                hintText: 'Provide more details about your task...',
              ),
              Obx(
                () => controller.descriptionError.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(left: 8, top: 6),
                        child: CustomText(
                          controller.descriptionError.value,
                          color: redColor,
                          fontSize: 12,
                        ),
                      )
                    : SizedBox.shrink(),
              ),

              SizedBox(height: 34),

              // ---------------- Budget ----------------
              CustomTextField(
                controller: controller.taskBudget, // ADD THIS
                labelIcon: 'assets/icons/hugeicons_coins-yen.png',
                label: 'Budget',
                prefixWidget: CustomText(
                  'SAR',
                  fontSize: 13,
                  fontWeight: FontVariant.regular,
                  color: blackColor,
                ),
                suffixWidget: IconButton(
                  onPressed: () {
                    DialogHelpers.showPriceInfoDialog(context);
                  },
                  icon: Icon(
                    Icons.info_outline,
                    size: 20,
                    color: blackColor.withOpacity(0.25),
                  ),
                ),
                hintText: '15',
              ),
              Obx(
                () => controller.budgetError.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(left: 8, top: 6),
                        child: CustomText(
                          controller.budgetError.value,
                          color: redColor,
                          fontSize: 12,
                        ),
                      )
                    : SizedBox.shrink(),
              ),

              SizedBox(height: 29),
              // ---------------- Location ----------------
              Obx(() {
                return controller.selectedTaskType.value == "Online Task"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: controller.location,
                            labelIcon: 'assets/icons/location.png',
                            label: 'Location',
                          ),

                          // Error text
                          if (controller.locationError.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(left: 8, top: 6),
                              child: CustomText(
                                controller.locationError.value,
                                color: redColor,
                                fontSize: 12,
                              ),
                            ),

                          SizedBox(height: 29),
                        ],
                      )
                    : SizedBox.shrink();
              }),
              // ---------------- Media Upload ----------------
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 10),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/icons/camera.png'),
                      height: 20,
                    ),
                    SizedBox(width: 10),
                    CustomText(
                      'Upload Media ',
                      fontSize: 20,
                      fontWeight: FontVariant.semiBold,
                    ),
                    CustomText('(Optional)', fontWeight: FontVariant.light),
                  ],
                ),
              ),

              Obx(() {
                final file = controller.pickedFile.value;
                final hasFile = file != null;
                final isPdf =
                    hasFile && (file!.extension ?? '').toLowerCase() == 'pdf';

                Widget buildImagePreview() {
                  if (!hasFile) return SizedBox.shrink();
                  if (isPdf) return SizedBox.shrink();

                  final imageWidget = file!.bytes != null
                      ? Image.memory(file.bytes!, fit: BoxFit.fill)
                      : (file.path != null
                            ? Image.file(File(file.path!), fit: BoxFit.fill)
                            : Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.insert_drive_file_outlined,
                                      size: 40,
                                      color: blackColor,
                                    ),
                                    SizedBox(height: 6),
                                    CustomText(
                                      "Preview not available",
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ));

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: imageWidget,
                    ),
                  );
                }

                Widget buildPdfPreview() {
                  if (!isPdf) return SizedBox.shrink();
                  return Container(
                    height: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 60, color: redColor),
                        SizedBox(height: 6),
                        CustomText(file!.name, fontSize: 12),
                      ],
                    ),
                  );
                }

                return Ink(
                  decoration: BoxDecoration(
                    color: white2Color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: controller.pickMedia,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: double.maxFinite,
                      padding: hasFile
                          ? EdgeInsets.all(0)
                          : EdgeInsets.symmetric(horizontal: 58, vertical: 50),
                      child: hasFile
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildImagePreview(),
                                buildPdfPreview(),
                              ],
                            )
                          : Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                    'assets/icons/cloud-plus-Ar.png',
                                  ),
                                  height: 70,
                                ),
                                SizedBox(height: 6),
                                CustomText(
                                  'JPG, PNG, PDF (Max 5MB)',
                                  fontSize: 10,
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 21),

              // ---------------- Info Box ----------------
              CustomContainer(
                padding: EdgeInsets.all(20),
                conColor: red2Color,
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 25,
                      color: whiteColor,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CustomText(
                        'Your task will be visible to nearby helpers within 20km of your location',
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 36),
              Center(
                child: CustomButton(
                  width: MediaQuery.of(context).size.width * 0.5,
                  bgColor: red2Color,
                  label: 'Next',
                  onPressed: () async {
                    if (!controller.validateForm()) return;

                    final result = await Get.to(() => ConfirmPaymentScreen());

                    if (result == true) {
                      DialogHelpers.showPaymentSuccessDialog(
                        context: context,
                        showButton: false,
                        message: 'Your Task was posted successfully!',
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: 33),
            ],
          ),
        ),
      ),
    );
  }
}
