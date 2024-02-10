import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome Page"),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                child: const Text("Login"))
          ],
        ));
  }
}
