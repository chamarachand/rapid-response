import 'package:client/pages/link_accounts/first_responders/my_supervisees.dart';
import 'package:client/pages/link_accounts/first_responders/supervisee_requests.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/link_accounts/first_responders/search_firstresponders.dart';
import 'package:client/pages/link_accounts/first_responders/my_supervisors.dart';

class LinkAccountHomeFR extends StatefulWidget {
  const LinkAccountHomeFR({super.key});

  @override
  State<LinkAccountHomeFR> createState() => _LinkAccountHomeFRState();
}

class _LinkAccountHomeFRState extends State<LinkAccountHomeFR> {
  int _selectedIndex = 0;

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
                    title: const Text("My Supervisors"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const MySupervisors())));
                    },
                    tileColor: const Color(0xFFF7D8D8),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("My Supervisees"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const MySupervisees())));
                    },
                    tileColor: const Color(0xFFF7D8D8),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Supervisee Requests"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  const SuperviseeRequests())));
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
                "assets/supervisor.png",
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
                  builder: (context) => const FirstResponderSearchPage()));
        },
        backgroundColor: const Color(0xFFF7D8D8),
        tooltip: "Add Emergency Contact",
        child: const Icon(Icons.person_add_alt_sharp),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFD9D9D9),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {
                  _onItemTapped(0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LinkAccountHomeFR())));
                },
              ),
              label: 'Link',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
              label: 'History',
            ),
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
