import 'dart:convert';
import 'dart:io';
import 'package:client/pages/SOS_page.dart';
import 'package:client/pages/main_page/main_screen.dart';
import 'package:client/pages/utils/alert_dialogs.dart';
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
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  late Position
      currentPosition; // initiating value, will be change on _loadToken
  int _selectedIndex =
      1; // value used to indicated selected button of buttom navi bar
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Speechtotext(),
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
      // calling buildBottomNavigationBar() to create buttom navigation bar s
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        false,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        'eventType': _EventTypeController.text,
        'location': {
          // Assuming GeoJSON format
          'type': 'Point',
          'coordinates': [currentPosition.longitude, currentPosition.latitude],
        },
        'image': downloadUrl, // Assuming Firebase returns the URL
        'voice': _wordsSpoken,
        'description': _DescriptionController.text,
        'timeStamp': currentDate,
      };

      // Send POST request using http package
      final response = await http.post(
        Uri.parse(
            'https://rapid-response-pi.vercel.app/api/incident-report/create-incident'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': accessToken
        },
        body: jsonEncode(IncidentReport),
      );

      if (response.statusCode == 201) {
        // Handle successful event creation (show a success message, navigate, etc.)
        print('Event created successfully!');
        Map<String, dynamic> responseBody = json.decode(response.body);
        String incidentId = responseBody['incidentId'];
        showIncidentReportSendDialog();
        notifyFirstResponders(incidentId);
        notifyEmergencyContacts();
      } else {
        // Handle error (show an error message)
        print('Error creating event: ${response.body}');
      }
    }
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

  Widget Speechtotext() {
    return AlertDialog(
      title: Text(
        'Speech to Text',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        FloatingActionButton(
          onPressed:
              _speechToText.isListening ? _stopListening : _startListening,
          child: Icon(
            Icons.mic,
            color: Colors.white,
          ),
          backgroundColor: Colors.red, // Customize color as needed
          foregroundColor: Colors.white, // Customize foreground color as needed
        ),
      ],
    );
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
    });
    Navigator.pop(_wordsSpoken
        as BuildContext); // Pop the screen and return the captured speech
  }

  notifyFirstResponders(String incidentId) async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final idToken = await UserSecureStorage.getIdToken();
    final decodedIdToken = JwtDecoder.decode(idToken!);

    try {
      var response = await http.post(
          Uri.parse(
              "https://rapid-response-pi.vercel.app/api/notification/first-responder/send/incident-report/${incidentId}"),
          headers: {
            'Content-Type': 'application/json',
            if (accessToken != null) 'x-auth-token': accessToken,
          },
          body: jsonEncode({
            "type": "first-responder-notify-incident",
            "title": "Incident Report from a Nearby Contact",
            "body":
                "${decodedIdToken["firstName"]} ${decodedIdToken["lastName"]} just posted an incident Report"
          }));
      if (response.statusCode == 200) {
        print("Notification send to emergency contacts");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  notifyEmergencyContacts() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final idToken = await UserSecureStorage.getIdToken();
    final decodedIdToken = JwtDecoder.decode(idToken!);

    try {
      var response = await http.post(
          Uri.parse(
              "https://rapid-response-pi.vercel.app/api/notification/emergency-contacts/send"),
          headers: {
            'Content-Type': 'application/json',
            if (accessToken != null) 'x-auth-token': accessToken,
          },
          body: jsonEncode({
            "type": "emergency-contact-notify-incident",
            "title": "Incident Report Alert from Your Contact",
            "body":
                "${decodedIdToken["firstName"]} ${decodedIdToken["lastName"]} just posted a an incident Report"
          }));
      if (response.statusCode == 200) {
        print("Notification send to emergency contacts");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  showIncidentReportSendDialog() {
    showAlertDialog(
        context,
        "Incident Report Send Successfully",
        "Your incident report has has been sent successfully",
        const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 40,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainMenu())),
              child: const Text("OK")),
        ]);
  }
}
