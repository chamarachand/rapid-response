import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const EdgeInsets textFieldPadding = EdgeInsets.all(10);
  ImageProvider? image;
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text("Incident Report"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: textFieldPadding,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.black,
                  fixedSize: const Size(1000, 50)),
              onPressed: pickImage,
              child: const Text('+ add Image'),
            ),
          ),
          Container(
            padding: textFieldPadding,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.black,
                  fixedSize: const Size(1000, 50)),
              onPressed: add_video,
              child: const Text('+ add Video'),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: textFieldPadding,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.black,
                  fixedSize: const Size(1000, 50)),
              onPressed: add_voice,
              child: const Text('+ add Voice'),
            ),
          ),
          Container(
            padding: textFieldPadding,
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Description",
              ),
            ),
          ),
          Container(
            padding: textFieldPadding,
            child: ElevatedButton(
              onPressed: _submitIncident,
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Link",
            icon: Icon(Icons.link),
          ),
          BottomNavigationBarItem(
            label: "History",
            icon: Icon(Icons.history),
          ),
        ],
        onTap: _onBottomNavBarItemTapped,
      ),
    );
  }

  void _submitIncident() {
    // Implement your incident submission logic here
    // This function will be called when the submit button is pressed
  }

  void _onBottomNavBarItemTapped(int index) {
    // Implement navigation logic based on the selected bottom navigation bar item
    // You can use Navigator to push or pop screens based on the selected index
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        image = FileImage(File(imageFile.path));
      });
    }
  }

  void add_video() {}

  void add_voice() {}
}
