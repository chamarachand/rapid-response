import 'package:flutter/material.dart';

InputDecoration customInputDecorationAuth({suffixIcon}) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      fillColor: const Color.fromARGB(255, 241, 228, 228),
      filled: true,
      suffixIcon: suffixIcon);
}
