import 'package:flutter/material.dart';

InputDecoration customInputDecorationContact() {
  return InputDecoration(
    prefixIcon: const Icon(Icons.phone),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    fillColor: const Color.fromARGB(255, 241, 228, 228),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
  );
}
