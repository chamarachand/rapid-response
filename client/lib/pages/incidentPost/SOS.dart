import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:client/storage/user_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:client/pages/incidentPost/GmapOpen.dart';
import 'package:client/pages/incidentPost/data_service.dart';
import 'package:location/location.dart';

class SOS extends StatefulWidget {
  const SOS({
    Key? key,
    // required this.title,
    // required this.location,
    // required this.voice,
  }) : super(key: key);

  // final String title;
  // final String location;
  // final String voice;

  @override
  State<SOS> createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  double _currentSliderValue = 0.0;
  List<dynamic> postData = [];

  List<dynamic> sosData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    try {
      final response = await http.get(
          Uri.parse(
              'https://rapid-response-pi.vercel.app/api/posts/sos/latest'),
          headers: {if (accessToken != null) 'x-auth-token': accessToken});
      if (response.statusCode == 200) {
        setState(() {
          postData = jsonDecode(response.body);
        });
      }
    } catch (e) {
      // Handle error
      print('Error fetching data: $e');
    }
  }

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
        child: ListView.builder(
            itemCount: postData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    color: const Color(0xFFFFCCCB),
                    child: ListTile(
                      title: Text(postData[index]["emergencyType"]),
                      subtitle: Text(
                          "SOS report on ${postData[index]["emergencyType"]}"),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget incidentTitle() => Container(
        margin: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60.0),
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => popupWindow(context),
            );
          },
          child: const Text(
            'HELLO WORLD HELLO WORLD HELLO WORLD',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Widget popupWindow(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor:
            Colors.transparent, // Make dialog background transparent
        child: Stack(
          children: [
            // Blurred background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255)
                      .withOpacity(1.0), // Adjust opacity as needed
                ),
              ),
            ),
            // Popup content
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(5.0),
                child: contentInPopup(),
              ),
            ),
          ],
        ),
      );

  Widget contentInPopup() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  OpenGoogleMap openGoogleMap = OpenGoogleMap();
                  openGoogleMap.launchGoogleMaps();
                },
                child: const Text("Location"),
              ),
              IconButton(
                iconSize: 30.0,
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          Container(
            height: 200,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: ClipRRect(
              // Wrap the Image.network in a ClipRRect
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                'https://downloadscdn6.freepik.com/188544/10/9871.jpg?filename=abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai.jpg&token=exp=1710540628~hmac=942da11c44f9b7968addf796ff9c8e66',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromARGB(255, 223, 223, 223),
            ),
            child: Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded),
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentSliderValue,
                      max: 100.0,
                      divisions: 100,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    " $_currentSliderValue",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      );
}
