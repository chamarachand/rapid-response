import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title, String content, Icon icon,
    {List<TextButton>? actions}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
            ),
            icon: icon,
            actions: actions ??
                [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
            actionsAlignment: MainAxisAlignment.center,
          ));
}

void showPasswordPolicyDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text(
              "Password Policy",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            content: const Text(
              "To ensure the security of your account, please adhere to the following password conditions:\n\n"
              "\u2022 Password must be at least 8 characters long.\n"
              "\u2022 Password must contain characters from at least three of the following four categories:\n"
              "   - Uppercase letters (A-Z)\n"
              "   - Lowercase letters (a-z)\n"
              "   - Digits (0-9)\n"
              "   - Special characters (! @ # \$ % ^ & * ( ) , . ? \" : { } | < >)",
              // textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"))
            ],
            actionsAlignment: MainAxisAlignment.center,
          ));
}
