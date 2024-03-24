import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/registered_locations/registered_locations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';

class RegisterLocation extends StatefulWidget {
  const RegisterLocation({super.key});
  @override
  RegisterNewLocation createState() => RegisterNewLocation();
}

class RegisterNewLocation extends State<RegisterLocation> {
  // initializing the global variables used in the page
  int _selectedIndex = 1;   // variable used by ButtomNavigationBar
  late double lat;          // variable for latitude
  late double long;         // variable for longitude
  late String address = "Address loading..."; // variable for initail address value
  String? newAddress;                         // variable for address value after location provided
  String addressTag = "";                     // variable for address name tag
  bool showLocationInputs = false;            // variable for displaying of location input fields
  // text editing controllers for latitude longitude and address
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController addressTagController = TextEditingController();
  late Position _previousPosition;  // variable for current position
  late String? _accessToken;        // variable for acess token
  var _id;

  // creating widget to load user token when initaited
  void _loadToken() async {
    final idToken = await UserSecureStorage.getIdToken();
    _accessToken = await UserSecureStorage.getAccessToken();

    if (idToken != null) {
      var decodedToken = JwtDecoder.decode(idToken);
      // Access token claims
      setState(() {
        _id = decodedToken["id"];
      });
    }
  }

  // initiating widgets
  @override
  void initState() {
    super.initState();
    _loadToken();
    addressTagController = TextEditingController();
  }

  // disposing widgets
  @override
  void dispose() {
    addressTagController.dispose();
    super.dispose();
  }

