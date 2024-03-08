import 'package:flutter/material.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  @override
  _UserTypeSelectionScreenState createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  String? _selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User Type'),
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
              value: "civilian",
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
              value: "first-responser",
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
                  // Handle user selection
                  print('Selected user type: $_selectedUserType');
                },
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
