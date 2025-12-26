import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/user_profile_details_screen.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/widget/user_card.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/controller/user_management_controller.dart';

import 'widget/custom_search_field.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController searchController = TextEditingController();
  late final UserManagementController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserManagementController());
    
    // Listen to search changes
    searchController.addListener(() {
      controller.searchUsers(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    Get.delete<UserManagementController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "User Management", disableLeading: true),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // SEARCH FIELD
              CustomSearchField(controller: searchController),

              const SizedBox(height: 20),

              // USER LIST
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: redColor),
                    );
                  }

                  if (controller.filteredUsers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            controller.searchQuery.value.isEmpty
                                ? "No Users Found"
                                : "No users match your search",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: redColor,
                    onRefresh: () => controller.fetchAllUsers(forceRefresh: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: controller.filteredUsers.map((user) {
                          return Obx(() {
                            final role = controller.getUserRole(user);
                            final initials = controller.getUserInitials(user.displayName);
                            final tasksText = controller.getTasksText(user);
                            final rating = controller.getUserRating(user);
                            final price = controller.getUserPrice(user);
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: UserCard(
                                code: user.userId ?? 'RB-0000',
                                userType: role,
                                verified: true, // TODO: Get from user model when available
                                city: user.city ?? 'Unknown',
                                stars: rating,
                                tasksText: tasksText,
                                price: price,
                                initials: initials,
                                imageUrl: user.photoURL,
                                isSuspended: user.willLogin == false,
                                onView: () {
                                  Get.to(() => UserProfileDetailsScreen(
                                        userId: user.uid,
                                      ));
                                },
                              ),
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
