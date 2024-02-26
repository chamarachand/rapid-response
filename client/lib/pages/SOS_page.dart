import 'dart:ffi';

import 'package:flutter/material.dart';

class SOSpage extends StatefulWidget {
  const SOSpage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SOSpageState createState() => _SOSpageState();
}

class _SOSpageState extends State<SOSpage> {
  String _chosenModel = 'Accident'; // Initial value for the dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'SOS',
          style: TextStyle(
            color: Color.fromARGB(255, 70, 70, 70),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
// Camera Button
                    cameraButtonBuilder(),
                    const SizedBox(height: 30),
// Mic Button
                    micButtonBuilder(),
                    const SizedBox(
                      height: 30,
                    ),
// Drop Down
                    buildDropdownMenu(),
                    const SizedBox(height: 30),
// Not in the List Widget
                    buidTextField(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
// SOS Button
              SOSButtonWidget(),
              testWidget1()
            ],
          ),
        ),
      ),

// Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
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
            label: "History",
            icon: Icon(Icons.history),
          ),
        ],
      ),
    );
  }

// Camera Button
  Widget cameraButtonBuilder() => CircleAvatar(
      radius: 55,
      backgroundColor: const Color.fromARGB(255, 247, 147, 0),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.camera_alt),
        iconSize: 60,
        color: const Color.fromARGB(255, 43, 43, 43),
      ));

// Mic Button
  Widget micButtonBuilder() => CircleAvatar(
      radius: 55,
      backgroundColor: const Color.fromARGB(255, 247, 147, 0),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.mic),
        iconSize: 60,
        color: const Color.fromARGB(255, 43, 43, 43),
      ));

// Drop Down Widget
  Widget buildDropdownMenu() => Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 247, 147, 0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton<String>(
            focusColor: Colors.transparent,
            isExpanded: true,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            value: _chosenModel,
            items: <String>[
              'Accident',
              'Fludding',
              'Land Slide',
              'Flud1ding',
              'Fludd2ing',
              'Fluddi3ng',
              'Fluddin4g',
              'Fludding5',
              '1Fludding',
              'F2ludding',
              'Fl3udding',
              'Flu4dding',
              'Flud5ding',
              'Fludd6ing',
              'Fluddi7ng',
              'Fluddin7g',
              'Fluddin8g'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _chosenModel = newValue!;
              });
            },
            hint: const Text(
              "Emergency Type",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            dropdownColor: const Color.fromARGB(255, 247, 147, 0),
          ),
        ),
      );

// Not in the List Widget
  Widget buidTextField() => TextField(
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            hintText: "Not in the List",
            filled: true,
            fillColor: const Color.fromARGB(255, 247, 147, 0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      );

// SOS Button
  // ignore: non_constant_identifier_names
  Widget SOSButtonWidget() => ElevatedButton(
        onPressed: () {
          print("Hello World");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 247, 147, 0),
        ),
        child: const Text(
          'Send SOS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      );

  Widget testWidget1() => FloatingActionButton(
        onPressed: () {
          print("Hello World!");
        },
        child: const Text('Text'),
      );
}
