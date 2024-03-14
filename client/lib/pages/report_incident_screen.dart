import 'dart:io';
<<<<<<< Updated upstream
=======
import 'package:client/pages/SOS_page.dart';
import 'package:client/pages/SpeechtoText.dart';
>>>>>>> Stashed changes
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:speech_to_text/speech_to_text.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const EdgeInsets textFieldPadding = EdgeInsets.all(10);
  final TextEditingController _DescriptionController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
   
  String imageUrl = '';
  File? image;
  late Position USer_Current_Position;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
    });
  }

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
                onPressed: () {
                   showDialog(
                   context: context,
                  builder: (BuildContext context) => Speechtotext()
                  );
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
    USer_Current_Position = await getLocation.getCurrentLocation();
    print(USer_Current_Position);

    final downloadUrl = await uploadImageToFirebase();

            if (downloadUrl != null) {
              print("Incident Report Photo sent with image: $downloadUrl");
            }
  }

  void _onBottomNavBarItemTapped(int index) {
    // Implement navigation logic based on the selected bottom navigation bar item
    // You can use Navigator to push or pop screens based on the selected index
  }
  Widget Speechtotext() {
  return AlertDialog(
    title: Text(
      'Speech to Text',
      style: TextStyle(color: Colors.black),
    ),
    content: Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            _speechToText.isListening
                ? "listening..."
                : _speechEnabled
                    ? "Tap the microphone to start listening..."
                    : "Speech not available",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Text(
              _wordsSpoken,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
        backgroundColor: Colors.red, // Customize color as needed
        foregroundColor: Colors.white, // Customize foreground color as needed
      ),
    ],
  );
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

