import 'package:flutter/material.dart';

class LoginTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final GlobalKey globalKey;

  const LoginTextFields(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obsecureText,
      required this.globalKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
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
