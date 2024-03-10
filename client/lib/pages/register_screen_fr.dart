import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/registration_provider.dart';
import 'package:client/pages/register_screen_4.dart';
import 'package:client/custom_widgets/label_text_register.dart';
import 'package:client/custom_widgets/textformfield_decoration_register1.dart';

class RegisterPageFR extends StatefulWidget {
  const RegisterPageFR({super.key});

  @override
  State<RegisterPageFR> createState() => _RegisterScreenFRState();
}

class _RegisterScreenFRState extends State<RegisterPageFR> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _workIdController = TextEditingController();
  final TextEditingController _workAddressController = TextEditingController();

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
              Image.asset("assets/first-responders.png"),
              const LabelTextRegister("First Responder Type"),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: DropdownButtonFormField(
                    decoration: customInputDecoration(8, 15),
                    hint: const Text(
                      "Select First Responder Type",
                    ),
                    items: ['Police', 'Paramedic', 'Fire']
                        .map((gender) => DropdownMenuItem(
                            value: gender, child: Text(gender)))
                        .toList(),
                    onChanged: (String? selectedGender) =>
                        {_typeController.text = selectedGender ?? ""},
                    validator: (value) =>
                        (value == null) ? "This field is required" : null,
                  )),
              const LabelTextRegister("Work ID"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                  controller: _workIdController,
                  decoration: customInputDecoration(8, 15),
                  validator: (value) {
                    value = value!.trim();
                    if (value.isEmpty) return "This field is required";
                    if (value.length < 2) return "Invalid woork id";
                    if (value.length > 50) return "Invalid woork id";
                    return null;
                  },
                ),
              ),
              const LabelTextRegister("Work Place (Address)"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: TextFormField(
                    controller: _workAddressController,
                    decoration: customInputDecoration(8, 15,
                        hintText: "Ex: Gampaha Police Station"),
                    validator: (value) => (value!.trim() == "")
                        ? "This field cannot be emtpy"
                        : null),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    userProvider.updateFirstResponder(
                        type: _typeController.text,
                        workId: _workIdController.text,
                        workAddress: _workAddressController.text);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage4()));
                  },
                  child: const Text("Continue"))
            ]),
          ),
        ),
      ),
    );
  }
}
