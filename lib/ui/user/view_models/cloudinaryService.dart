import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:smartCv_app/config/CloudinaryConfig.dart';

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
      return res.secureUrl;
    } on CloudinaryException catch (e) {
      debugPrint('Cloudinary upload error: ${e.message}');
      return null;
    }
  }
}
