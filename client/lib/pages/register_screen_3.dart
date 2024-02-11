import 'package:flutter/material.dart';

class RegisterPage3 extends StatefulWidget {
  const RegisterPage3({super.key});

  @override
  State<RegisterPage3> createState() => _RegisterPage3State();
}

class _RegisterPage3State extends State<RegisterPage3> {
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Text("Register"),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.person,
              size: 32,
            ),
          )
        ]),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextFormField(
            controller: _phonenoController,
            decoration: const InputDecoration(
                labelText: "Mobile No",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
            onPressed: () {
              print(_phonenoController.text);
              print(_emailController.text);
            },
            child: const Text("Continue"))
      ]),
    );
  }
}
