import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/registered_locations/register_new_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';

class RegisteredLocation extends StatefulWidget {
  const RegisteredLocation({super.key});
  @override
  DispalyRegisteredLocations createState() => DispalyRegisteredLocations();
}

class DispalyRegisteredLocations extends State<RegisteredLocation> {
  List _registeredLocations = [];
  int _selectedIndex = 1;

  final profileImg =
      "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";

  var _id;

  _loadToken() async {
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

  Future<void> _loadRegisteredLocations(String userId) async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/registeredLocations/registered-locations/$userId'));
    if (response.statusCode == 200) {
      setState(() {
          _registeredLocations = jsonDecode(response.body);
          print(_registeredLocations);
        });
    } else {
      throw Exception('Failed to fetch registered locations');
    }
  } catch (error) {
    print('Error fetching registered locations: $error');
  }
}

  @override
  void initState() {
    super.initState();
    _loadToken().then((_) {
    if (_id != null) {
      _loadRegisteredLocations(_id);
    }
  });
  }

  @override
  Widget buildRegisteredLocationDisplay(
      String locationTag, String locationData) {
      return Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 198, 229, 255),
          border:
              Border.all(color: Color.fromARGB(255, 191, 185, 224), width: 3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 115, 113, 113),
                  size: 50,
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locationTag,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    locationData,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              )),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 255, 132, 132),
                  size: 40,
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registered Locations',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 121, 179, 255),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _registeredLocations.length,
            itemBuilder: (BuildContext context, int index) {
              return buildRegisteredLocationDisplay(
                  _registeredLocations[index]["locationTag"], _registeredLocations[index]["address"],);
            },
          ),
          Positioned(
            bottom: 10,
            right: -15,
            child: ElevatedButton(
              onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const RegisterLocation())));
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: const Color.fromARGB(255, 121, 179, 255),
              ),
              child: const Icon(
                Icons.add,
                size: 55,
              ),
            ),
          )
        ],
      ),
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
}
