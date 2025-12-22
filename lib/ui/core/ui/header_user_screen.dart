import 'package:flutter/material.dart';

import '../../core/themes/colors.dart';
import '../../user/widgets/Upload_screen.dart';
import '../../user/widgets/home_screen.dart';
import '../../user/widgets/listJobsPage_screen.dart';

class HeaderUserScreen extends StatelessWidget {
  const HeaderUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // số tab hiện có
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(), // không cho swipe ngang
          children: [
            HomeScreen(),
            UploadScreen(),
            ListJobsPageScreen()
            // AIAnalysisScreen(),
            // JobsScreen(),
            // ProfileScreen(),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: AppColors.button1,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.analytics), text: "AI Analysis"),
            Tab(icon: Icon(Icons.work), text: "Jobs"),
          ],
        ),
      ),
    );
  }
}
