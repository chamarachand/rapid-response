import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static void setAccessToken(String token) async {
    await _storage.write(key: "accessToken", value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: "accessToken");
  }

  static void deleteAccessToken() async {
    await _storage.delete(key: "accessToken");
  }

  static void setIdToken(String token) async {
    await _storage.write(key: "idToken", value: token);
  }

  static Future<String?> getIdToken() async {
    return await _storage.read(key: "idToken");
  }

  static void deleteIdToken() async {
    await _storage.delete(key: "idToken");
  }
}
