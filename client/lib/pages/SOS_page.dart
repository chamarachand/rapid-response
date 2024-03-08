import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

class SOSpage extends StatefulWidget {
  const SOSpage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SOSpageState createState() => _SOSpageState();
}

class _SOSpageState extends State<SOSpage> {
  String _chosenModel = 'Accident'; // Initial value for the dropdown

  File? image;

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      // Camera Button
                      cameraButtonBuilder(),
                      const SizedBox(height: 30),
                      // Mic Button
                      micButtonBuilder(),
                      const SizedBox(
                        height: 30,
                      ),
                      // Drop Down
                      buildDropdownMenu(),
                      const SizedBox(height: 30),
                      // Not in the List Widget
                      buidTextField(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                // SOS Button
                testWidget1()
              ],
            ),
          ),
        ),
      ),

// Bottom Navigation Bar
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

// Camera Button
  Widget cameraButtonBuilder() => CircleAvatar(
      radius: 55,
      backgroundColor: const Color.fromARGB(255, 247, 147, 0),
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => popupCameraContent(),
          );
        },
        icon: const Icon(Icons.camera_alt),
        iconSize: 60,
        color: const Color.fromARGB(255, 43, 43, 43),
      ));

// Mic Button
  Widget micButtonBuilder() => CircleAvatar(
      radius: 55,
      backgroundColor: const Color.fromARGB(255, 247, 147, 0),
      child: IconButton(
        onPressed: () => showDialog(
            context: context, builder: (context) => popupMicContent(context)),
        icon: const Icon(Icons.mic),
        iconSize: 60,
        color: const Color.fromARGB(255, 43, 43, 43),
      ));

// Drop Down Widget
  Widget buildDropdownMenu() => Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 247, 147, 0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton<String>(
            focusColor: Colors.transparent,
            isExpanded: true,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            value: _chosenModel,
            items: <String>[
              'Accident',
              'Natural Disaster',
              'Fire Emergency',
              'Environmental Emergency',
              'Traffic Accident',
              'Violent Incident',
              'Search and Rescue Operation',
              'Structural Collapse',
              'Water-related Emergency',
              'Power Outage',
              'Other'
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
            dropdownColor: const Color.fromARGB(255, 247, 147, 0),
          ),
        ),
      );

// Not in the List Widget
  Widget buidTextField() => TextField(
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            labelText: "Not in the List",
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      );

// SOS Button
  Widget testWidget1() => SizedBox(
        width: 130.0,
        height: 40,
        child: FloatingActionButton(
          onPressed: () async {
            final downloadUrl = await uploadImageToFirebase();

            if (downloadUrl != null) {
              // Do something with the downloadUrl, such as:
              //   - Send in the SOS message
              //   - Display success to the user
              print("SOS sent with image: $downloadUrl");
            }
          },
          backgroundColor: const Color.fromARGB(255, 247, 147, 0),
          elevation: 2.0,
          child: const Text(
            'Send SOS',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      );

// Popup window when pressed camera icon
  Widget popupCameraContent() => AlertDialog(
        title: const Text('Camera Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image != null
                ? Image.file(
                    image!,
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  )
                : const FlutterLogo(
                    size: 160,
                  ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                // Code to handle taking a photo
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                // Code to choose from gallery
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      );

// Popup window when pressed mic icon
  Widget popupMicContent(BuildContext context) => AlertDialog(
        title: const Text('Record Voice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Recording Status Indicator (if desired)
            //Text(isRecording ? 'Recording...' : 'Ready to Record'),
            Text(_isRecording ? 'Recording...' : 'Ready to Record'),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 100,
                    icon: const Icon(Icons.mic_rounded),
                    onPressed: () {}),
                IconButton(
                    iconSize: 40,
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {}),
              ],
            ),
          ],
        ),
      );

  bool _isRecording = false;
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  String? _audioFilePath;

// Start/stop recording
  Future<void> _toggleRecording(StateSetter setState) async {
    if (_recorder!.isStopped) {
      await _requestPermission(); // Request microphone permission
      await _startRecording(setState);
    } else {
      await _stopRecording(setState);
    }
  }

// Request permission
  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Handle permission denied scenario.
      throw RecordingPermissionException('Microphone permission denied');
    }
  }

// Start recording
  Future<void> _startRecording(StateSetter setState) async {
    await _recorder!.openRecorder();

    // Generate a temporary file path
    final tempDir = await getTemporaryDirectory();
    _audioFilePath = '${tempDir.path}/sos_audio_${DateTime.now()}.aac';

    try {
      await _recorder!.startRecorder(toFile: _audioFilePath);
      setState(() => _isRecording = true);
    } catch (e) {
      // Handle errors
      print('Error starting recording: $e');
    }
  }

// Stop recording
  Future<void> _stopRecording(StateSetter setState) async {
    await _recorder!.stopRecorder();
    setState(() => _isRecording = false);
  }

// Play recording (add implementation if needed)
  Future<void> _playRecording() async {
    // ... (implement audio player logic here)
  }

// Choose from gallery
  Future pickImage(ImageSource source) async {
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
    final imagesRef = storageRef.child("sos_images/${DateTime.now()}.jpg");

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
