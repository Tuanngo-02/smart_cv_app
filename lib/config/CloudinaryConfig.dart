import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryConfig {
  static final cloudinary = CloudinaryPublic(
    'draquaf7e', // cloud_name của bạn
    'smart_cv',  // upload preset của bạn
    cache: false,
  );
}
