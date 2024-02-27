import 'package:client/pages/login_textfields.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  login() async {
    try {
      var response = await http.post(Uri.parse("http://10.0.2.2:3000/api/auth"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "username": usernameController.text.trim(),
            "password": passwordController.text.trim()
          }));

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        print("Got");
      } else if (response.statusCode == 401) {
        print("Invalid username or password");
      } else {
        print(response.body);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 153, 153, 1),
              Color.fromRGBO(255, 179, 179, 1),
              Color.fromRGBO(255, 204, 204, 1),
              Color.fromRGBO(255, 230, 230, 1),
              Color.fromRGBO(255, 255, 255, 1),
            ],
            stops: [0.2, 0.4, 0.6, 0.8, 1.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 20),
              //for username
              LoginTextFields(
                globalKey: _formKey,
                controller: usernameController,
                hintText: "Username",
                obsecureText: false,
              ),
              const SizedBox(height: 10),
              //for password
              LoginTextFields(
                globalKey: _formKey,
                controller: passwordController,
                hintText: "Password",
                obsecureText: true,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Fogot password?",
                      style: TextStyle(color: Color.fromARGB(255, 4, 47, 86)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(25.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor:
                            const Color.fromARGB(255, 165, 223, 249)),
                    child: const Center(
                        child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Color.fromARGB(255, 4, 47, 86),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
