import 'package:client/pages/incidentPost/SOS.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/incidentPost/incidentPost.dart';
import 'package:client/pages/incidentPost/incidentPostPage.dart';

class NavigationIncident extends StatefulWidget {
  const NavigationIncident({super.key});

  @override
  _NavigationIncidentState createState() => _NavigationIncidentState();
}

class _NavigationIncidentState extends State<NavigationIncident> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        title: null,
        backgroundColor: Color.fromARGB(255, 244, 198, 198),
      ),
      body: Column(
        children: [
          const SizedBox(height: 2),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: const Text("Incident Post"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const IncidentPostPage()),
                        ),
                      );
                    },
                    tileColor: const Color(0xFFF7D8D8),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("SOS"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => SOS ()),
                        ),
                      );
                    },
                    tileColor: const Color(0xFFF7D8D8),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
