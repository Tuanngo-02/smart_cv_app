import 'package:flutter/material.dart';

// Đảm bảo đường dẫn import đúng với project của bạn
import '../view_models/resultService.dart';
import 'jobDetailPage_screen.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required topJobs});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<List<dynamic>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = fetchUserJobs(); // Gọi API/Firebase từ service
  }

  /// HÀM XỬ LÝ DỮ LIỆU: Tách Title và Thông tin phụ (Lương/Kinh nghiệm)
  /// Input: "Nhân Viên Kinh Doanh (Thu Nhập 15-30tr) 0](link...)"
  /// Output: {'title': "Nhân Viên Kinh Doanh", 'extra': "Thu Nhập 15-30tr"}
  Map<String, String> cleanJobTitle(String rawTitle) {
    // 1. Xóa các ký tự rác Markdown/HTML artifacts (ví dụ: [0](link...))
    String clean = rawTitle.replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '');
    clean = clean.replaceAll(RegExp(r'\d+\]'), ''); // Xóa các số dạng 0]

    // 2. Tách thông tin trong dấu ngoặc ()
    if (clean.contains('(')) {
      List<String> parts = clean.split('(');
      String mainTitle = parts[0].trim();

      // Lấy phần trong ngoặc và xóa dấu đóng ngoặc ')'
      String extraInfo = parts.length > 1
          ? parts[1].replaceAll(')', '').trim()
          : '';

      return {
        'title': mainTitle,
        'extra': extraInfo // Đây thường là lương hoặc yêu cầu
      };
    }

    // Trường hợp không có ngoặc, trả về nguyên gốc đã làm sạch
    return {'title': clean.trim(), 'extra': ''};
  }

  /// HÀM MÀU SẮC CHO ĐỘ KHỚP
  Color matchColor(int match) {
    if (match >= 80) return Colors.green;
    if (match >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    double screenWidth = MediaQuery.of(context).size.width;

    // Logic Responsive:
    // Nếu chiều rộng > 900px (Web rộng): 3 cột
    // Nếu chiều rộng > 600px (Tablet/Web nhỏ): 2 cột
    // Còn lại (Mobile): 1 cột
    int crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);

    // Điều chỉnh tỷ lệ khung hình (width / height) của Card tùy theo số cột
    // Số càng nhỏ thì Card càng cao.
    double childAspectRatio = screenWidth > 600 ? 2.2 : 2.8;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Màu nền xám nhẹ hiện đại
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
      body: FutureBuilder<List<dynamic>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Có lỗi xảy ra: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final jobs = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400, // Chiều rộng tối đa của mỗi Card
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio, // Tỷ lệ Card
              ),
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: crossAxisCount, // Số cột linh hoạt
              //   crossAxisSpacing: 16,
              //   mainAxisSpacing: 16,
              //   childAspectRatio: childAspectRatio, // Tỷ lệ Card
              // ),
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
    );
  }

  /// WIDGET CON: Hien thi 1 Card Job
  Widget _buildJobCard(var job) {
    // 1. Xử lý dữ liệu đầu vào
    String rawTitle = job['Job Title'] ?? 'No Title';
    Map<String, String> info = cleanJobTitle(rawTitle); // Tách title và extra
    int matchPercent = ((job['Match (%)'] ?? 0) as num).toInt();

    return Card(
      elevation: 2, // Đổ bóng nhẹ
      color: Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- PHẦN TRÊN: Title & Company ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title (Đã làm sạch)
                    Text(
                      info['title']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800, // In đậm mạnh
                        fontSize: 16, // Kích thước vừa phải
                        color: Color(0xFF2C3E50), // Màu xanh đen đậm
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Company Name
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
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // --- PHẦN DƯỚI: Info & Match ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag thông tin phụ (Lương/Kinh nghiệm - phần tách được)
                    if (info['extra']!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[50], // Nền xanh nhạt
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Text(
                          info['extra']!, // Ví dụ: "15-30tr/Tháng"
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Thanh Match % (Progress Bar)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}