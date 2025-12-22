import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailPageScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailPageScreen({super.key, required this.job});

  Color matchColor(int match) {
    if (match >= 80) return Colors.green;
    if (match >= 50) return Colors.orange;
    return Colors.red;
  }

  void _launchURL(BuildContext context, String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot open link")),
      );
    }
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
    int matchPercent = ((job['Match (%)'] ?? 0) as num).toInt();
    String jobLink = job['link'] ?? '';
    String rawTitle = job['Job Title'] ?? 'No Title';
    String cleanedTitle = _cleanTitle(rawTitle);
    String feedback = job['Gemini Feedback'] ?? 'No feedback available';

    // Tách feedback thành sections
    List<String> feedbackSections = feedback.split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Detail"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card chính
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Job Title - Chỉ tên công ty
                    Text(
                      cleanedTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Company
                    Row(
                      children: [
                        const Icon(Icons.business, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            job['Company'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Match % Badge
                    Row(
                      children: [
                        const Text(
                          "Match Score: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: matchColor(matchPercent).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: matchColor(matchPercent),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            "$matchPercent%",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: matchColor(matchPercent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // AI FEEDBACK CARD
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology, color: Colors.purple[700], size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          "AI Analysis",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Hiển thị feedback
                    ...feedbackSections.map((section) {
                      bool isHeader = section.startsWith('Match:') ||
                                     section.startsWith('Comment:') ||
                                     section.startsWith('Improvement:');

                      if (isHeader) {
                        List<String> parts = section.split(':');
                        String header = parts[0];
                        String content = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                header,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  content,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            section,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        );
                      }
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ CHỈ 1 NÚT APPLY NOW - ĐÃ BỎ APPLICATION LINK
            if (jobLink.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL(context, jobLink),
                  icon: const Icon(Icons.send, size: 20),
                  label: const Text(
                    "Apply Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}