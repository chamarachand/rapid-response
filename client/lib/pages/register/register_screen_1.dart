import 'package:flutter/material.dart';
import 'register_screen_2.dart';
import 'package:client/pages/utils/user_type.dart';

class UserTypeSelection extends StatefulWidget {
  const UserTypeSelection({super.key});

  @override
  State<UserTypeSelection> createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  UserTypes? _selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8497B0),
        title: const Text('Select User Type'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: [
            Image.asset("assets/user-type.png"),
            RadioListTile(
              title: const Text(
                "Civilian",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("General User"),
              value: UserTypes.civilian,
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value;
                });
              },
            ),
            RadioListTile(
              title: const Text(
                "First Responder",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Police, Para Medic, Fire etc"),
              value: UserTypes.firstResponder,
              groupValue: _selectedUserType,
              onChanged: (value) {
                setState(() {
                  _selectedUserType = value;
                });
              },
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  UserType.setUserType(_selectedUserType);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage2()));
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
