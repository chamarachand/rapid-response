import 'package:flutter/material.dart';

InputDecoration customInputDecoration() {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    fillColor: const Color.fromARGB(255, 240, 217, 217),
    filled: true,
  );
}
