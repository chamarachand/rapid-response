import 'package:flutter/material.dart';

class LinkAccountHome extends StatelessWidget {
  const LinkAccountHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Linked Accounts")),
      body: ListView(
        children: [
          ListTile(
            title: Text("My Emergency Contacts"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Emergency Contact Requets"),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
