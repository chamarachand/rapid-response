import 'package:client/pages/link_accounts/civilians/link_account_home.dart';
import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/registered_locations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterLocation extends StatefulWidget {
  const RegisterLocation({super.key});
  @override
  RegisterNewLocation createState() => RegisterNewLocation();
}

class RegisterNewLocation extends State<RegisterLocation> {
  late double lat;
  late double long;
  late String address = "Address loading...";
  String? newAddress;
  String addressTag = "";
  bool showLocationInputs = false;
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController addressTagController = TextEditingController();
  late Position _previousPosition;
  var _id;

  int _selectedIndex = 1;

  final profileImg =
      "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";

  void _loadToken() async {
    final idToken = await UserSecureStorage.getIdToken();

    if (idToken != null) {
      var decodedToken = JwtDecoder.decode(idToken);
      // Access token claims
      setState(() {
        _id = decodedToken["id"];
      });
      print(_id);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    addressTagController = TextEditingController();
  }

  @override
  void dispose() {
    addressTagController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {}
  }

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
      _setLocation(position.latitude, position.longitude);

      setState(() {
        _previousPosition = position;
      });

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
      // Start listening for location updates
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position newPosition) {
        // Calculate distance between new and previous position
        double distanceInMeters = Geolocator.distanceBetween(
          _previousPosition.latitude,
          _previousPosition.longitude,
          newPosition.latitude,
          newPosition.longitude,
        );

        // If user moved more than 100 meters, update previous position
        if (distanceInMeters > 100) {
          setState(() {
            _previousPosition = newPosition;
          });
          _setLocation(newPosition.latitude, newPosition.longitude);
        }
      });
    } catch (e) {}
  }

  void _setLocation(double nLat, double nLong) {
    placemarkFromCoordinates(nLat, nLong).then((List<Placemark> placemarks) {
      if (placemarks.isNotEmpty) {
        setState(() {
          Placemark place = placemarks.first;
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

      if (response.statusCode == 201) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New Location Registered',textAlign: TextAlign.center,),
            content: Text(
              'The new loaction $addressTag has been successfully registered',textAlign: TextAlign.center,),
            actions: [
              Center(
                child: TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisteredLocation())),
                  child: const Text('OK'),
                ),
              ),
            ],
          );
        },
      );

      } else {
        print('Failed to register location: ${response.body}');
      }
    } catch (error) {
      print('Error creating registered location: $error');
    }
  }

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
            controller: addressTagController, // Use the controller
            onChanged: (value) {
              setState(() {
                addressTag = value; // Update the addressTag variable
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
            address), // Display the new address if set, otherwise use the existing address
        const SizedBox(height: 20),
        const Text(
          'Location',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                  ElevatedButton(
                    onPressed: () {
                      double? lat =
                          double.tryParse(latitudeController.text);
                      double? long =
                          double.tryParse(longitudeController.text);
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
        ElevatedButton(
          onPressed: () {
            if (addressTag.isNotEmpty &&
            newAddress!.isNotEmpty &&
            lat != null &&
            long != null) {
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

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFD9D9D9),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {
                  _onItemTapped(0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LinkAccountHome())));
                },
              ),
              label: 'Link',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
              label: 'History',
            ),
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
