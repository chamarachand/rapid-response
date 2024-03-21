import 'package:client/pages/profile_screen_fr.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/welcome_screen.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/link_accounts/first_responders/link_accounts_home_fr.dart';
import 'package:client/pages/location_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainMenuFR extends StatefulWidget {
  const MainMenuFR({super.key});
  @override
  MainMenuScreenFR createState() => MainMenuScreenFR();
}

class MainMenuScreenFR extends State<MainMenuFR> {
  bool _availability = false;
  bool _test = false;
  int _selectedIndex = 1;
  var _firstName = "";
  List _notifications = [];

  void _loadToken() async {
    final idToken = await UserSecureStorage.getIdToken();

    if (idToken != null) {
      var decodedToken = JwtDecoder.decode(idToken);
      // Access token claims
      setState(() {
        _firstName = decodedToken["firstName"];
      });
    }
  }

  Future<bool> fetchAvailability() async {
    try {
      final response = await http.get(Uri.parse('YOUR_BACKEND_URL_HERE'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['availability'];
      }
    } catch (e) {
      print('Error fetching availability: $e');
    }
    return false; // Return false if there's any error
  }

  Future<void> updateAvailability(bool newAvailability) async {
    try {
      final response = await http.patch(
        Uri.parse('YOUR_BACKEND_URL_HERE'),
        body: json.encode({'availability': newAvailability}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Update availability locally if backend update succeeds
        setState(() {
          _availability = newAvailability;
        });
      } else {
        print('Failed to update availability: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating availability: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    fetchAvailability().then((availability) {
      setState(() {
        _availability = availability;
      });
    });
  }

  void _toggleAvailability(bool value) {
    setState(() {
      _availability = value;
      updateAvailability(value);
      if (_availability) {
        startLocationService();// Start tracking location when _availability is true
        _test = isLocationServiceRunning(); 
      } else {
        stopLocationService(); // Stop tracking location when _availability is false
        _test = isLocationServiceRunning(); 
      }
    });
  }

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
        setState(() {
          _notifications = jsonDecode(response.body);
          print(_notifications);
        });
      } else if (response.statusCode == 404) {
        //no notifications for user
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget _buildNotificationDisplay(
      String notificationType, String notificationData) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 250, 151),
          border:
              Border.all(color: Color.fromARGB(255, 252, 195, 88), width: 5),
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
                        notificationType,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    notificationData,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ));
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
                                          const WelcomePage()),
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
                  return _buildNotificationDisplay(_notifications[index]["title"], _notifications[index]["body"]);
                },
              ),
            ),
          ),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const MainMenuFR())));
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
