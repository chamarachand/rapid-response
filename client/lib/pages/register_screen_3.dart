import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'register_screen_4.dart';
import 'package:client/providers/registration_provider.dart';
import 'package:client/custom_widgets/label_text_register.dart';

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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset("assets/contact-info.png"),
              const SizedBox(height: 10),
              const LabelTextRegister("Phone Number"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                  controller: _phonenoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: const Color.fromARGB(255, 241, 228, 228),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 18),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) return "Please enter your phone number";
                    if (value.length != 10) {
                      return "Please enter a valid phone number";
                    }
                    return null;
                  },
                ),
              ),
              const LabelTextRegister("Email"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: const Color.fromARGB(255, 241, 228, 228),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s')) // Prevent entering spaces
                  ],
                  validator: (value) {
                    return EmailValidator.validate(value!)
                        ? null
                        : "Please enter a valid email address";
                  },
                ),
              ),
              const SizedBox(height: 10),
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
          ),
        ));
  }
}
