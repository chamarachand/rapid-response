import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:client/providers/registration_provider.dart';

class RegisterPage4 extends StatefulWidget {
  const RegisterPage4({super.key});

  @override
  State<RegisterPage4> createState() => _RegisterScreen4State();
}

class _RegisterScreen4State extends State<RegisterPage4> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  registerCivilian(RegistrationProvider provider) async {
    print("Stepped");
    try {
      var response =
          await http.post(Uri.parse("http://10.0.2.2:3000/api/civilian"),
              headers: {
                'Content-Type': 'application/json', // Add this line
              },
              body: jsonEncode(provider.civilian));
      if (response.statusCode == 201) {
        showSuccessAlertDialog();
      } else {
        showFailAlertDialog();
        print(response.body);
      }
      print("Stepped out");
    } catch (e) {
      print("Error: $e");
    }
  }

  void showSuccessAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Registration Successful!",
                style: TextStyle(fontSize: 20),
              ),
              content: const Text(
                "You have been registered succesfully! Please verify your account.",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK")),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ));
  }

  void showFailAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Registration Failed!",
                style: TextStyle(fontSize: 20),
              ),
              content: const Text(
                "Registration unsuccessful! Please try again",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(
                Icons.close_rounded,
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

  @override
  Widget build(BuildContext context) {
    final civilianProvider = Provider.of<RegistrationProvider>(context);

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
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: "Select your username",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextFormField(
              controller: _passwordController,
              obscureText: true, //hide text
              decoration: const InputDecoration(
                  labelText: "Select a password",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextFormField(
              controller: _repasswordController,
              obscureText: true, //hide text
              decoration: const InputDecoration(
                  labelText: "Re-enter password",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always)),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
            onPressed: () async {
              civilianProvider.updateUser(
                username: _usernameController.text,
                password: _passwordController.text,
              );
              await registerCivilian(
                  civilianProvider); // check whether 'await' is necessary
            },
            child: const Text("Register"))
      ]),
    );
  }
}
