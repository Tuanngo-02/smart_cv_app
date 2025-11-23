import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final List<dynamic> topJobs;

  const ResultPage({required this.topJobs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top 10 Jobs")),
      body: ListView.builder(
        itemCount: topJobs.length,
        itemBuilder: (context, index) {
          var job = topJobs[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${job['Job Title']} (${job['Match (%)']}%)",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Company: ${job['Company'] ?? 'N/A'}"),
                  SizedBox(height: 8),
                  Text(job['Gemini Feedback'] ?? "", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
