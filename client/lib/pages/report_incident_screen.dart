import 'dart:convert';
import 'dart:io';
import 'package:client/pages/SOS_page.dart';
import 'package:client/pages/SpeechtoText.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const EdgeInsets textFieldPadding = EdgeInsets.all(10);
  final TextEditingController _EventTypeController = TextEditingController();
  final TextEditingController _DescriptionController = TextEditingController();
  String imageUrl = '';
  File? image;
  String? capturedSpeech;
  late Position currentPosition;


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
              child: TextFormField(
                controller: _EventTypeController,
                decoration: const InputDecoration(
                    labelText: "Event Type",
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Speech_To_Text_Page(),
                    ),
                  ).then((capturedText) {
                    // capturedText will contain the speech captured from Speech_To_Text_Page
                    capturedSpeech = capturedText as String?;
                  });
                },
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
    final accessToken = await UserSecureStorage.getAccessToken();
    final decodedAccessToken = JwtDecoder.decode(accessToken!);
    final downloadUrl = await uploadImageToFirebase();
    currentPosition = await getLocation.getCurrentLocation();
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);


    if (downloadUrl != null) {
      // Prepare form data
      final Map<String, dynamic> IncidentReport = {
        'victimId': decodedAccessToken["id"],
        'EventType' : _EventTypeController.text,
        'location': currentPosition,
        'image': downloadUrl, // Assuming Firebase returns the URL
        'voice': capturedSpeech,
        'description': _DescriptionController.text,
        'timeStamp': currentDate,
      };

      print(IncidentReport);
      print(IncidentReport["time"].runtimeType);

      // Send POST request using http package
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/incident-report/create-incident'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(IncidentReport),
      );

      if (response.statusCode == 201) {
        // Handle successful event creation (show a success message, navigate, etc.)
        print('Event created successfully!');
      } else {
        // Handle error (show an error message)
        print('Error creating event: ${response.statusCode}');
      }
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

