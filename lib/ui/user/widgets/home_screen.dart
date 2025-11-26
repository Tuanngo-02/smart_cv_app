import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/themes/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bg1,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, // full width
                  color: AppColors.button1, // màu nền
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        "WELCOME\n${user!.email}",
                        textAlign: TextAlign.center, // căn giữa
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.bg2,
                          fontWeight: FontWeight.bold,
                          height: 1.3, // khoảng cách dòng
                          fontSize: 18, // chỉnh kích thước chữ
                          letterSpacing: 1.5, // khoảng cách giữa các chữ
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Let's find your perfect job match",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: AppColors.bg2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Quick Actions
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.bg2, // màu nền
                    borderRadius: BorderRadius.circular(12), // bo tròn góc 12
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // màu shadow
                        spreadRadius: 1, // độ lan rộng
                        blurRadius: 1, // độ mờ
                        offset: Offset(0, 3), // vị trí shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quick Actions",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // Navigate to UploadScreen
                            context.go("/upload");
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.lightBlue),
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.bg1,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.button1,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.upload_file,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Upload Documents",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Upload CV & Job Description",
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6),

                // Upload Status
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.bg2, // màu nền
                    borderRadius: BorderRadius.circular(12), // bo tròn góc 12
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // màu shadow
                        spreadRadius: 1, // độ lan rộng
                        blurRadius: 1, // độ mờ
                        offset: Offset(0, 3), // vị trí shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Status",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 13),
                        Column(
                          children: [
                            uploadStatusItem("CV Document"),
                            uploadStatusItem("Job Description"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadStatusItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey),
          SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(width: 8),

          Text(
            "Not uploaded yet",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );

  }
}
