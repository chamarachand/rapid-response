// ignore: file_names
import 'package:flutter/material.dart';

class IncidentPostPage extends StatefulWidget {
  const IncidentPostPage({super.key});

  @override
  State<IncidentPostPage> createState() => IncidentPost();
}

class IncidentPost extends State<IncidentPostPage> {
  int counter = 0; // State variable to track the counter

  // Function to increment the counter and update the UI
  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
