import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailPageScreen extends StatelessWidget {
  final Map<String, dynamic> job; // chỉ 1 job

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

  @override
  Widget build(BuildContext context) {
    final matchPercent = ((job['Match (%)'] ?? 0) as num).toInt();
    final String jobLink = job['link'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Job Detail")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Title
                Text(
                  job['Job Title'] ?? 'No Title',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Company
                Text(
                  "Company: ${job['Company'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),

                // Match %
                Text(
                  "Match: $matchPercent%",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: matchColor(matchPercent),
                  ),
                ),
                const SizedBox(height: 12),

                // Gemini Feedback
                if ((job['Gemini Feedback'] ?? "").isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Feedback:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job['Gemini Feedback'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Link ứng tuyển
                if (jobLink.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => _launchURL(context, jobLink),
                    icon: const Icon(Icons.link),
                    label: const Text("Apply Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