  // function to get user permission for GPS
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // calling getCurrentLocation when permision granted
      _getCurrentLocation();
    } else {}
  }

  // function to get current location of user
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location service disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permission is permanently denied. We cannot access your location.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // using set location when location taken
      _setLocation(position.latitude, position.longitude);

      setState(() {
        _previousPosition = position;
      });

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
      // start listening for location updates
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position newPosition) {
        // calculate distance between new and previous position
        double distanceInMeters = Geolocator.distanceBetween(
          _previousPosition.latitude,
          _previousPosition.longitude,
          newPosition.latitude,
          newPosition.longitude,
        );

        // if user moved more than 100 meters, updatimg previous position
        if (distanceInMeters > 100) {
          setState(() {
            _previousPosition = newPosition;
          });
          _setLocation(newPosition.latitude, newPosition.longitude);
        }
      });
    } catch (e) {}
  }

  // function to get address using latitude and longitude
  void _setLocation(double nLat, double nLong) {
    placemarkFromCoordinates(nLat, nLong).then((List<Placemark> placemarks) {
      if (placemarks.isNotEmpty) {
        // when placemaker available implimneting new data to variables
        setState(() {
          Placemark place = placemarks.first;
          // getting address of provided placemaker
          newAddress = '${place.street}, ${place.locality}, ${place.country}';
          lat = nLat;
          long = nLong;
        });
      } else {
        setState(() {
          newAddress = 'No Address Found';
        });
      }
    }).catchError((e) {
      setState(() {
        newAddress = 'Error Fetching Address';
      });
    });
  }

  // function to send notification when new location registered
  sendRequestConfirmNotification() async {
    final idToken = await UserSecureStorage.getIdToken();
    final decodedIdToken = JwtDecoder.decode(idToken!);

    final response =
        await http.post(Uri.parse("http://10.0.2.2:3000/api/notification/send"),
            headers: {
              'Content-Type': 'application/json',
              if (_accessToken != null) 'x-auth-token': _accessToken!
            },
            body: jsonEncode({
              "from": decodedIdToken["id"],
              "to": decodedIdToken["id"],
              "type": "registered-location-added",
              "title": "New location registered",
              "body":
                  "New location $newAddress has been registered as $addressTag"
            }));

    if (response.statusCode == 200) {
      print("Notification send successfully!");
    }
  }

  // function to add new registered location to database
  Future<void> createRegisteredLocation(Map<String, dynamic> data) async {
    const url = 'http://10.0.2.2:3000/api/registeredLocations/create-registered-location'; // Replace with your actual server URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      // informing user of successful registration
      if (response.statusCode == 201) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          sendRequestConfirmNotification();
          return AlertDialog(
            title: const Text('New Location Registered',textAlign: TextAlign.center,),
            content: Text(
              'The new loaction $addressTag has been successfully registered',textAlign: TextAlign.center,),
            actions: [
              Center(
                child: TextButton(
                  // moving user to registered locations page and removing stacktrace
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const RegisteredLocation()),
                    (route) => false),
                    child: const Text('OK'),
                  ),
              ),
            ],
          );
        },
      );
      // error checking
      } else {
        print('Failed to register location: ${response.body}');
      }
    } catch (error) {
      print('Error creating registered location: $error');
    }
  }

  // fuction to create body of screen
  Widget buildRegisterNewLocationInput(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Location Tag',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
        ),
        SizedBox(
          child: TextField(
            controller: addressTagController, // use the controller to get addresstag
            onChanged: (value) {
              setState(() {
                addressTag = value; // updating the addressTag variable
              });
            },
            decoration: const InputDecoration(labelText: 'Enter Name Tag For Location'),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Address',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
        ),
        Text(newAddress ??
            address), // displaying the new address if set, otherwise using the existing address
        const SizedBox(height: 20),
        const Text(
          'Location',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // button to set current location as location to register
            ElevatedButton(
              onPressed: () {
                _requestLocationPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 169, 158, 255),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
              child: const Text('Current Location',style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),),
            ),
            // button to select 'set location manully'
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showLocationInputs = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 169, 158, 255),
                padding: const EdgeInsets.symmetric(
                    horizontal: 36, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
              child: const Text('Set Location',style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // display input fields for lat and long only when seleted to add location manually
        if (!showLocationInputs)
          const SizedBox(height: 206),
        if (showLocationInputs)
          Column(
            children: [
              SizedBox(
                child: TextField(
                  controller: latitudeController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: TextField(
                  controller: longitudeController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // back button that hides manual input field
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showLocationInputs = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 114, 98, 218),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                    child: const Text('Back',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  // set button that confirms input to lat and long 
                  ElevatedButton(
                    onPressed: () {
                      double? lat =
                          double.tryParse(latitudeController.text);
                      double? long =
                          double.tryParse(longitudeController.text);
                      // checking validity of input    
                      if (lat == null ||
                          long == null ||
                          lat < -90 ||
                          lat > 90 ||
                          long < -180 ||
                          long > 180) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Invalid Input'),
                              content: const Text(
                                  'Please enter valid latitude (-90 to 90) and longitude (-180 to 180) values.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        // if input valid setting location based on input data to ge address
                      } else {
                        _setLocation(lat, long);
                        setState(() {
                          showLocationInputs = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 114, 98, 218),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 34, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                    child: const Text('Set',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(height: 20),
        // confirm button to finalize registration
        ElevatedButton(
          onPressed: () {
            if (addressTag.isNotEmpty &&
            newAddress!.isNotEmpty) {
              // creating registered loaction
              createRegisteredLocation({
                'addedBy': _id, 
                'locationTag': addressTag,
                'address': newAddress,
                'latitude': lat,
                'longitude': long, 
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Incomplete Input',textAlign: TextAlign.center,),
                    content: const Text(
                        'Please enter the requied information before confirming',textAlign: TextAlign.center,),
                    actions: [
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 169, 158, 255),
            padding: const EdgeInsets.symmetric(
                horizontal: 32, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
          child: const Text('Confirm',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }

  // creating the main widget
  @override
  Widget build(BuildContext context) {
    // using Scaffold to build register new location screen
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register New Locations',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 119, 178, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height-200,
            child: buildRegisterNewLocationInput(),
          ),
        ),
      ),
      // applying navi bar using buildBottomNavigationBar()
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        false,
      ),
    );
  }

  // creating method to change selected index on tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
