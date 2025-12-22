import 'package:flutter/material.dart';
import 'jobDetailPage_screen.dart';

class ResultPage extends StatelessWidget {
  final List<dynamic> topJobs;

  const ResultPage({super.key, required this.topJobs});

  Color matchColor(int match) {
    if (match >= 80) return Colors.green;
    if (match >= 50) return Colors.orange;
    return Colors.red;
  }

  /// ✅ LÀM SẠCH TITLE - CHỈ LẤY TÊN CÔNG TY
  String _cleanTitle(String rawTitle) {
    String clean = rawTitle;
    
    // 1. Xóa tất cả links [text](url)
    clean = clean.replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '');
    
    // 2. Xóa URLs trực tiếp (https://...)
    clean = clean.replaceAll(RegExp(r'https?://[^\s)]+'), '');
    
    // 3. Xóa các ký tự markdown còn sót
    clean = clean.replaceAll(RegExp(r'\d+\]'), '');
    clean = clean.replaceAll(RegExp(r'[\[\]]'), '');
    clean = clean.replaceAll(RegExp(r"'{2,}|\]{2,}"), '');
    
    // 4. Xóa \n và normalize spaces
    clean = clean.replaceAll(RegExp(r'\\n'), ' ');
    clean = clean.replaceAll(RegExp(r'\n'), ' ');
    clean = clean.replaceAll(RegExp(r'\s+'), ' ');
    
    // 5. ✅ CHỈ LẤY PHẦN ĐẦU TIÊN trước dấu '(' hoặc ']'
    if (clean.contains('(')) {
      clean = clean.split('(')[0];
    }
    if (clean.contains(']')) {
      clean = clean.split(']')[0];
    }
    
    return clean.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Top Matching Jobs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: topJobs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No jobs found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: topJobs.length,
              itemBuilder: (context, index) {
                var job = topJobs[index];
                int matchPercent = ((job['Match (%)'] ?? 0) as num).toInt();
                String rawTitle = job['Job Title'] ?? 'No Title';
                String cleanTitle = _cleanTitle(rawTitle); // ✅ Làm sạch title

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailPageScreen(job: job),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Title + Match Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ Title đã làm sạch
                              Expanded(
                                child: Text(
                                  cleanTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Match Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: matchColor(matchPercent).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: matchColor(matchPercent),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  "$matchPercent%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: matchColor(matchPercent),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          
                          // Company
                          Row(
                            children: [
                              const Icon(Icons.business, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  job['Company'] ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          
                          // ✅ BỎ HẾT URL BOX - Không hiển thị link
                          
                          const SizedBox(height: 12),
                          
                          // AI Feedback preview
                          if ((job['Gemini Feedback'] ?? "").isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                job['Gemini Feedback'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}