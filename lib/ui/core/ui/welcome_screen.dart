// lib/ui/auth/widgets/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/colors.dart'; // Đảm bảo đường dẫn này đúng trong dự án của bạn

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy theme text styles để đảm bảo tính nhất quán
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Gradient mềm mại hơn, từ trên xuống dưới
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg1, AppColors.bg2],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24), // Tăng padding ngang
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon placeholder nổi bật hơn
                  Container(
                    padding: const EdgeInsets.all(28), // Tăng padding
                    decoration: BoxDecoration(
                      color: AppColors.button1,
                      borderRadius: BorderRadius.circular(20), // Bo góc mềm mại hơn
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25), // Thêm bóng đổ tạo chiều sâu
                          spreadRadius: 3,
                          blurRadius: 15,
                          offset: const Offset(0, 8), // Dịch bóng xuống dưới
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.document_scanner_outlined, // Icon hiện tại
                      size: 70, // Kích thước icon lớn hơn
                      color: AppColors.bg2, // Màu icon ngược với nền
                    ),
                  ),

                  const SizedBox(height: 40), // Khoảng cách lớn hơn

                  Text(
                    'AI-Powered Job Support',
                    style: textTheme.headlineLarge?.copyWith(
                      // Có thể tùy chỉnh thêm nếu cần, ví dụ:
                      // color: AppColors.bg2, // Đảm bảo màu sắc tương phản tốt với gradient
                      fontWeight: FontWeight.bold,
                      fontSize: 32, // Kích thước lớn hơn cho tiêu đề chính
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20), // Khoảng cách giữa tiêu đề và phụ đề

                  Text(
                    'Smart CV evaluation & personalized job matching powered by AI',
                    style: textTheme.bodySmall?.copyWith(
                      // color: AppColors.bg2.withOpacity(0.9), // Màu sắc nhẹ nhàng hơn
                      fontSize: 16, // Kích thước chữ rõ ràng hơn
                      height: 1.4, // Giãn dòng để dễ đọc hơn
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50), // Khoảng cách lớn hơn trước nút

                  SizedBox(
                    width: double.infinity,
                    height: 56, // Nút cao hơn một chút
                    child: ElevatedButton.icon( // Sử dụng ElevatedButton.icon để thêm icon
                      onPressed: () {
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button1,
                        foregroundColor: AppColors.bg2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14), // Bo góc mềm mại hơn cho nút
                        ),
                        elevation: 8, // Thêm bóng đổ cho nút
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded, // Icon mũi tên
                        size: 20,
                      ),
                      label: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25), // Khoảng cách sau nút

                  Text(
                    'Join thousands of professionals finding their dream jobs',
                    style: textTheme.labelSmall?.copyWith(
                      // color: AppColors.bg2.withOpacity(0.8), // Màu sắc nhẹ nhàng
                      fontSize: 14, // Kích thước dễ đọc
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}