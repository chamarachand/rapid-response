import 'package:flutter/material.dart';

class MyEmergencyContacts extends StatefulWidget {
  const MyEmergencyContacts({super.key});

  @override
  State<MyEmergencyContacts> createState() => _MyEmergencyContactsState();
}

class _MyEmergencyContactsState extends State<MyEmergencyContacts> {
  final List _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFadd8e6),
        title: const Row(children: [
          Text("Emergency Contacts"),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.people_alt_rounded,
              size: 32,
            ),
          )
        ]),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          var user = _users[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Card(
              child: Row(children: [
                Expanded(
                    child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"),
                  ),
                  title: Text(user["username"]),
                  subtitle: Text(user["firstName"] + " " + user["lastName"]),
                  // trailing: const Icon(Icons.open_in_new, size: 22),
                  onTap: () => {},
                )),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.open_in_new, size: 22))
              ]),
            ),
          );
        },
      ),
    );
  }
}
