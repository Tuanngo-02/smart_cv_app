// dart
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
    _jobsFuture = fetchUserJobs();
  }

  String cleanCompanyName(String rawTitle) {
    String clean = rawTitle.replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '');
    clean = clean.replaceAll(RegExp(r'\d+\]'), '');
    clean = clean.replaceAll(RegExp(r'[\[\]]'), '');
    clean = clean.replaceAll(RegExp(r'https?://[^\s]+'), '');
    clean = clean.replaceAll(RegExp(r"'{2,}|\]{2,}"), '');
    clean = clean.replaceAll(RegExp(r'\\n'), ' ');
    clean = clean.replaceAll(RegExp(r'\n'), ' ');
    clean = clean.replaceAll(RegExp(r'\s+'), ' ');
    if (clean.contains('(')) {
      clean = clean.split('(')[0];
    }
    return clean.trim();
  }

  Color matchColor(int match) {
    if (match >= 80) return Colors.green;
    if (match >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double childAspectRatio = screenWidth > 600 ? 2.2 : 2.8;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Việc làm phù hợp",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: _jobsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Có lỗi xảy ra: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final jobs = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(jobs[index]);
                },
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.work_off_outlined, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Chưa có việc làm nào được lưu.", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildJobCard(var job) {
    String rawTitle = job['Job Title'] ?? 'No Title';
    String cleanTitle = cleanCompanyName(rawTitle);
    int matchPercent = ((job['Match (%)'] ?? 0) as num).toInt();

    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
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
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cleanTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.business, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            job['Company'] ?? 'N/A',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "$matchPercent%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: matchColor(matchPercent),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: matchPercent / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey[200],
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
    );
  }
}
