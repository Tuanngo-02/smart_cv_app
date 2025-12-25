import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../../core/themes/colors.dart';
import '../view_models/fileService.dart';
import 'analysisResultPage_screen.dart';
import 'resultPage.dart';
/// MY FILES SCREEN
class MyFilesScreen extends StatefulWidget {
  const MyFilesScreen({Key? key}) : super(key: key);

  @override
  State<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  /// =======================
  /// SELECTED FILES
  /// =======================
  String? selectedCvId;
  String? selectedJdId;

  Map<String, dynamic>? selectedCvData;
  Map<String, dynamic>? selectedJdData;

  /// =======================
  /// DETECT FILE TYPE
  /// =======================
  String _detectFileType(String fileName) {
    final name = fileName.toLowerCase();
    if (name.contains('cv')) return 'CV';
    if (name.contains('jd')) return 'JD';
    return 'OTHER';
  }

  /// =======================
  /// DELETE FILE
  /// =======================
  Future<void> _deleteFile(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: const Text('Are you sure you want to delete this file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('files')
          .doc(docId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File deleted'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
  Future<void> uploadCvFromUrl(String fileUrl) async {
    final uri = Uri.parse('http://127.0.0.1:5000/upload');
    final request = http.MultipartRequest('POST', uri);

    try {
      // 1️⃣ Download file từ Cloudinary
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode != 200) {
        throw Exception('Không tải được file từ URL');
      }

      final Uint8List bytes = response.bodyBytes;

      // 2️⃣ Lấy tên file
      final fileName = path.basename(Uri.parse(fileUrl).path);

      // 3️⃣ Add vào multipart
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        ),
      );

      // 4️⃣ Send
      // final streamed = await request.send();
      // final res = await http.Response.fromStream(streamed);
      final res = await request.send();
      if (res.statusCode == 200) {
        // đọc response JSON
        final respStr = await res.stream.bytesToString();
        final jsonData = jsonDecode(respStr);
        print(jsonData);
        for (final job in jsonData) {
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
    } catch (e) {
      debugPrint('❌ Upload từ URL lỗi: $e');
      rethrow;
    }
  }
  /// =======================
  /// ANALYZE
  /// =======================
  void _analyzeCv() {
    final cvUrl = selectedCvData!['fileUrl'];
    if (cvUrl != null) {
      uploadCvFromUrl(cvUrl);
    }
  }

  Future<Map<String, dynamic>?> _analyzeCvWithJd() async {
    final cvUrl = selectedCvData!['fileUrl'];
    final jdUrl = selectedJdData!['fileUrl'];

    if (cvUrl == null || jdUrl == null) return null;

    return await sendCvJdLinks(
      cvUrl: cvUrl,
      jdUrl: jdUrl,
    );
  }



  /// =======================
  /// UI
  /// =======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg1,
      appBar: AppBar(
        backgroundColor: AppColors.button1,
        title: const Text(
          'My Files',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildFileList(),

      /// 🔽 ACTION BUTTONS
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed:
                selectedCvData == null ? null : () => _analyzeCv(),
                child: const Text('Search Jobs'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: (selectedCvData == null || selectedJdData == null)
                    ? null
                    : () async {
                  final result = await _analyzeCvWithJd();
                  if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phân tích thất bại')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnalysisResultPageScreen(
                          result: result,
                    ),
                  ));
                    },

                child: const Text('Compare CV & JD'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =======================
  /// FILE LIST
  /// =======================
  Widget _buildFileList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('files')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final files = snapshot.data?.docs ?? [];

        if (files.isEmpty) {
          return const Center(
            child: Text(
              'No files uploaded yet',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final doc = files[index];
            final data = doc.data() as Map<String, dynamic>;

            final fileName = data['fileName'] ?? 'Unknown';
            final createdAt =
            (data['createdAt'] as Timestamp?)?.toDate();

            final fileType = _detectFileType(fileName);
            final isCv = fileType == 'CV';
            final isJd = fileType == 'JD';

            final isSelected =
                (isCv && selectedCvId == doc.id) ||
                    (isJd && selectedJdId == doc.id);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (isCv) {
                        selectedCvId = value == true ? doc.id : null;
                        selectedCvData = value == true ? data : null;
                      } else if (isJd) {
                        selectedJdId = value == true ? doc.id : null;
                        selectedJdData = value == true ? data : null;
                      }
                    });
                  },
                ),
                title: Text(
                  fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (createdAt != null)
                      Text(
                        _formatDate(createdAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                    const SizedBox(height: 4),

                    /// TAG CV / JD
                    if (isCv || isJd)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isCv
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          fileType,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                            isCv ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteFile(doc.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// =======================
  /// HELPERS
  /// =======================
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
