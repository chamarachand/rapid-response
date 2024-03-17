import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title, String content, Icon icon) {
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
            icon: const Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 40,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"))
            ],
            actionsAlignment: MainAxisAlignment.center,
          ));
}
