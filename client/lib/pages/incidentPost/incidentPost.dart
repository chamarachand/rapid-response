import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class incidentPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IncidentScreen(),
    );
  }
}

class Incident {
  final String title;
  final String description;

  Incident({required this.title, required this.description});
}

class IncidentScreen extends StatefulWidget {
  @override
  _IncidentScreenState createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  List<Incident> incidents = [];

  @override
  void initState() {
    super.initState();
    fetchIncidents();
  }

  Future<void> fetchIncidents() async {
    try {
      final response = await http.get(Uri.parse(
          'https://rapid-response-pi.vercel.app/api/posts/incidents/latest'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          incidents = jsonData
              .map((item) => Incident(
                    title: item['title'],
                    description: item['description'],
                  ))
              .toList();
        });
      } else {
        throw Exception('Failed to load incidents');
      }
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Incidents'),
      ),
      body: incidents.isNotEmpty
          ? ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                return ListTile(
                  title: Text(incident.title),
                  subtitle: Text(incident.description),
                  // Add more fields as needed
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
