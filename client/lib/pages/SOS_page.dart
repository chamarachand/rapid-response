import 'dart:async';
import 'dart:io';
import 'package:client/storage/user_secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SOSpage extends StatefulWidget {
  const SOSpage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SOSpageState createState() => _SOSpageState();
}

class _SOSpageState extends State<SOSpage> {
  String _chosenModel = 'Accident'; // Initial value for the dropdown

  File? image;

  bool _showTextField = false;
  String sosType = 'None';
  final _textController = TextEditingController();
  String imageURL = 'None';
  String voiceURL = 'None';
  late String lat;
  late String long;
  late Position currentLocation;
  String locationMessage = 'Current Location of the User';

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
                      if (_showTextField) buidTextField(),
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
            onChanged: (String? sosType) {
              setState(() {
                _chosenModel = sosType!;
                _showTextField = sosType == 'Other';
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
  Widget buidTextField() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        const SizedBox(height: 30),
        TextField(
          controller: _textController,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
              labelText: "Not in the List",
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        )
      ]);

// SOS Button
  Widget testWidget1() => SizedBox(
        width: 130.0,
        height: 40,
        child: FloatingActionButton(
          onPressed: () {
            // getCurrentLocation().then((currentLocation) {
            //   sendDataToBackend();
            //   lat = '${currentLocation.latitude}';
            //   long = '${currentLocation.longitude}';
            //   _printCurrentPosition();
            //   setState(() {
            //     locationMessage = 'Latitude: $lat, Longitude: $long';
            //   });
            //   sosButtonPressed();
            //   sendDataToBackend();
            // });
            sosButtonPressed();
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
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  iconSize: 100,
                  icon: Icon(recorder.isRecording ? Icons.stop : Icons.mic),
                  onPressed: () async {
                    await requestMicrophonePermission();
                    if (recorder.isRecording) {
                      await stopRecorder();
                    } else {
                      await startRecorder();
                    }
                  },
                ),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => startPlayer(),
                )
              ],
            ),
          ],
        ),
      );

  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  FlutterSoundPlayer player = FlutterSoundPlayer();

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    } else {
      await startRecorder(); // Call the recording method if permission is granted
    }
  }

  Future<void> startRecorder() async {
    // Request microphone permission (if needed)
    await requestMicrophonePermission(); // Assuming you have this function

    // Check if recorder is already running
    if (recorder.isRecording) {
      print('Recorder is already running!');
      return;
    }

    await recorder.openRecorder();
    await recorder.startRecorder(toFile: 'audio');
  }

  Future<void> stopRecorder() async {
    // Ensure recorder state is checked
    if (recorder.isRecording) {
      String? path = await recorder.stopRecorder();
      print('Recorded audio saved at: $path');
    }
  }

  Future<void> startPlayer() async {
    String? path = await recorder.getRecordURL(
        path: 'audio'); // Adjust the file path if needed
    if (path != null) {
      await player.openPlayer();
      await player.startPlayer(
        fromURI: path,
        whenFinished: () {
          setState(() {});
        },
      );
    } else {
      print("No recording found to play");
    }
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    player.closePlayer();
    super.dispose();
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

  Future sosButtonPressed() async {
    if (sosType == 'Other') {
      sosType = _textController.text;
    }
    //image, voice, emergencyType, location

    imageURL = (await uploadImageToFirebase())!;

    sendDataToBackend();
    _printCurrentPosition();

    if (imageURL != null) {
      // Do something with the downloadUrl, such as:
      //   - Send in the SOS message
      //   - Display success to the user
      print("SOS sent with image: $imageURL");
    }

    print("SOS Type : $sosType");
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are permanently denied, we cannot request permission.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _printCurrentPosition() async {
    print('Latitude: $lat');
    print('Longitude: $long');
    // print('LAT: ${_currentPosition?.latitude ?? ""}');
    // print('LNG: ${_currentPosition?.longitude ?? ""}');
    // print('ADDRESS: ${_currentAddress ?? ""}');
  }

  void sendDataToBackend() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final decodedAccessToken = JwtDecoder.decode(accessToken!);
    String? id = decodedAccessToken["id"];
    String? image = imageURL;
    String? voice = voiceURL; // Adjust if needed
    String? emergencyType = sosType;
    Position? location = currentLocation;

    Map<String, dynamic> dataToSend = {
      'id': id,
      'image': image,
      'voice': voice,
      'emergencyType': emergencyType,
      'location': {
        // Assuming GeoJSON format
        'type': 'Point',
        'coordinates': [location.longitude, location.latitude],
      }
    };

    String backendUrl = 'http://localhost:27017/api/sos-report';

    try {
      http.Response response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }, // If needed
        body: jsonEncode(dataToSend),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data sent successfully!');
      } else {
        print('Error sending data: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error sending data: $error');
    }
  }
}
