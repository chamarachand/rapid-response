import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:client/pages/welcome_screen.dart';
import 'package:client/pages/main_screen.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  Future<String?> _getToken() async {
    return await UserSecureStorage.getAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final token = snapshot.data;
          return token != null ? const MainMenu() : const WelcomePage();
        }
      },
    );
  }
}
