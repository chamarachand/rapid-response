import 'dart:convert';

import 'package:client/pages/login_textfields.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 153, 153, 1),
              Color.fromRGBO(255, 179, 179, 1),
              Color.fromRGBO(255, 204, 204, 1),
              Color.fromRGBO(255, 230, 230, 1),
              Color.fromRGBO(255, 255, 255, 1),
            ],
            stops: [0.2, 0.4, 0.6, 0.8, 1.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 100,
              ),
              SizedBox(height: 20),
              //for username
              login_textfields(),
              const SizedBox(height: 10),
              //for password
              login_textfields(),
            ],
          ),
        ),
      ),
    );
  }
}
