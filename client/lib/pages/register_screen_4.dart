import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:client/providers/registration_provider.dart';
import 'login_screen.dart';
import 'package:client/custom_widgets/label_text_register.dart';

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

  validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (!regex.hasMatch(value)) {
      if (value.length < 8) {
        return "Password must be at least 8 characters";
      }

      if (value.length > 255) {
        return "Password too long";
      }

      if (!value.contains(RegExp(r'[A-Z]'))) {
        return "Password should have atleast 1 uppercase letter";
      }

      if (!value.contains(RegExp(r'[a-z]'))) {
        return "Password should have atleast 1 lowercase letter";
      }

      if (!value.contains(RegExp(r'[0-9]'))) {
        return "Password should have atleast 1 digit";
      }

      if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
        return "Password should have atleast 1 special character";
      }
    }
    return null;
  }

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

  registerCivilian(RegistrationProvider provider) async {
    try {
      var response =
          await http.post(Uri.parse("http://10.0.2.2:3000/api/civilian"),
              headers: {
                'Content-Type': 'application/json', // Add this line
              },
              body: jsonEncode(provider.civilian));
      if (response.statusCode == 201) {
        //change this not to depend on the status code
        showSuccessAlertDialog();
      } else {
        showFailAlertDialog();
      }
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
                "You have been registered succesfully! Please continue with login.",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const LoginPage())));
                    },
                    child: const Text("OK")),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ));
  }

  void showUserExistsAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Username Exists!",
                style: TextStyle(fontSize: 20),
              ),
              content: const Text(
                "A user with the given username already exists. Please try another username",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(
                Icons.warning,
                color: Colors.yellow,
                size: 40,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
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

  void showPasswordPolicyDialog() {
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

  @override
  Widget build(BuildContext context) {
    final civilianProvider = Provider.of<RegistrationProvider>(context);

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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 18),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: const Color.fromARGB(255, 241, 228, 228),
                    filled: true,
                  ),
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
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: const Color.fromARGB(255, 241, 228, 228),
                      filled: true,
                      suffixIcon: GestureDetector(
                          onTap: () => showPasswordPolicyDialog(),
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: const Color.fromARGB(255, 241, 228, 228),
                      filled: true,
                    ),
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

                    civilianProvider.updateUser(
                      username: _usernameController.text,
                      password: _passwordController.text,
                    );
                    await registerCivilian(
                        civilianProvider); // check whether 'await' is necessary
                  },
                  child: const Text("Register"))
            ]),
          ),
        ),
      ),
    );
  }
}
