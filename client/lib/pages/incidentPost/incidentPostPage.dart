import 'package:flutter/material.dart';
import 'package:client/pages/incidentPost/GmapOpen.dart';

class IncidentPostPage extends StatefulWidget {
  const IncidentPostPage({super.key});

  @override
  State<IncidentPostPage> createState() => purpose();
}

class purpose extends State<IncidentPostPage> {
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

  Widget popupWindow() => SingleChildScrollView(
        child: Container(
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
            child: contentInPopup()),
      );

  Widget contentInPopup() => Column(
        children: <Widget>[
          Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        backgroundColor: Colors.red),
                    onPressed: () async {
                      OpenGoogleMap openGoogleMap = OpenGoogleMap();
                      openGoogleMap.launchGoogleMaps();
                    },
                    child: const Text("Location")),
              ),
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
          const SizedBox(height: 40.0),
          Container(
            height: 200,
            child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/rapid-response-802d3.appspot.com/o/sos_images%2F2024-03-13%2008%3A31%3A28.207333.jpg?alt=media&token=e0b09ff3-8583-48c2-9b08-9b3be9fb2ae6'),
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color.fromARGB(255, 223, 223, 223)),
            child: Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow_rounded)),
                  Listener(
                    onPointerDown: (PointerDownEvent event) {},
                    onPointerMove: (PointerMoveEvent event) {
                      setState(() {
                        _currentSliderValue = event.position.dx;
                      });
                    },
                    onPointerUp: (PointerUpEvent event) {},
                    child: Slider(
                        value: _currentSliderValue,
                        max: 100.0,
                        divisions: 100,
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        }),
                  ),
                  Text(" $_currentSliderValue"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Colors.black),
                color: const Color.fromARGB(255, 207, 207, 207)),
            child: const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              style: TextStyle(color: Colors.black, fontSize: 19.0),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      );
}

class color {
  const color();
}
