import 'package:flutter/material.dart';

class SOSpage extends StatefulWidget {
  const SOSpage({Key? key}) : super(key: key);

  @override
  _SOSpageState createState() => _SOSpageState();
}

class _SOSpageState extends State<SOSpage> {
  String _chosenModel = 'Accident'; // Initial value for the dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            children: <Widget>[
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color.fromARGB(255, 235, 235, 235),
                child: Icon(
                  Icons.camera_alt,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color.fromARGB(255, 235, 235, 235),
                child: Icon(Icons.mic, size: 60, color: Colors.grey),
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButton<String>(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                value: _chosenModel,
                items: <String>['Accident', 'Fludding', 'Land Slide']
                    .map((String value) {
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
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                dropdownColor: const Color.fromARGB(228, 200, 200, 255),
              )
            ],
          ),
        ),
      ),
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
}
