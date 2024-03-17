import 'register_screen_fr.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'register_screen_4.dart';
import 'package:client/providers/registration_provider.dart';
import 'package:client/custom_widgets/label_text_register.dart';
import 'package:client/custom_widgets/textformfield_decoration_register1.dart';
import 'package:client/pages/utils/user_type.dart';

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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/contact-info.png"),
                    const SizedBox(height: 10),
                    const LabelTextRegister("Phone Number"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                      child: TextFormField(
                        controller: _phonenoController,
                        keyboardType: TextInputType.number,
                        decoration: customInputDecoration(8, 18,
                            prefixIcon: Icon(Icons.phone)),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your phone number";
                          }
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
                        decoration: customInputDecoration(8, 18,
                            prefixIcon: Icon(Icons.email)),
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

                          if (UserType.getUserType() == UserTypes.civilian) {
                            userProvider.updateCivilian(
                              mobileNumber: _phonenoController.text,
                              email: _emailController.text,
                            );
                          } else if (UserType.getUserType() ==
                              UserTypes.firstResponder) {
                            userProvider.updateFirstResponder(
                              mobileNumber: _phonenoController.text,
                              email: _emailController.text,
                            );
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      (UserType.getUserType() ==
                                              UserTypes.civilian)
                                          ? const RegisterPage4()
                                          : const RegisterPageFR()));
                        },
                        child: const Text("Continue"))
                  ]),
            ),
          ),
        ));
  }
}
