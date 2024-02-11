import 'package:flutter/material.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 16, 1, 1),
      firstDate: DateTime(DateTime.now().year - 95, 1, 1),
      lastDate: DateTime(DateTime.now().year - 16, 12, 31),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
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
                    {print('Gender: $selectedGender')}),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: "Date of Birth",
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.calendar_today)),
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
          )
        ]));
  }
}
