import 'package:client/providers/registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_screen_3.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
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
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
              controller: _fnameController,
              decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    {_genderController.text = selectedGender ?? ""}),
          ),
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
            ),
          ),
          ElevatedButton(
              onPressed: () {
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
        ]));
  }
}
