import 'package:flutter/material.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/widget/user_card.dart' show UserCard;

import '../../../../../../custom_widgets/customtext.dart';
import 'widget/custom_search_field.dart' show CustomSearchField;
class UserManagementScreen extends StatelessWidget {
  UserManagementScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  // Dummy user list
  final List<Map<String, dynamic>> users = [
    {
      "code": "RB-102",
      "role": "Requester",
      "verified": true,
      "city": "Riyadh",
      "stars": 4,
      "tasks": "12 tasks posted",
      "price": "SAR 255",
      "initials": "AM",
    },
    {
      "code": "RB-087",
      "role": "Helper",
      "verified": true,
      "city": "Jeddah",
      "stars": 5,
      "tasks": "25 tasks completed",
      "price": "SAR 1,420",
      "initials": "SA",
    },
    {
      "code": "RB-156",
      "role": "Requester",
      "verified": true,
      "city": "Dammam",
      "stars": 4,
      "tasks": "8 tasks posted",
      "price": "SAR 890",
      "initials": "LM",
    },
    {
      "code": "RB-203",
      "role": "Helper",
      "verified": true,
      "city": "Riyadh",
      "stars": 5,
      "tasks": "18 tasks completed",
      "price": "SAR 675",
      "initials": "KA",
    },
    {
      "code": "RB-078",
      "role": "Requester",
      "verified": true,
      "city": "Mecca",
      "stars": 4,
      "tasks": "15 tasks posted",
      "price": "SAR 1,125",
      "initials": "NA",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              // TITLE
              Center(
                child: const CustomText(
                  "User Management",
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                ),
              ),

              const SizedBox(height: 20),

              // SEARCH FIELD
              CustomSearchField(controller: searchController),

              const SizedBox(height: 20),

              // USER LIST
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: users.map((user) {
                      return UserCard(
                        code: user["code"],
                        userType: user["role"],
                        verified: user["verified"],
                        city: user["city"],
                        stars: user["stars"],
                        tasksText: user["tasks"],
                        price: user["price"],
                        initials: user["initials"],
                        onView: () {}, // Navigate to profile
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
