import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final List<dynamic> topJobs;

  const ResultPage({super.key, required this.topJobs});

  // Hàm xác định màu dựa trên match %
  Color matchColor(int match) {
    if (match >= 80) return Colors.green;
    if (match >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top 10 Jobs"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: topJobs.length,
        itemBuilder: (context, index) {
          final job = topJobs[index];

          final matchPercent = ((job['Match (%)'] ?? 0) as num).toInt();

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: () {
                // TODO: Thêm hành động khi nhấn vào job (ví dụ mở link)
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title + Match %
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            job['Job Title'] ?? 'No Title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$matchPercent%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: matchColor(matchPercent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Company
                    Text(
                      "Company: ${job['Company'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),

                    // Gemini Feedback
                    if ((job['Gemini Feedback'] ?? "").isNotEmpty)
                      Text(
                        job['Gemini Feedback'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
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
