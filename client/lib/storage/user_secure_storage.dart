import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = const FlutterSecureStorage();

  static void setAccessToken(String token) async {
    await _storage.write(key: "accessToken", value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: "accessToken");
  }
}
