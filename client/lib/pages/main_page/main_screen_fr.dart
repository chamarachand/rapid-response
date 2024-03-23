import 'package:client/pages/add_event.dart';
import 'package:client/pages/profile_screen/profile_screen_fr.dart';
import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/location_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';
import 'package:client/pages/login_screen.dart';

class MainMenuFR extends StatefulWidget {
  const MainMenuFR({super.key});
  @override
  MainMenuScreenFR createState() => MainMenuScreenFR();
}

class MainMenuScreenFR extends State<MainMenuFR> {
  //initializing the global variables used in the page
  bool _availability = false; // represents first responder's availibity to accept requests
  bool _test = false; // representing current state of location tracking
  int _selectedIndex = 1; // variable used by ButtomNavigationBar
  var _firstName = ""; // user's first name
  List _notifications = []; // list to hold notifications

  // creating widget to load user token when initaited
  void _loadToken() async {
    final idToken = await UserSecureStorage.getIdToken();

    if (idToken != null) {
      var decodedToken = JwtDecoder.decode(idToken);
      // access token claims
      setState(() {
        _firstName = decodedToken["firstName"];
      });
    } else {print("load token not working");}
  }

  // creating widget to fetch user availability from database
  Future<bool> fetchAvailability() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/first-responder/get-availability'),
        headers: {
            'Content-Type' : 'application/json',
            if (accessToken != null) 'x-auth-token' : accessToken,
          });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['availability'];
      }
    } catch (e) {
      // error message used in testing
      print('Error fetching availability: $e');
    }
    return false; // return false if there's any error
  }

  // creating widget to update user availability to database when changed
  Future<void> updateAvailability(bool newAvailability) async {
    final accessToken = await UserSecureStorage.getAccessToken();

    try {
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:3000/api/first-responder/set-availability?availability=$newAvailability'),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token' : accessToken,
          },
      );
      if (response.statusCode == 200) {
        // update availability locally if backend update succeeds
        setState(() {
          _availability = newAvailability;
        });
      } else {
        // error message used in testing
        print('Failed to update availability: ${response.statusCode}');
      }
    } catch (e) {
      // error message used in testing
      print('Error updating availability: $e');
    }
  }

  // creating widget to toggle availability
  void _toggleAvailability(bool value) {
    // updating new availability locally and in database
    setState(() {
      _availability = value;
      updateAvailability(value);
      if (_availability) {
        startLocationService();// start tracking location when _availability is true
        _test = isLocationServiceRunning(); 
      } else {
        stopLocationService(); // stop tracking location when _availability is false
        _test = isLocationServiceRunning(); 
      }
    });
  }

  // creating widget to get notifications array from the database
  void _getNotifications() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    try {
      var response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/notification/latest/10"),
        headers: {
          'Content-Type' : 'application/json',
          if (accessToken != null) 'x-auth-token' : accessToken,
        }
      );
      if (response.statusCode == 200) {
        // updating _notifications list with database list data
        setState(() {
          _notifications = jsonDecode(response.body);
        });
      } else if (response.statusCode == 404) {
        //no notifications for user
        print("notification error not upated to list");
      }
    } catch (error) {
      // error message used in testing
      print("Error: $error");
    }
  }

  
  @override
  Widget _buildNotificationDisplay(
      String notificationTopic, String notificationData, String notificationType) {
        Icon cusIcon;
        if (notificationType == "emergency-contact-remove"){
          cusIcon = const Icon(
                  Icons.link,
                  size: 40,
                  color: Color.fromARGB(255, 255, 133, 124),
                );
        } else if (notificationType == "emergency-contact-request"){
          cusIcon = const Icon(
                  Icons.link,
                  size: 40,
                  color: Color.fromARGB(255, 152, 188, 255),
                );
        } else if (notificationType == "emergency-contact-request-accept"){
          cusIcon = const Icon(
                  Icons.link,
                  size: 40,
                  color: Color.fromARGB(255, 89, 255, 133),
                );
        } else if (notificationType == "registered-location-added"){
          cusIcon = const Icon(
                  Icons.location_city,
                  size: 40,
                  color: Color.fromARGB(255, 89, 255, 133),
                );
        } else {
          cusIcon = const Icon(
                  Icons.warning_rounded,
                  size: 40,
                );
        }
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 255, 183),
          border:
              Border.all(color: const Color.fromARGB(255, 255, 221, 157), width: 3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: cusIcon
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
                        notificationTopic,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    notificationData,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              )),
            ],
          ),
        )
        );
  }
  
  // initiating widgets
  @override
  void initState() {
    super.initState();
    _loadToken();
    _getNotifications();
    // updating local availability after update from database
    fetchAvailability().then((availability) {
      setState(() {
        _availability = availability;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (BuildContext context) {
                double appBarHeight = AppBar().preferredSize.height;
                return Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: SizedBox(
                      width: appBarHeight - 20,
                      height: appBarHeight - 20,
                      child: Image.asset('assets/RR_logo.png'),
                    ),
                    onPressed: () {},
                  ),
                );
              },
            ),
            Builder(
              builder: (BuildContext context) {
                double appBarHeight = AppBar().preferredSize.height;
                return Container(
                  alignment: Alignment.center,
                  child: PopupMenuButton(
                    icon: SizedBox(
                      height: appBarHeight,
                      child: Row(
                        children: [
                          const Icon(Icons.person),
                          Text(
                            _firstName,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: appBarHeight - 20,
                            height: appBarHeight - 20,
                            child: Image.asset('assets/RR_logo.png'),
                          ),
                          const SizedBox(height: 25),
                          ListTile(
                            title: const Center(child: Text('View Profile')),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProfileFr())),
                          ),
                          ListTile(
                            title: const Center(child: Text('Logout')),
                            onTap: () {
                              UserSecureStorage.deleteAccessToken();
                              UserSecureStorage.deleteIdToken();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginPage()),
                                  (route) => false);
                              stopLocationService();    
                            },
                          ),
                        ],
                      )),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFF8497B0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          SwitchListTile(
            title: Text(
              'Availability $_test',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            value: _availability,
            onChanged: _toggleAvailability,
            activeColor: Colors.green, 
            inactiveTrackColor: Colors.red, 
            subtitle: _availability ? const Text('Available') : const Text('Unavailable'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Implement Add event functionality
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const add_event())));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 119, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'Add Event',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              // Implement incident posts functionality
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'Incident Posts',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                itemCount: _notifications.length, // Example notification count
                itemBuilder: (context, index) {
                  return _buildNotificationDisplay(_notifications[index]["title"], _notifications[index]["body"], _notifications[index]["type"]);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        true,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
