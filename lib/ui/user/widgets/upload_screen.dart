import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../core/themes/colors.dart';
import '../view_models/fileService.dart';
import 'analysisResultPage_screen.dart';
import 'resultPage.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}
class _UploadScreenState extends State<UploadScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  PlatformFile? cvFile;
  PlatformFile? jdFile;

  Future<void> uploadCv(PlatformFile cvFile) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://127.0.0.1:5000/upload"),
    );

    if (kIsWeb) {
      // Web dùng bytes
      final bytes = cvFile.bytes;
      if (bytes == null) return;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: cvFile.name,
        ),
      );
    } else {
      // Mobile/Dekstop dùng path
      if (cvFile.path == null) return;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          cvFile.path!,
          filename: cvFile.name,
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      // đọc response JSON
      String respStr = await response.stream.bytesToString();
      var jsonData = jsonDecode(respStr);

      for (var job in jsonData) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('jobs')
            .doc(job["JobID"].toString()) // dùng JobID làm documentId
            .set(job);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(topJobs: jsonData),
        ),
      );
      print("Top jobs JSON: $jsonData");
      return jsonData; // list of top 10 jobs
    } else {
      print("Upload lỗi: ${response.statusCode}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/home");    // chuyển hẳn về trang home
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload Documents",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 4),
                Text(
                  "Upload your CV and target job description",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.all(16),
                  color: AppColors.bg1,
                  child: UploadCard(
                    title: "Upload Your CV",
                    subtitle: "PDF format, max 5MB",
                    icon: Icons.description,
                    iconColor: AppColors.button1,
                    buttonColor: AppColors.button1,
                    onFileSelected: (PlatformFile file) {
                      setState(() {
                        cvFile = file; // cập nhật trạng thái nút
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.all(16),
                  color: AppColors.bg1,
                  child: UploadCard(
                    title: "Upload Job Description",
                    subtitle: "PDF format, max 5MB",
                    icon: Icons.work_outline,
                    iconColor: Colors.purple,
                    buttonColor: Colors.purple,
                    onFileSelected: (file) {
                      setState(() {
                        jdFile = file;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (cvFile != null)
                          ? AppColors
                          .button1 // màu nền khi enabled
                          : Colors.grey, // màu nền khi disabled
                      foregroundColor: Colors.white, // màu chữ
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: (cvFile != null )
                        ? () async {
                      // Thực hiện phân tích AI
                      // Ví dụ gửi file lên backend
                      if (cvFile != null) {
                        await uploadCv(cvFile!);
                      }

                    }
                        : null, // disabled nếu chưa chọn file
                    child: Text("Search for Jobs"),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (cvFile != null && jdFile != null)
                          ? AppColors
                          .button1 // màu nền khi enabled
                          : Colors.grey, // màu nền khi disabled
                      foregroundColor: Colors.white, // màu chữ
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: (cvFile != null && jdFile != null)
                        ? () async {
                      var result = await sendCvJdFiles(cvFile: cvFile!, jdFile: jdFile!);
                      print(result);
                      if (result != null && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AnalysisResultPageScreen(result: result),
                          ),
                        );
                      }

                    }
                        : null, // disabled nếu chưa chọn file
                    child: Text("Continue to AI Analysis"),
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class UploadCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final Function(PlatformFile file) onFileSelected;

  const UploadCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.buttonColor,
    required this.onFileSelected,
  });

  @override
  State<UploadCard> createState() => _UploadCardState();
}

class _UploadCardState extends State<UploadCard> {
  PlatformFile? selectedFile; // ✅ lưu file đã chọn

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RectDottedBorderOptions(
        dashPattern: [6, 3],
        strokeWidth: 2,
        color: Colors.grey,
        padding: EdgeInsets.all(8),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: widget.iconColor.withOpacity(0.2),
              child: Icon(widget.icon, color: widget.iconColor),
            ),
            SizedBox(height: 12),
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(widget.subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                FilePickerResult? result =
                await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null) {
                  final file = result.files.single;
                  setState(() {
                    selectedFile = file; // cập nhật file chọn
                  });
                  widget.onFileSelected(file); // trả file ra màn hình cha
                }
              },
              child: Text(
                selectedFile != null
                    ? selectedFile!.name // hiển thị tên file
                    : "Choose File",
              ),
            ),
          ],
        ),
      ),
    );
  }
}


