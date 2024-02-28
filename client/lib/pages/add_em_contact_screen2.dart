import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  final dynamic _user;
  const AddUserPage(this._user, {super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: Text(widget._user["firstName"] + " " + widget._user["lastName"]),
        title: const Row(
          children: [
            Text("Add as Emergency Contact", style: TextStyle(fontSize: 18)),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.people, size: 30),
            )
          ],
        ),
        backgroundColor: const Color(0xFFadd8e6),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29uJTIwYXZhdGFyfGVufDB8fDB8fHww"),
            radius: 70,
          ),
          const SizedBox(height: 20),
          Text(
            widget._user["firstName"] + " " + widget._user["lastName"],
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(widget._user["username"]),
          const SizedBox(height: 40),
          ElevatedButton(
            // Move this logic later to the MaterialApp, ThemeData
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC06565),
                foregroundColor: Colors.white),
            child: const Text("Send Request"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC06565),
                  foregroundColor: Colors.white),
              child: const Text("Cancel"))
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            label: "Link",
            icon: Icon(Icons.link),
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
