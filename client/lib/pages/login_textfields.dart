import 'package:flutter/material.dart';

class LoginTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final GlobalKey globalKey;

  const LoginTextFields(
      this.controller, this.hintText, this.obsecureText, this.globalKey,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        key: globalKey,
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
