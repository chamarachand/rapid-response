import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/link_accounts/add_em_comtact_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RegisterLocation extends StatefulWidget {
  const RegisterLocation({super.key});
  @override
  RegisterNewLocation createState() => RegisterNewLocation();
}

class RegisterNewLocation extends State<RegisterLocation> {
  String locationMessage = 'Current Location';
  late String lat;
  late String long;
  late String address = "Address loading...";

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

  // Future<String> getAddressFromLatLong(double latitude, double longitude) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
  //     Placemark place = placemarks.first;
  //     String address = '${place.street}, ${place.locality}, ${place.country}';
  //     return address;
  //   } catch (e) {
  //     print('Error getting address from coordinates: $e');
  //     return "Address not found";
  //   }
  // }

  Future<Position> _getCurrentLocation() async {
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

    Geolocator.getPositionStream().listen((Position position) async {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        Placemark place = placemarks.first;
        address = '${place.street}, ${place.locality}, ${place.country}';
      } catch (e) {
        // ignore: avoid_print
        print('Error getting address from coordinates: $e');
      }

      setState(() {
        locationMessage = 'Latitude: $lat, Longitude: $long';
      });
    });

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) async {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        Placemark place = placemarks.first;
        address = '${place.street}, ${place.locality}, ${place.country}';
      } catch (e) {
        // ignore: avoid_print
        print('Error getting address from coordinates: $e');
      }

      setState(() {
        locationMessage = 'Latitude: $lat, Longitude: $long';
      });
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String googleURL = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
      ? await launchUrlString(googleURL)
      : throw 'Could not launch $googleURL';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationMessage, textAlign: TextAlign.center,),
            Text('Address: $address', textAlign: TextAlign.center,),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                  // adLat = value.latitude;
                  // adLong = value.longitude;
                  setState(() {
                    locationMessage = 'Latitude: $lat, Longitude: $long';
                  });
                  _liveLocation();
                });
                // getAddressFromLatLong(adLat, adLong);
              }, 
              child: Text('Get Current Location'),
              ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                _openMap(lat, long);
              }, 
              child: const Text('Open Google Map'),
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
