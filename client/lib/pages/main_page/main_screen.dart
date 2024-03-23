import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/pages/profile_screen/profile_screen.dart';
import 'package:client/pages/registered_locations/registered_locations.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/SOS_page.dart';
import 'package:client/pages/report_incident_screen.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';
import 'package:client/pages/login_screen.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});
  @override
  MainMenuScreen createState() => MainMenuScreen();
}

class MainMenuScreen extends State<MainMenu> {
  int _selectedIndex = 1;
  List _notifications = [];
  var _firstName = "";

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

  @override
  void initState() {
    super.initState();
    _loadToken();
    _getNotifications();
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
                                    builder: (context) => const Profile())),
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
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SOSpage())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                child: const Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportScreen())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 33, vertical: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                child: const Text(
                  'Report',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              // Implement Map functionality
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 138, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'MAP',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisteredLocation())),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 29, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'Registered Locations',
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
