import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:smartCv_app/config/CloudinaryConfig.dart';
final uid = FirebaseAuth.instance.currentUser!.uid;
class FirebaseFileService {
  static Future<bool> saveUserFile({
    required String fileUrl,
    required String fileName,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('files')
          .add({
        'fileUrl': fileUrl,
        'fileName': fileName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print(' Lỗi lưu file vào Firebase: $e');
      return false;
    }
  }
}
class CloudinaryService {
  static String buildFileName({required String email, required String type}) {
    final safeEmail = email.replaceAll(RegExp(r'[^a-zA-Z0-9@._-]'), '_');
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmm').format(now);
    return '$safeEmail-$type-$formattedDate';
  }

  static Future<String?> uploadPdf({
    required PlatformFile file,
    required String basePublicId,
  }) async {
    try {
      final publicId = '$basePublicId.pdf';
      CloudinaryFile cloudinaryFile;

      if (kIsWeb) {
        final bytes = file.bytes;
        if (bytes == null) return null;

        cloudinaryFile = CloudinaryFile.fromBytesData(
          bytes,
          identifier: publicId,
          publicId: publicId,
          resourceType: CloudinaryResourceType.Raw,
          folder: 'smart_cv',
        );
      } else {
        final path = file.path;
        if (path == null) return null;

        cloudinaryFile = CloudinaryFile.fromFile(
          path,
          identifier: publicId,
          publicId: publicId,
          resourceType: CloudinaryResourceType.Raw,
          folder: 'smart_cv',
        );
      }

      final res = await CloudinaryConfig.cloudinary.uploadFile(
        cloudinaryFile,
        uploadPreset: 'smart_cv',
      );
      String normalizeCloudinaryUrl(String url) {
        if (url.endsWith('link')) {
          return url.substring(0, url.length - 4);
        }
        return url;
      }
      try{
        final cleanUrl = normalizeCloudinaryUrl(res.secureUrl);
        await FirebaseFileService.saveUserFile(
          fileUrl: cleanUrl,
          fileName: publicId,
        );
        print(cleanUrl);
  }catch (exception) {
        print("lỗi lưu file vào firestore: $exception");
      }
    

      print(res.secureUrl + "link");
      return res.secureUrl;
    } on CloudinaryException catch (e) {
      debugPrint('Cloudinary upload error: ${e.message}');
      return null;
    }
  }
}
