import 'package:flutter/material.dart';

import '../view_models/fileService.dart';

class AnalysisResultPageScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const AnalysisResultPageScreen({super.key, required this.result});

  Widget buildSection(String title, Widget content) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue)),
            SizedBox(height: 12),
            content
          ],
        ),
      ),
    );
  }

  /// Hiển thị 1 list đơn giản
  Widget buildList(dynamic items) {
    if (items is! List || items.isEmpty) {
      return Text("Không có dữ liệu",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map<Widget>((e) => Text("- $e")).toList(),
    );
  }

  /// Hiển thị 1 Map<String, dynamic> như list
  Widget buildMapAsList(dynamic data) {
    if (data is! Map || data.isEmpty) {
      return Text("Không có dữ liệu",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map<Widget>((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text("- ${e.key}: ${e.value}"),
        );
      }).toList(),
    );
  }

  /// Hiển thị Semantic Matches (List<Map>)
  Widget buildSemanticList(dynamic list) {
    if (list is! List || list.isEmpty) {
      return Text("Không có dữ liệu",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map<Widget>((item) {
        if (item is Map) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("- ${item['jd'] ?? ''}"),
          );
        }
        return Text("- $item");
      }).toList(),
    );
  }

  Widget buildPdfViewer(String pdfUrl) {
    return InkWell(
      onTap: () async => await downloadPdf (pdfUrl),
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.red, size: 30),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                pdfUrl,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.download, color: Colors.red),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final data = result['results'] ?? {};
    print(result['highlighted_pdf'] + "hello");
    return Scaffold(
      appBar: AppBar(
        title: Text("Kết quả phân tích CV – JD"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// OVERALL SCORE
            buildSection(
              "Điểm tổng quan",
              Text(
                "${data['overall_score']} / 100",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),

            /// CV Skills
            buildSection(
              "Kỹ năng từ CV",
              buildMapAsList(data['cv_skills']),
            ),

            /// JD Skills
            buildSection(
              "Kỹ năng yêu cầu từ JD",
              buildMapAsList(data['jd_skills']),
            ),

            /// Skill Scores
            buildSection(
              "Điểm kỹ năng",
              buildMapAsList(data['skill_scores']),
            ),

            /// Levels
            buildSection(
              "Trình độ & Số năm kinh nghiệm",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CV Level: ${data['cv_level']}"),
                  Text("CV Years: ${data['cv_years']} năm"),
                  SizedBox(height: 8),
                  Text("JD Level: ${data['jd_level']}"),
                  Text("JD Years: ${data['jd_years']} năm"),
                ],
              ),
            ),

            /// JD Requirements
            buildSection(
              "Yêu cầu từ JD",
              buildMapAsList(data['jd_requirements']),
            ),

            /// Semantic Matches
            buildSection(
              "Khớp ngữ nghĩa (Semantic Matches)",
              buildSemanticList(data['semantic_matches']),
            ),

            /// Semantic Missing
            buildSection(
              "Thiếu ngữ nghĩa (Semantic Missing)",
              buildList(data['semantic_missing']),
            ),

            /// TF-IDF Matches
            buildSection(
              "Khớp TF-IDF",
              buildList(data['tfidf_matches']),
            ),
            SizedBox(height: 20),

            buildPdfViewer(result["highlighted_pdf"]),

          ],
        ),
      ),
    );
  }
}
