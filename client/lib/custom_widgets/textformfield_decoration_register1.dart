import 'package:flutter/material.dart';

InputDecoration customInputDecoration(
    double borderRadius, double verticalPadding,
    {prefixIcon, suffixIcon, hintText}) {
  return InputDecoration(
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 10, vertical: verticalPadding),
      hintText: hintText,
      fillColor: const Color.fromARGB(255, 241, 228, 228),
      filled: true,
      suffixIcon: suffixIcon);
}
