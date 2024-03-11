import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/link_accounts/add_em_comtact_screen.dart';

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
  late String addressTag;
  bool showLocationInputs = false;
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  int _selectedIndex = 1;

  final profileImg =
      "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";

  var _firstName = "";

  void _loadToken() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    if (accessToken != null) {
      var decodedToken = JwtDecoder.decode(accessToken);
      // Access token claims
      setState(() {
        _firstName = decodedToken["firstName"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission is permanently denied. We cannot access yoour location.');
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    _setLocation(lat, long);
  }

  Future<void> _setLocation(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      Placemark place = placemarks.first;
      if (placemarks != null && placemarks.isNotEmpty) {
        setState(() {
          newAddress = '${place.street}, ${place.locality}, ${place.country}';
        });
      } else {
        setState(() {
          newAddress = 'No Address Found';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        newAddress = 'Error Fetching Address';
      });
    }
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
        backgroundColor: Color.fromARGB(255, 0, 88, 202),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Location Tag',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Enter Name Tag For Location'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Address',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(newAddress ?? address), // Display the new address if set, otherwise use the existing address
            const SizedBox(height: 20),
            const Text(
              'Location',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (){
                    _getCurrentLocation().then((value) {
                    });
                  }, 
                  child: const Text('Current Location'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showLocationInputs = true;
                    });
                  },
                  child: const Text('Set Location'),
                ),
              ],
            ),
            const Spacer(),
            if (showLocationInputs)
              Column(
                children: [
                  TextField(
                    controller: latitudeController,
                    decoration: InputDecoration(labelText: 'Latitude'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: longitudeController,
                    decoration: InputDecoration(labelText: 'Longitude'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showLocationInputs = false;
                          });
                        },
                        child: Text('Back'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          double? lat = double.tryParse(latitudeController.text);
                          double? long = double.tryParse(longitudeController.text);
                          if (lat == null || long == null || lat < -90 || lat > 90 || long < -180 || long > 180) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Invalid Input'),
                                  content: Text('Please enter valid latitude (-90 to 90) and longitude (-180 to 180) values.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
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
                        child: Text('Set'),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle confirm
              },
              child: Text('Confirm'),
            ),
          ],
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
                          builder: ((context) => const UserSearchPage())));
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
