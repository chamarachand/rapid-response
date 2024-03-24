import 'package:client/pages/link_accounts/civilians/search_civilian.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/link_accounts/civilians/my_emergency_contacts.dart';
import 'package:client/pages/link_accounts/civilians/emergency_contact_requests.dart';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';

class LinkAccountHome extends StatefulWidget {
  const LinkAccountHome({super.key});

  @override
  State<LinkAccountHome> createState() => _LinkAccountHomeState();
}

class _LinkAccountHomeState extends State<LinkAccountHome> {
  int _selectedIndex = 0;  // value used to indicated selected button of buttom navi bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
          title: const Text("Linked Accounts"),
          backgroundColor: const Color(0xFFadd8e6)),
      body: Column(
        children: [
          const SizedBox(height: 2),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: const Text("My Emergency Contacts"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  const MyEmergencyContacts())));
                    },
                    tileColor: const Color(0xFFF7D8D8),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Emergency Contact Requests"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  EmergencyContactRequests())));
                    },
                    tileColor: const Color(0xFFF7D8D8),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                bottom: 30), // Try to use a better approach
            child: Center(
              child: Image.asset(
                "assets/family.png",
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CivilianSearchPage()));
        },
        backgroundColor: const Color(0xFFF7D8D8),
        tooltip: "Add Emergency Contact",
        child: const Icon(Icons.person_add_alt_sharp),
      ),
      // calling buildBottomNavigationBar() to create buttom navigation bar s
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        false,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
