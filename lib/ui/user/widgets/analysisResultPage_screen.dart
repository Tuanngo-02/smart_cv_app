import 'package:flutter/material.dart';

import '../view_models/fileService.dart';

class AnalysisResultPageScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const AnalysisResultPageScreen({super.key, required this.result});

  Widget buildSection(String title, Widget content, {IconData? icon}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.blue.shade700, size: 24),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            content
          ],
        ),
      ),
    );
  }

  /// Hiển thị Map<String, dynamic> dạng chip tags đẹp hơn
  Widget buildSkillChips(dynamic data, {bool isScore = false}) {
    if (data is! Map || data.isEmpty) {
      return Text(
        "Không có dữ liệu",
        style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: data.entries.map<Widget>((e) {
        final chipColor = isScore
            ? _getScoreColor(e.value)
            : Colors.blue.shade100;
        final textColor = isScore
            ? _getScoreTextColor(e.value)
            : Colors.blue.shade900;

        return Chip(
          label: Text(
            isScore ? "${e.key}: ${e.value}" : "${e.key}: ${e.value}",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          backgroundColor: chipColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );
      }).toList(),
    );
  }

  Color _getScoreColor(dynamic value) {
    if (value == null) return Colors.grey.shade200;

    double score = 0;
    if (value is num) {
      score = value.toDouble();
    } else if (value is String) {
      score = double.tryParse(value) ?? 0;
    } else {
      // Nếu là Map hoặc kiểu khác, trả về màu mặc định
      return Colors.blue.shade100;
    }

    if (score >= 80) return Colors.green.shade100;
    if (score >= 60) return Colors.lime.shade100;
    if (score >= 40) return Colors.orange.shade100;
    return Colors.red.shade100;
  }

  Color _getScoreTextColor(dynamic value) {
    if (value == null) return Colors.grey.shade700;

    double score = 0;
    if (value is num) {
      score = value.toDouble();
    } else if (value is String) {
      score = double.tryParse(value) ?? 0;
    } else {
      // Nếu là Map hoặc kiểu khác, trả về màu mặc định
      return Colors.blue.shade900;
    }

    if (score >= 80) return Colors.green.shade900;
    if (score >= 60) return Colors.lime.shade900;
    if (score >= 40) return Colors.orange.shade900;
    return Colors.red.shade900;
  }

  Widget buildLevelComparison(dynamic data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildLevelRow(
            "MY CV",
            data['cv_level'] ?? 'N/A',
            "${data['cv_years'] ?? 0} năm",
            Icons.person,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade400, thickness: 1),
          const SizedBox(height: 16),
          _buildLevelRow(
            "JD Requirement",
            data['jd_level'] ?? 'N/A',
            "${data['jd_years'] ?? 0} năm",
            Icons.business_center,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelRow(
      String label,
      String level,
      String years,
      IconData icon,
      Color color,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                level,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                years,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPdfViewer(String pdfUrl) {
    return InkWell(
      onTap: () async => await downloadPdf(pdfUrl),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade50, Colors.red.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade300, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade200.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.picture_as_pdf, color: Colors.red.shade700, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CV được highlight",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Nhấn để tải xuống",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.download_rounded, color: Colors.red.shade700, size: 28),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = result['results'] ?? {};
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Kết quả phân tích CV – JD",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// OVERALL SCORE - Card nổi bật
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.teal.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade300.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "ĐIỂM TỔNG QUAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${data['overall_score']?['overall'] ?? 0}",
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const Text(
                    "/ 100",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            /// CV Skills
            buildSection(
              "Kỹ năng từ CV",
              buildSkillChips(data['cv_skills']),
              icon: Icons.person_outline,
            ),

            /// JD Skills
            buildSection(
              "Kỹ năng yêu cầu từ JD",
              buildSkillChips(data['jd_skills']),
              icon: Icons.work_outline,
            ),

            /// Skill Scores
            buildSection(
              "Điểm kỹ năng",
              buildSkillChips(data['skill_scores'], isScore: true),
              icon: Icons.bar_chart,
            ),

            /// Levels Comparison
            buildSection(
              "So sánh trình độ & kinh nghiệm",
              buildLevelComparison(data),
              icon: Icons.compare_arrows,
            ),

            const SizedBox(height: 8),

            /// PDF Viewer
            buildPdfViewer(result["highlighted_pdf"] ?? ""),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}