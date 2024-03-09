import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const EdgeInsets textFieldPadding = EdgeInsets.all(10);
  final TextEditingController _DescriptionController = TextEditingController();
  List<Reference> _uploadedFiles = [];

  
   
  String imageUrl = '';
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text("Incident Report"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: textFieldPadding,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orange,
                    fixedSize: const Size(1000, 50)),
                onPressed: () {
                  showDialog(
                   context: context,
                  builder: (BuildContext context) => popup(),
                 );
                },
                child: const Text('+ add Image'),
              ),
            ),
            Container(
              padding: textFieldPadding,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orange,
                    fixedSize: const Size(1000, 50)),
                onPressed: () {},
                child: const Text('+ add Video'),
              ),
            ),
            Container(
              padding: textFieldPadding,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orange,
                    fixedSize: const Size(1000, 50)),
                onPressed: () {},
                child: const Text('+ add Voice'),
              ),
            ),
            Container(
              padding: textFieldPadding,
              child: TextFormField(
                controller: _DescriptionController,
                decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                validator: (value) {
                  value = value!
                      .trim(); // In a TextFormField f the user doesn't enter anything, the value returned will be an empty string "", not null.
                  if (value.isEmpty) return "This field is required";
                  return null;
                },
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

  Future<void> _submitIncident() async {
    final downloadUrl = await uploadImageToFirebase();

            if (downloadUrl != null) {
              // Do something with the downloadUrl, such as:
              //   - Send in the SOS message
              //   - Display success to the user
              print("Incident Report Photo sent with image: $downloadUrl");
            }
  }

  void _onBottomNavBarItemTapped(int index) {
    // Implement navigation logic based on the selected bottom navigation bar item
    // You can use Navigator to push or pop screens based on the selected index
  }

// Popup window when pressed camera icon
  Widget popup() => AlertDialog(
        title: const Text('Camera Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                // Code to handle taking a photo
                pickImage1(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                // Code to choose from gallery
                pickImage1(ImageSource.gallery);
              },
            ),
          ],
        ),
      );

  Future pickImage1(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

Future<String?> uploadImageToFirebase() async {
    if (image == null) return null; // Early exit if no image

    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("Incident_Report/${DateTime.now()}.jpg");

    try {
      await imagesRef.putFile(image!); // Upload!
      final downloadURL = await imagesRef.getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      // Handle errors (consider showing a dialog or a snackbar)
      print("Upload failed: $e");
      return null;
    }
  }

  
}

