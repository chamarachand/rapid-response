import 'package:client/pages/Signin%20_button.dart';
import 'package:client/pages/login_textfields.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

//user sign in method
  //void signUserIn(){}

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
                key: _formKey,
                controller: usernameController,
                hintText: "Enter user name?",
                obsecureText: false,
              ),
              const SizedBox(height: 10),
              //for password
              LoginTextFields(
                key: _formKey,
                controller: passwordController,
                hintText: "Enter password?",
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
              //sign in button
              const signin_button(),
            ],
          ),
        ),
      ),
    );
  }
}
