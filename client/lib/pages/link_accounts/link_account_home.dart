import 'package:flutter/material.dart';

class LinkAccountHome extends StatefulWidget {
  const LinkAccountHome({super.key});

  @override
  State<LinkAccountHome> createState() => _LinkAccountHomeState();
}

class _LinkAccountHomeState extends State<LinkAccountHome> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Linked Accounts")),
      body: ListView(
        children: [
          ListTile(
            title: Text("My Emergency Contacts"),
            onTap: () {},
            tileColor: Colors.amber,
          ),
          ListTile(
            title: Text("Emergency Contact Requets"),
            onTap: () {},
            tileColor: Colors.amber,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFFF7D8D8),
        child: Icon(Icons.person_add_alt_sharp),
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
                          builder: ((context) => LinkAccountHome())));
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
