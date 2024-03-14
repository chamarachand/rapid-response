import 'package:flutter/material.dart';

class IncidentPostPage extends StatefulWidget {
  const IncidentPostPage({super.key});

  @override
  IncidentPostPage createState() => IncidentPostPage();
}

class incidentPage {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text(
        'Incident Post',
        style: TextStyle(
          color: Color.fromARGB(255, 70, 70, 70),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    ));
  }
}
