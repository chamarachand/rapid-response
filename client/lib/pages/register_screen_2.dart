import 'dart:convert';
import 'package:client/providers/registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'register_screen_3.dart';
import 'package:client/custom_widgets/label_text_register.dart';
import 'package:client/custom_widgets/textformfield_decoration_register1.dart';
import 'package:client/pages/utils/user_type.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _nicnoController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 16, 1, 1),
      firstDate: DateTime(DateTime.now().year - 95, 1, 1),
      lastDate: DateTime(DateTime.now().year - 16, 12, 31),
    );

    if (picked != null) {
      setState(() {
        _birthdateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  validateNic() async {
    try {
      var response =
          await http.post(Uri.parse("http://10.0.2.2:3000/api/validate-nic"),
              headers: {
                'Content-Type': 'application/json', // Add this line
              },
              body: jsonEncode({
                "nicNo": _nicnoController.text,
                "gender": _genderController.text,
                "birthDay": _birthdateController.text
              }));
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        showFailAlertDialog();
        return false;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  uniqueNic() async {
    try {
      var response = await http.post(
          Uri.parse(
              "http://10.0.2.2:3000/api/validate-nic/is-unique?userType=${UserType.getUserType() == UserTypes.civilian ? "civilian" : "first-responder"}"),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "nicNo": _nicnoController.text,
          }));
      if (response.statusCode == 400) {
        return true;
      } else if (response.statusCode == 200) {
        showNicAlreadyExistsDialog();
        return false;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void showFailAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "NIC Validation Failed!",
                style: TextStyle(fontSize: 20),
              ),
              content: const Text(
                "Your given nic does not match with the gender or birthday",
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

  showNicAlreadyExistsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "A User with the given NIC Already Exists",
                style: TextStyle(fontSize: 20),
              ),
              content: const Text(
                "A User with the given NIC already exists in the system. If you already have an account, try login",
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
    // final civilianProvider = Provider.of<RegistrationProvider>(context);
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
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              Image.asset("assets/register.png", height: 75),
              const SizedBox(height: 10),
              const LabelTextRegister("First Name"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                  controller: _fnameController,
                  decoration: customInputDecoration(8, 15),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'^\s+|[^\sa-zA-Z]+|\s\s+'))
                  ],
                  validator: (value) {
                    value = value!
                        .trim(); // In a TextFormField f the user doesn't enter anything, the value returned will be an empty string "", not null.
                    if (value.isEmpty) return "This field is required";
                    if (value.length < 2) return "First name too short";
                    if (value.length > 50) return "First name too long";
                    return null;
                  },
                ),
              ),
              const LabelTextRegister("Last Name"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                  controller: _lnameController,
                  decoration: customInputDecoration(8, 15),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'^\s+|[^\sa-zA-Z]+|\s\s+'))
                  ],
                  validator: (value) {
                    value = value!.trim();
                    if (value.isEmpty) return "This field is required";
                    if (value.length < 2) return "Last name too short";
                    if (value.length > 50) return "Last name too long";
                    return null;
                  },
                ),
              ),
              const LabelTextRegister("NIC Number"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                  controller: _nicnoController,
                  decoration: customInputDecoration(8, 15),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s')) // Prevent entering spaces
                  ],
                  validator: (value) {
                    value = value!.trim();
                    if (value.isEmpty) return "This field is required";

                    RegExp format1 = RegExp(r'^\d{9}[Vv]$');
                    RegExp format2 = RegExp(r'^\d{12}$');

                    if (!format1.hasMatch(value) && !format2.hasMatch(value)) {
                      return "Invalid NIC number";
                    }
                    return null;
                  },
                ),
              ),
              const LabelTextRegister("Gender"),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: DropdownButtonFormField(
                    decoration: customInputDecoration(8, 15),
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                            value: gender, child: Text(gender)))
                        .toList(),
                    onChanged: (String? selectedGender) =>
                        {_genderController.text = selectedGender ?? ""},
                    validator: (value) =>
                        (value == null) ? "This field is required" : null,
                  )),
              const LabelTextRegister("Date of Birth"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                    controller: _birthdateController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: const Icon(Icons.calendar_month),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        fillColor: const Color.fromARGB(255, 241, 228, 228),
                        filled: true),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) =>
                        (value == "") ? "This field is required" : null),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    if (!await uniqueNic()) return;

                    if (!await validateNic()) return;

                    if (UserType.getUserType() == UserTypes.civilian) {
                      userProvider.updateCivilian(
                          firstName: _fnameController.text,
                          lastName: _lnameController.text,
                          nicNumber: _nicnoController.text,
                          gender: _genderController.text,
                          dateOfBirth:
                              DateTime.parse(_birthdateController.text));
                    } else if (UserType.getUserType() ==
                        UserTypes.firstResponder) {
                      userProvider.updateFirstResponder(
                          firstName: _fnameController.text,
                          lastName: _lnameController.text,
                          nicNumber: _nicnoController.text,
                          gender: _genderController.text,
                          dateOfBirth:
                              DateTime.parse(_birthdateController.text));
                    }

                    if (mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage3()));
                    }
                  },
                  child: const Text("Continue"))
            ]),
          ),
        ));
  }
}
