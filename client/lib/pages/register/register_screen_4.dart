import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:client/providers/registration_provider.dart';
import 'package:client/pages/login_screen.dart';
import 'package:client/custom_widgets/label_text_register.dart';
import 'package:client/pages/utils/user_type.dart';
import 'package:client/pages/utils/alert_dialogs.dart';
import 'package:client/pages/utils/validate_password.dart';
import 'package:client/custom_widgets/textformfield_decoration_authinfo.dart';

class RegisterPage4 extends StatefulWidget {
  const RegisterPage4({super.key});

  @override
  State<RegisterPage4> createState() => _RegisterScreen4State();
}

class _RegisterScreen4State extends State<RegisterPage4> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  final bool isCivilian = UserType.getUserType() == UserTypes.civilian;

  userExists(String username) async {
    try {
      var response = await http.get(
          Uri.parse("http://10.0.2.2:3000/api/civilian/checkUser/$username"),
          headers: {'Content-Type': 'application/json'});

      var data = jsonDecode(response.body);
      print("Reached");
      if (data['userExists']) {
        showUserExistsAlertDialog();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  registerUser(RegistrationProvider provider) async {
    try {
      var response = await http.post(
          Uri.parse(
              "http://10.0.2.2:3000/api/${isCivilian ? "civilian" : "first-responder"}"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              isCivilian ? provider.civilian : provider.firstResponder));
      if (response.statusCode == 201) {
        showSuccessAlertDialog();
      } else {
        showFailAlertDialog();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void showSuccessAlertDialog() {
    showAlertDialog(
      context,
      "Registration Successful!",
      "You have been registered succesfully! Please continue with login",
      const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 40,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const LoginPage())));
            },
            child: const Text("OK")),
      ],
    );
  }

  void showUserExistsAlertDialog() {
    showAlertDialog(
        context,
        "Username Exists",
        "A user with the given username already exists. Please try another username",
        const Icon(
          Icons.warning_rounded,
          color: Colors.orange,
          size: 40,
        ));
  }

  void showFailAlertDialog() {
    showAlertDialog(
        context,
        "Registration Failed",
        "Registration unsuccessful! Please try again",
        const Icon(
          Icons.warning_rounded,
          color: Colors.orange,
          size: 40,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEDF0F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8497B0),
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
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset("assets/security.png"),
              const LabelTextRegister("Enter Username"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: customInputDecorationAuth(),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  validator: (value) {
                    if (value!.isEmpty) return "This field is required";
                    if (value.startsWith(RegExp(r'\d'))) {
                      return "Username cannot start with a number";
                    }
                    if (value.length < 4) {
                      return "Username cannot be less than 4 characters";
                    }
                    return null;
                  },
                ),
              ),
              const LabelTextRegister("Enter Password"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true, //hide text
                  decoration: customInputDecorationAuth(
                      suffixIcon: GestureDetector(
                          onTap: () => showPasswordPolicyDialog(context),
                          child: const Icon(Icons.info_rounded))),
                  validator: (value) => (value!.isEmpty)
                      ? "Please enter a password"
                      : validatePassword(value),
                ),
              ),
              const LabelTextRegister("Re-Enter Password"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                    controller: _repasswordController,
                    obscureText: true, //hide text
                    decoration: customInputDecorationAuth(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please re-enter your password";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    if (await userExists(_usernameController.text)) return;

                    isCivilian
                        ? userProvider.updateCivilian(
                            username: _usernameController.text,
                            password: _passwordController.text,
                          )
                        : userProvider.updateFirstResponder(
                            username: _usernameController.text,
                            password: _passwordController.text,
                          );

                    await registerUser(userProvider);
                  },
                  child: const Text("Register"))
            ]),
          ),
        ),
      ),
    );
  }
}
