import 'package:flutter/material.dart';

import '../view_models/resultService.dart';
import 'jobDetailPage_screen.dart';

class ListJobsPageScreen extends StatefulWidget {
  const ListJobsPageScreen({super.key});

  @override
  State<ListJobsPageScreen> createState() => _ListJobsPageScreenState();
}

class _ListJobsPageScreenState extends State<ListJobsPageScreen> {
  late Future<List<dynamic>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = fetchUserJobs(); // gọi Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Jobs")),
      body: FutureBuilder<List<dynamic>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final jobs = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                var job = jobs[index];
                int matchPercent = ((job['Match (%)'] ?? 0) as num).toInt();

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    onTap: () {
                      // Nhấn mở chi tiết và có thể vuốt qua 10 job
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailPageScreen(job: jobs[index]),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['Job Title'] ?? 'No Title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Company: ${job['Company'] ?? 'N/A'}",
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Match: $matchPercent%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: matchColor(matchPercent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No jobs saved yet."));
          }
        },
      ),
    );
  }

  Color matchColor(int match) {
    if (match >= 80) return Colors.green;
    if (match >= 50) return Colors.orange;
    return Colors.red;
  }
}
