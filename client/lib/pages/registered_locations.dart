import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/link_accounts/civilians/search_civilian.dart';
import 'package:client/pages/register_new_location.dart';

class RegisteredLocation extends StatefulWidget {
  const RegisteredLocation({super.key});
  @override
  DispalyRegisteredLocations createState() => DispalyRegisteredLocations();
}

class DispalyRegisteredLocations extends State<RegisteredLocation> {
  List<String> locationTags = ['Home', 'Office', 'School', 'Work', 'Neigbhor'];
  List<String> locationData = [
    'Main house at 156/A',
    'Workplace',
    'High School',
    'aeduih awjfj ab ckjcbasas cas c asc sac as c as csa c asc as cas c',
    'asnd as asc as csacas cs ac as cas c sa csacsacsac  sac sa cs ac as'
  ];

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

  @override
  Widget buildRegisteredLocationDisplay(
      String locationTag, String locationData) {
    return Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 185, 217, 243),
          border:
              Border.all(color: Color.fromARGB(255, 111, 91, 223), width: 5),
          borderRadius: BorderRadius.circular(20),
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
                          fontWeight: FontWeight.bold,
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
                  color: Colors.black,
                  size: 55,
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
        backgroundColor: Color.fromARGB(255, 1, 111, 255),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: locationTags.length,
            itemBuilder: (BuildContext context, int index) {
              return buildRegisteredLocationDisplay(
                  locationTags[index], locationData[index]);
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
                backgroundColor: const Color.fromARGB(255, 1, 111, 255),
              ),
              child: const Icon(
                Icons.add,
                size: 55,
              ),
            ),
          )
        ],
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
