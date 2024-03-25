//<SAHAN-IIT_20220334-UoW_w1953208>
import 'package:client/pages/add_event.dart';
import 'package:client/pages/incidentPost/navigationIncident.dart';
import 'package:client/pages/profile_screen/profile_screen_fr.dart';
import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/location_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';
import 'package:client/pages/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:client/pages/incidentPost/incidentPostPage.dart';

class MainMenuFR extends StatefulWidget {
  const MainMenuFR({super.key});
  @override
  MainMenuScreenFR createState() => MainMenuScreenFR();
}

class MainMenuScreenFR extends State<MainMenuFR> {
  // initializing the global variables used in the page
  bool _availability = false; // represents first responder's availibity to accept requests
  int _selectedIndex = 1; // variable used by ButtomNavigationBar
  var _firstName = ""; // user's first name
  List _notifications = []; // list to hold notifications
  // sample imaged used as profile image
  final profileImg = 
      "https://static.vecteezy.com/system/resources/previews/005/164/094/non_2x/nurse-professional-using-face-mask-with-stethoscope-free-vector.jpg";

// function to get user permission for GPS location tracking
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
  }

  // creating widget to load user token when initaited
  void _loadToken() async {
    final idToken = await UserSecureStorage.getIdToken();

    if (idToken != null) {
      var decodedToken = JwtDecoder.decode(idToken);
      // access token claims
      setState(() {
        _firstName = decodedToken["firstName"];
      });
    } 
  }

  // creating widget to fetch user availability from database
  Future<bool> fetchAvailability() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    try {
      final response = await http.get(
          Uri.parse(
              'http://10.0.2.2:3000/api/first-responder/get-availability'),
          headers: {
            'Content-Type': 'application/json',
            if (accessToken != null) 'x-auth-token': accessToken,
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
        // setting database availability of FR to the availability
        Uri.parse(
            'http://10.0.2.2:3000/api/first-responder/set-availability?availability=$newAvailability'),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token': accessToken,
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
      } else if (!_availability){
        stopLocationService(); // stop tracking location when _availability is false
      }
    });
  }

  // creating widget to get notifications array from the database
  void _getNotifications() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    try {
      var response = await http.get(
          // getting the latest 10 notifications form the database

          Uri.parse("http://10.0.2.2:3000/api/notification/latest/10"),
          headers: {
            'Content-Type': 'application/json',
            if (accessToken != null) 'x-auth-token': accessToken,
          });
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

  // creating widget that creates the notification messages to be displayed based on the _notifications list entries
  @override
  Widget _buildNotificationDisplay(
    // getting the required data to make notification
      String notificationTopic, String notificationData, String notificationType) {
        // customizing the icon based on notification type
        Icon cusIcon;
        if (notificationType == "supervisee-remove"){
          cusIcon = const Icon(
                  Icons.link,
                  size: 40,
                  color: Color.fromARGB(255, 255, 133, 124),
                );
        } else if (notificationType == "supervisee-request-accept"){
          cusIcon = const Icon(
                  Icons.link,
                  size: 40,
                  color: Color.fromARGB(255, 89, 255, 133),
                );
        } else if (notificationType == "supervisee-request"){
          cusIcon = const Icon(
                  Icons.link,
                  size: 40,
                  color: Color.fromARGB(255, 152, 188, 255),
                );
        } else {              // creating an else to account for other notification types (SOS and incident reports)
          cusIcon = const Icon(
                  Icons.warning_rounded,
                  size: 40,
                  color: Color.fromARGB(255, 255, 152, 152),
                );
        }
      // returing the container with the created notification
      return Container(
        margin: const EdgeInsets.all(5),  // adding a gap arround the container to have better flow with other notifications
        decoration: BoxDecoration(        // decorating notification container 
          color: const Color.fromARGB(255, 248, 255, 183),
          border: Border.all(
              color: const Color.fromARGB(255, 255, 221, 157), width: 3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(                  // adding padding between container and row items
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(                    // using a Row() for placement of content within the notification
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: cusIcon           // using the before determined icon
              ),
              Expanded(
                  child: Column(         // using a Column() to hold notification topic and content
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
    _requestLocationPermission();
    _loadToken();
    // getting notification list from database
    _getNotifications();
    // updating local availability after update from database
    fetchAvailability().then((availability) {
      setState(() {
        _availability = availability;
      });
    });
  }

  // creting the main widget
  @override
  Widget build(BuildContext context) {
    // using Scaffold to build main menu
    return Scaffold(    
      // creating the Appbar for main menu
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (BuildContext context) {
                double appBarHeight = AppBar().preferredSize.height;
                return Container(
                  alignment: Alignment.center,
                  child: IconButton(   // main logo is made as an icon button, further functionality will be added in the future
                    icon: SizedBox(
                      width: appBarHeight - 20,
                      height: appBarHeight - 20,
                      child: Image.asset('assets/RR_logo.png'), // using app logo 
                    ),
                    onPressed: () {},
                  ),
                );
              },
            ),
            Builder(  // creating a user name display and popup menu for viewing profile and logout
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
                            title: const Center(child: Text(
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
                                    builder: (context) => const ProfileFr())),
                          ),
                          // creting ListTile for logout option
                          ListTile(
                            title: const Center(child: Text(
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
                              // stopping startLocationService and work manager as user is logging out
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
      // creating body of Scafold using a column
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          // creating availability toogle switch
          SwitchListTile(
            title: const Text(
              'Availability',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            value: _availability,
            onChanged: _toggleAvailability, // updating availability when toggled to database nd other functions based on availability
            activeColor: Colors.green, 
            inactiveTrackColor: Colors.red, 
            subtitle: _availability ? const Text('Available') : const Text('Unavailable'),
          ),
          const SizedBox(height: 10),
          // creating button for add event functionality
          ElevatedButton(
            onPressed: () {
              // redirecting user to add even screen
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
          // creating button for incident posts functionaliy.
          ElevatedButton(
            onPressed: () {
              // redirecting user to add incident posts screen
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const NavigationIncident())));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'Incident Post',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          // creating the notification display area where the 10 latest notifications will be displayed
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                itemCount: _notifications.length, // Example notification count
                itemBuilder: (context, index) {
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
        true,  // passing as true since page belogs to FR
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
