import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/analysisResultPage_screen.dart';

Future<Map<String, dynamic>?> sendCvJdFiles({
  required PlatformFile cvFile,
  required PlatformFile jdFile,
}) async {
  try {
    var uri = Uri.parse("http://10.0.2.2:8000/analyze/");
    var request = http.MultipartRequest("POST", uri);

    // Thêm file CV
    request.files.add(await http.MultipartFile.fromPath(
      "cv_file",
      cvFile.path!,
      filename: cvFile.name,
    ));

    // Thêm file JD
    request.files.add(await http.MultipartFile.fromPath(
      "jd_file",
      jdFile.path!,
      filename: jdFile.name,
    ));

    // Gửi request
    var response = await request.send();

    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      var jsonResp = json.decode(respStr);
      return jsonResp;
    } else {
      print("Error ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Exception sending files: $e");
    return null;
  }
}
Future<void> downloadPdf(String fullPath) async {
  String fileName = fullPath.split(r"\").last;
 print(fileName);
  final url = "http://10.0.2.2:8000/download/$fileName";
  print(url);
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/$fileName';
      File file = File(tempPath);
      await file.writeAsBytes(response.bodyBytes);
      await OpenFile.open(file.path);
    } else {
      print("Lỗi khi tải file: ${response.statusCode}");
    }
  } catch (e) {
    print("Exception khi tải file: $e");
  }
}
