
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  static final apiKey_web = dotenv.env['API_KEY_WEB'] ?? '';
  static final apiKey_ios = dotenv.env['API_KEY_IOS'] ?? '';
  static final apiKey_android = dotenv.env['API_KEY_ANDROID'] ?? '';
}
