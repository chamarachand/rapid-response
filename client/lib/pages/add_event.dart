import 'dart:convert';
import 'dart:io';
import 'package:client/pages/google_map.dart';
import 'package:client/pages/main_page/main_screen_fr.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';

class add_event extends StatefulWidget {
  const add_event({super.key});

  @override
  State<add_event> createState() => _addEventState();
}

class _addEventState extends State<add_event> {
  int _selectedIndex = 1; // variable used by ButtomNavigationBar
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _EventTypeController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _DescriptionController = TextEditingController();

  String imageUrl = '';
  File? image;

  Future<void> _selectDateTime(BuildContext context) async {
    // Combine date picker and time picker interactions
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set initial date to current date
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2036, 12, 31),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine date and time into a single DateTime variable
        final selectedDateTime = DateTime(
          pickedDate!.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime!.hour,
          pickedTime.minute,
        );

        // Update your UI or store the selectedDateTime variable
        setState(() {
          // You can adjust the format as needed (e.g., 'yyyy-MM-dd HH:mm')
          _dateTimeController.text = selectedDateTime.toString();
        });
      }
    }
  }

  static const EdgeInsets textFieldPadding = EdgeInsets.all(10);
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text("ADD Event"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
              child: TextFormField(
                  controller: _dateTimeController,
                  decoration: const InputDecoration(
                      labelText: "Select Date and Time",
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.calendar_month)),
                  readOnly: true,
                  onTap: () => _selectDateTime(context),
                  validator: (value) =>
                      (value == "") ? "This field is required" : null),
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
                  /*Navigator.push(
                context, MaterialPageRoute(builder: (context) => MapScreen()));*/
                },
                child: const Text('+ add Location to map'),
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
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: textFieldPadding,
                    child: ElevatedButton(
                      onPressed: _submitIncident,
                      child: const Text("Cancel"),
                    ),
                  ),
                  Container(
                    padding: textFieldPadding,
                    child: ElevatedButton(
                      onPressed: _submitIncident,
                      child: const Text("Add Event"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // applying navi bar using buildBottomNavigationBar()
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        true, // passing as true since page belogs to FR
      ),
    );
  }

  // creating method to change selected index on tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _submitIncident() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final decodedAccessToken = JwtDecoder.decode(accessToken!);
    final downloadUrl = await uploadImageToFirebase();

    if (downloadUrl != null) {
      // Prepare form data
      final Map<String, dynamic> eventData = {
        'addedBy': decodedAccessToken["id"],
        'eventType': _EventTypeController.text,
        'date': _dateTimeController.text,
        'time': _dateTimeController.text,
        'description': _DescriptionController.text,
        'image': downloadUrl, // Assuming Firebase returns the URL
      };

      print(eventData);
      print(eventData["time"].runtimeType);

      // Send POST request using http package
      final response = await http.post(
        Uri.parse(
            'https://rapid-response-pi.vercel.app/api/area-event/create-area-event'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(eventData),
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
    switch (index) {
      case 0:
        // Navigate to the Home screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainMenuFR()), // Replace with your Home screen widget
        );
        break;
      /* case 1:
      // Navigate to the Link screen (replace with your desired screen)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LinkScreen()), // Replace with your Link screen widget (optional)
      );
      break;
    case 2:
      // Navigate to the History screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryScreen()), // Replace with your History screen widget
      );
      break;  */
    }
  }

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
    final imagesRef = storageRef.child("Add_Event/${DateTime.now()}.jpg");

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
