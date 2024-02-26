import 'package:flutter/material.dart';

class login_textfields extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obsecureText;

  const login_textfields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
        obscureText: obsecureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 19, 121, 204)),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
