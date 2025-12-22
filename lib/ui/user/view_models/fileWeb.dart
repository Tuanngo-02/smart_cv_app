import 'package:web/web.dart' as web;

Future<void> downloadPdfWeb(String fullPath) async {
  final fileName = fullPath.split(r"\").last;
  final url = "http://127.0.0.1:8000/download/$fileName";

  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName
    ..click();
}
