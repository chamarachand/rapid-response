import 'package:client/providers/registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'register_screen_3.dart';

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

  @override
  Widget build(BuildContext context) {
    final civilianPrvider = Provider.of<RegistrationProvider>(context);

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
                controller: _fnameController,
                decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                controller: _lnameController,
                decoration: const InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                validator: (value) {
                  value = value!.trim();
                  if (value.isEmpty) return "This field is required";
                  if (value.length < 2) return "Last name too short";
                  if (value.length > 50) return "Last name too long";
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                controller: _nicnoController,
                decoration: const InputDecoration(
                    labelText: "NIC Number",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(r'\s')) // Prevent entering spaces
                ],
                validator: (value) {
                  value = value!.trim();
                  if (value.isEmpty) return "This field is required";
                  if (value.length < 9) {
                    return "Invalid NIC number";
                  }
                  return null;
                },
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)))
                      .toList(),
                  onChanged: (String? selectedGender) =>
                      {_genderController.text = selectedGender ?? ""},
                  validator: (value) =>
                      (value == null) ? "This field is required" : null,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                  controller: _birthdateController,
                  decoration: const InputDecoration(
                      labelText: "Date of Birth",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.calendar_month)),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) =>
                      (value == "") ? "This field is required" : null),
            ),
            ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  civilianPrvider.updateUser(
                      firstName: _fnameController.text,
                      lastName: _lnameController.text,
                      nicNumber: _nicnoController.text,
                      gender: _genderController.text,
                      dateOfBirth: DateTime.parse(_birthdateController
                          .text)); // check whether there is another way (ex: directly take as DateTime)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage3()));
                },
                child: const Text("Continue"))
          ]),
        ));
  }
}
