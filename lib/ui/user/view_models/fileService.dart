import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'fileWeb.dart';

Future<Map<String, dynamic>?> sendCvJdFiles({
  required PlatformFile cvFile,
  required PlatformFile jdFile,
}) async {
  try {
    final isWeb = kIsWeb;

    final uri = Uri.parse(isWeb
        ? "http://127.0.0.1:8000/analyze/"
        : "http://10.0.2.2:8000/analyze/");

    var request = http.MultipartRequest("POST", uri);

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
    var response = await request.send();

    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      print(respStr);
      var jsonResp = json.decode(respStr);
      print(jsonResp);
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
  String fileName = fullPath.split(r"\").last;
  final url = "http://10.0.2.2:8000/download/$fileName";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Directory dir = await getTemporaryDirectory();
    File file = File('${dir.path}/$fileName');
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
