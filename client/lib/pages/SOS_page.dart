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
            children: <Widget>[
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color.fromARGB(227, 255, 78, 78),
                child: Icon(
                  Icons.camera_alt,
                  size: 60,
                  color: Color.fromARGB(255, 43, 43, 43),
                ),
              ),
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color.fromARGB(227, 255, 78, 78),
                child: Icon(Icons.mic,
                    size: 60, color: Color.fromARGB(255, 43, 43, 43)),
              ),
              const SizedBox(
                height: 30,
              ),
              FractionallySizedBox(
                alignment: Alignment.center,
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(227, 255, 78, 78),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: DropdownButton<String>(
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
                    dropdownColor: const Color.fromARGB(227, 255, 78, 78),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(227, 255, 78, 78),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Not in the list"),
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  print("Hello World");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(227, 255, 78, 78),
                ),
                child: const Text('Send SOS'),
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
