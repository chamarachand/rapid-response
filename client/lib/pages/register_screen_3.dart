import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'register_screen_4.dart';
import 'package:client/providers/registration_provider.dart';

class RegisterPage3 extends StatefulWidget {
  const RegisterPage3({super.key});

  @override
  State<RegisterPage3> createState() => _RegisterPage3State();
}

class _RegisterPage3State extends State<RegisterPage3> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
        body: Form(
          key: _formKey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                controller: _phonenoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Mobile No",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null) return "Please enter your phone number";
                  if (value.length != 10) {
                    return "Please enter a valid phone number";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                validator: (value) {
                  return EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email address";
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  civilianProvider.updateUser(
                    mobileNumber: _phonenoController.text,
                    email: _emailController.text,
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage4()));
                },
                child: const Text("Continue"))
          ]),
        ));
  }
}
