import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'fileWeb_stub.dart' if (dart.library.html) 'fileWeb.dart';

Future<Map<String, dynamic>?> sendCvJdFiles({
  required PlatformFile cvFile,
  required PlatformFile jdFile,
}) async {
  try {
    final isWeb = kIsWeb;

    final uri = Uri.parse(isWeb
        ? "http://127.0.0.1:8000/analyze/"
        : "http://10.0.2.2:8000/analyze/");

    final request = http.MultipartRequest("POST", uri);

    if (isWeb) {
      request.files.add(http.MultipartFile.fromBytes(
        "cv_file",
        cvFile.bytes!,
        filename: cvFile.name,
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
        "cv_file",
        cvFile.path!,
        filename: cvFile.name,
      ));
    }
    if (isWeb) {
      request.files.add(http.MultipartFile.fromBytes(
        "jd_file",
        jdFile.bytes!,
        filename: jdFile.name,
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
        "jd_file",
        jdFile.path!,
        filename: jdFile.name,
      ));
    }
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonResp = json.decode(respStr);
      return jsonResp;
    } else {
      print("Error ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Upload Exception: $e");
    return null;
  }
}

Future<void> downloadPdfMobile(String fullPath) async {
  final fileName = fullPath.split(r"\").last;
  final url = "http://10.0.2.2:8000/download/$fileName";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    await OpenFile.open(file.path);
  }
}

Future<void> downloadPdf(String fullPath) async {
  if (kIsWeb) {
    await downloadPdfWeb(fullPath);
  } else {
    await downloadPdfMobile(fullPath);
  }
}
Future<Map<String, dynamic>?> sendCvJdLinks({
  required String cvUrl,
  required String jdUrl,
}) async {
  try {
    final isWeb = kIsWeb;

    final uri = Uri.parse(
      isWeb
          ? "http://127.0.0.1:8000/analyze-by-link/"
          : "http://10.0.2.2:8000/analyze-by-link/",
    );

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "cv_url": cvUrl, // ✅ GIỮ NGUYÊN LINK
        "jd_url": jdUrl, // ✅ GIỮ NGUYÊN LINK
      }),
    );

    if (response.statusCode == 200) {
      final jsonResp =
      jsonDecode(utf8.decode(response.bodyBytes))
      as Map<String, dynamic>;
      return jsonResp;
    } else {
      debugPrint(
        "sendCvJdLinks Error ${response.statusCode}: ${response.body}",
      );
      return null;
    }
  } catch (e) {
    debugPrint("sendCvJdLinks Exception: $e");
    return null;
  }
}


