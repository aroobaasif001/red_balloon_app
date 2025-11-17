import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/widgets/custom_bonus_slider.dart';

import 'widgets/quick_action.dart';
import 'widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Image(image: AssetImage('assets/images/splash_logo.png'), height: 84),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Image(image: AssetImage('assets/icons/notification.png'), height: 24),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image(image: AssetImage('assets/icons/profile.png'), height: 50),
                    customBorder: CircleBorder(),
                  ),
                ],
              ),
              SizedBox(height: 14.99),
              CustomBonusSlider(),
              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Offline Task Tab
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText('Requests Near You', fontSize: 14, fontWeight: FontVariant.bold),
                            SizedBox(height: 12),
                            TaskCard(title: 'Help move furniture', price: 'SAR 500', btnText: 'View Details'),
                            TaskCard(title: 'Help move furniture', price: 'SAR 500', btnText: 'View Details'),
                            TaskCard(title: 'Help move furniture', price: 'SAR 500', btnText: 'View Details'),
                            SizedBox(height: 24),
                            CustomText('Quick Actions', fontSize: 14, fontWeight: FontVariant.bold),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                QuickAction(icon: Icons.person, label: 'Profile'),
                                QuickAction(icon: Icons.history, label: 'History'),
                                QuickAction(icon: Icons.wallet, label: 'Wallet'),
                                QuickAction(icon: Icons.settings, label: 'Settings'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Online Task Tab
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText('Requests Near You', fontSize: 14, fontWeight: FontVariant.bold),
                            SizedBox(height: 12),
                            TaskCard(title: 'Online Task 1', price: 'SAR 300', btnText: 'View Details'),
                            TaskCard(title: 'Online Task 2', price: 'SAR 400', btnText: 'View Details'),
                            TaskCard(title: 'Online Task 3', price: 'SAR 350', btnText: 'View Details'),
                            SizedBox(height: 24),
                            CustomText('Quick Actions', fontSize: 14, fontWeight: FontVariant.bold),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                QuickAction(icon: Icons.person, label: 'Profile'),
                                QuickAction(icon: Icons.history, label: 'History'),
                                QuickAction(icon: Icons.wallet, label: 'Wallet'),
                                QuickAction(icon: Icons.settings, label: 'Settings'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
