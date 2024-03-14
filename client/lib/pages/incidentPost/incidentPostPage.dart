// ignore: file_names
import 'package:flutter/material.dart';

class IncidentPostPage extends StatefulWidget {
  const IncidentPostPage({super.key});

  @override
  State<IncidentPostPage> createState() => IncidentPost();
}

class IncidentPost extends State<IncidentPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Incidents',
          style: TextStyle(
            color: Color.fromARGB(255, 70, 70, 70),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle(),
              incidentTitle()
            ],
          ),
        ),
      ),
    );
  }

  Widget incidentTitle() => Container(
        margin: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60.0),
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0))),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => popupWindow(),
            );
          },
          child: const Text('HELLO WORLD HELLO WORLD HELLO WORLD'),
        ),
      );

  Widget popupWindow() => Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // Add a border and shadow for visual clarity
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            const Text("THE INCIDENT POST GOES HERE"),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                iconSize: 30.0,
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      );
}
