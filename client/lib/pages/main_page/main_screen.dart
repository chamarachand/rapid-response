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
  // initializing the global variables used in the page
  int _selectedIndex = 1; // variable used by ButtomNavigationBar
  List _notifications = []; // list to hold notifications
  var _firstName = ""; // user's first name
// sample imaged used as profile image
  String profileImg =
      "https://th.bing.com/th/id/R.7e652b13150cba9f278a112dd4b3703e?rik=KdflSdVwJBl4zg&pid=ImgRaw&r=0";

  // creating widget to load user token when initaited
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

  // creating widget to get notifications array from the database
  void _getNotifications() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    try {
      var response = await http.get(
          // getting the latest 10 notifications form the database
          Uri.parse(
              "https://rapid-response-pi.vercel.app/api/notification/latest/10"),
          headers: {
            'Content-Type': 'application/json',
            if (accessToken != null) 'x-auth-token': accessToken,
          });
      if (response.statusCode == 200) {
        // updating _notifications list with database list data
        setState(() {
          _notifications = jsonDecode(response.body);
          print(_notifications);
        });
      } else if (response.statusCode == 404) {
        //no notifications for user
      }
    } catch (error) {
      // error message used in testing
      print("Error: $error");
    }
  }

// creating widget that creates the notification messages to be displayed based on the _notifications list entries
  @override
  Widget _buildNotificationDisplay(
      // getting the required data to make notification
      String notificationTopic,
      String notificationData,
      String notificationType) {
    // customizing the icon based on notification type
    Icon cusIcon;
    if (notificationType == "emergency-contact-remove") {
      cusIcon = const Icon(
        Icons.link,
        size: 40,
        color: Color.fromARGB(255, 255, 133, 124),
      );
    } else if (notificationType == "emergency-contact-request") {
      cusIcon = const Icon(
        Icons.link,
        size: 40,
        color: Color.fromARGB(255, 152, 188, 255),
      );
    } else if (notificationType == "emergency-contact-request-accept") {
      cusIcon = const Icon(
        Icons.link,
        size: 40,
        color: Color.fromARGB(255, 89, 255, 133),
      );
    } else if (notificationType == "registered-location-added") {
      cusIcon = const Icon(
        Icons.location_city,
        size: 40,
        color: Color.fromARGB(255, 89, 255, 133),
      );
    } else {
      // creating an else to account for other notification types unaccounted for
      cusIcon = const Icon(
        Icons.warning_rounded,
        size: 40,
        color: Color.fromARGB(255, 255, 152, 152),
      );
    }
    // returing the container with the created notification
    return Container(
        margin: const EdgeInsets.all(
            5), // adding a gap arround the container to have better flow with other notifications
        decoration: BoxDecoration(
          // decorating notification container
          color: const Color.fromARGB(255, 248, 255, 183),
          border: Border.all(
              color: const Color.fromARGB(255, 255, 221, 157), width: 3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          // adding padding between container and row items
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            // using a Row() for placement of content within the notification
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: cusIcon // using the before determined icon
                  ),
              Expanded(
                  child: Column(
                // using a Column() to hold notification topic and content
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
        ));
  }

  // initiating widgets
  @override
  void initState() {
    super.initState();
    _loadToken();
    // getting notification list from database
    _getNotifications();
  }

  // creting the main widget
  @override
  Widget build(BuildContext context) {
    // using Scaffold to build main menu
    return Scaffold(
      // creating the Appbar for main menu for FR
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
                    // main logo is made as an icon button, further functionality will be added in the future
                    icon: SizedBox(
                      width: appBarHeight - 20,
                      height: appBarHeight - 20,
                      child:
                          Image.asset('assets/RR_logo.png'), // using app logo
                    ),
                    onPressed: () {},
                  ),
                );
              },
            ),
            // creating a user name display and popup menu for viewing profile and logout
            Builder(
              builder: (BuildContext context) {
                double appBarHeight = AppBar().preferredSize.height;
                return Container(
                  alignment: Alignment.center,
                  // using popupmenubutton for view profile and logout options
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
                    // building popupmenu
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 10),
                          SizedBox(
                            width: appBarHeight + 80,
                            height: appBarHeight + 80,
                            child: Image.network(
                              profileImg,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // creating ListTile for view profile option
                          ListTile(
                            title: const Center(
                                child: Text(
                              'View Profile',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            )),
                            // redirecting user to profile screen onTap
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Profile())),
                          ),
                          // creting ListTile for logout option
                          ListTile(
                            title: const Center(
                                child: Text(
                              'Logout',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            )),
                            // removing current account and redirecting user to Login page onTap
                            onTap: () {
                              UserSecureStorage.deleteAccessToken();
                              UserSecureStorage.deleteIdToken();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
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
      // creating body of Scafold using a column
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 25),
          // usinf Row() to align and position SOS and Report buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // creating SOS button
              ElevatedButton(
                // calling SOS functionality on press
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
              // creating Report button
              ElevatedButton(
                // calling Report functionality on press
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
          // creating button for Map functionality
          ElevatedButton(
            onPressed: () {
              // needs to impliment Map functionality
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
          // creating button for Registered Locations functionality
          ElevatedButton(
            // calling registered locations functionality on press
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
          // creting notification area
          Expanded(
            // using container for notifications
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              // using ListView.builder to create and display the individual notifications
              child: ListView.builder(
                itemCount: _notifications
                    .length, // notification count taken from list lenght
                itemBuilder: (context, index) {
                  // calling _buildNotificationDisplay() with content to create individual notifications
                  return _buildNotificationDisplay(
                      _notifications[index]["title"],
                      _notifications[index]["body"],
                      _notifications[index]["type"]);
                },
              ),
            ),
          ),
        ],
      ),
      // applying navi bar using buildBottomNavigationBar()
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        false, // passing as false since page belongs to civilian
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
