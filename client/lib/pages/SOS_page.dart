import 'package:flutter/material.dart';

class SOSpage extends StatelessWidget {
  const SOSpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOS',
          style: TextStyle(
              color: Color.fromARGB(255, 70, 70, 70),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 55,
              backgroundColor: const Color.fromARGB(255, 235, 235, 235),
              child: Icon(Icons.camera_alt, size: 60, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 55,
              backgroundColor: const Color.fromARGB(255, 235, 235, 235),
              child: Icon(Icons.mic, size: 60, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: DropdownButton<String>(

                value: "Emergency Type",
                items: <String>["Emergency Type", "Fire", "Medical", "Police"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {},
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.pink[100],
                  hintText: "Not in the list? Type Here",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: ElevatedButton(
                onPressed: () {
                  print("Hello World");
                },
                child: const Text('Send SOS'),
              ),
            )
          ],
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
