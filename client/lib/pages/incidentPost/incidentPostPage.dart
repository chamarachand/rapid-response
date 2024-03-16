import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:client/pages/incidentPost/GmapOpen.dart';

class IncidentPostPage extends StatefulWidget {
  const IncidentPostPage({Key? key}) : super(key: key);

  @override
  State<IncidentPostPage> createState() => PurposeState();
}

class PurposeState extends State<IncidentPostPage> {
  double _currentSliderValue = 0.0;

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
                  borderRadius: BorderRadius.circular(10.0))),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => popupWindow(context),
            );
          },
          child: const Text(
            'HELLO WORLD HELLO WORLD HELLO WORLD',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Widget popupWindow(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor:
            Colors.transparent, // Make dialog background transparent
        child: Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255)
                      .withOpacity(1.0), // Adjust opacity as needed
                ),
              ),
            ),
            // Popup content
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(5.0),
                child: contentInPopup(),
              ),
            ),
          ],
        ),
      );

  Widget contentInPopup() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  OpenGoogleMap openGoogleMap = OpenGoogleMap();
                  openGoogleMap.launchGoogleMaps();
                },
                child: const Text("Location"),
              ),
              IconButton(
                iconSize: 30.0,
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          Container(
            height: 200,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: ClipRRect(
              // Wrap the Image.network in a ClipRRect
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                'https://downloadscdn6.freepik.com/188544/10/9871.jpg?filename=abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai.jpg&token=exp=1710540628~hmac=942da11c44f9b7968addf796ff9c8e66',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromARGB(255, 223, 223, 223),
            ),
            child: Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded),
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentSliderValue,
                      max: 100.0,
                      divisions: 100,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    " $_currentSliderValue",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromARGB(255, 207, 207, 207),
            ),
            child: const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      );
}

void main() {
  runApp(MaterialApp(
    home: IncidentPostPage(),
  ));
}
