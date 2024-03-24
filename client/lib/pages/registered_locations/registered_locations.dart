import 'package:client/pages/utils/alert_dialogs.dart';
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
  // initializing the global variables used in the page
  List _registeredLocations = []; // list used to store registerd locations
  int _selectedIndex = 1;  // variable used by ButtomNavigationBar
  var _id;
  // sample imaged used as profile image
  final profileImg =
      "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";

  // creating widget to load user token when initaited
  _loadToken() async {
    final idToken = await UserSecureStorage.getIdToken();

    if (idToken != null) {
      var decodedToken = JwtDecoder.decode(idToken);
      // Access token claims
      setState(() {
        _id = decodedToken["id"];
      });
    }
  }

  // creating method to load registered locations to local list from database
  Future<void> _loadRegisteredLocations(String userId) async {
    try {
      // passsing http request with user Id to get registered locations array from database
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/registeredLocations/registered-locations/$userId'));
      if (response.statusCode == 200) {
        setState(() {
            _registeredLocations = jsonDecode(response.body);
          });
      } else {
        throw Exception('Failed to fetch registered locations');
      }
    } catch (error) {
      print('Error fetching registered locations: $error');
    }
  }

  // creating method to show popup dialog box when selecting delete option of a registered location displayed
  void showDecisionConfirmDialog(String selectedLocationTag) {
    showAlertDialog(
      context,
      "Remove $selectedLocationTag",
      "Sure you want to remove $selectedLocationTag from your registered locations?",
      const Icon(
        Icons.warning,
        color: Colors.orange,
        size: 40,
      ),
      actions: [
        // actions will be implimented in the future to facilitate removal of regitered locations
        TextButton(
            onPressed: (){},
            child: const Text("Yes")),
        TextButton(
            onPressed: (){}, child: const Text("No")),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
    );
  }

  // initiating widgets
  @override
  void initState() {
    super.initState();
    _loadToken().then((_) {
      if (_id != null) {
        _loadRegisteredLocations(_id);
      }
    });
  }

  // creating widget to build registered locations display
  @override
  Widget buildRegisteredLocationDisplay(
    // getting location tag and location details oncall
    String locationTag, String locationData) {
      // using container to contain individual location displays
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
              // calling the showDecisionConfirmDialog() function when delete button clicked
              IconButton(
                onPressed: () {
                  showDecisionConfirmDialog(locationTag);
                },
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

  // creating the main widget
  @override
  Widget build(BuildContext context) {
    // using Scaffold to build registered locations screen
    return Scaffold(
      // creating the Appbar
      appBar: AppBar(
        // adding screen title
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
      // creating body of Scafold using stack to include add new location button on top of registered locations
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
            // creating button to register new location
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
