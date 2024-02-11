import 'package:flutter/material.dart';

class RegisterScreen4 extends StatefulWidget {
  const RegisterScreen4({super.key});

  @override
  State<RegisterScreen4> createState() => _RegisterScreen4State();
}

class _RegisterScreen4State extends State<RegisterScreen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Text("Register"),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.app_registration,
              size: 32,
            ),
          )
        ]),
      ),
    );
  }
}
