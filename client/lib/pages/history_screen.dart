import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  DispalyHistoryScreen createState() => DispalyHistoryScreen();
}

class DispalyHistoryScreen extends State<HistoryScreen> {
  List _notifications = []; // list to hold notifications
  late bool _isFirstResponder = false; // initiating value, will be change on _loadToken
  int _selectedIndex = 2;  // value used to indicated selected button of buttom navi bar

  // creating widget to load user token when initaited
  void _loadToken() async {
    final idToken = await UserSecureStorage.getIdToken();

    if (idToken != null) {
      var decodedToken = JwtDecoder.decode(idToken);
      // access token claims
      if (decodedToken["userType"] == "civilian") {
        setState(() {
          _isFirstResponder = false;
        });
      } else {
        setState(() {
          _isFirstResponder = true;
        });
      }
    } else {print("load token not working");}
  }

  // creating widget to get notifications array from the database
  void _getNotifications() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    try {
      var response = await http.get(
        // getting the latest 10 notifications form the database
        Uri.parse("http://10.0.2.2:3000/api/notification/latest-notifications"),
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
                  color: Color.fromARGB(255, 155, 255, 181),
                );
        } else if (notificationType == "registered-location-added"){
          cusIcon = const Icon(
                  Icons.location_city,
                  size: 40,
                  color: Color.fromARGB(255, 155, 255, 181),
                );
        } else if (notificationType == "supervisee-remove"){
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
        } else {              // creating an else to account for other notification types unaccounted for supervisee-request
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
          color: Color.fromARGB(255, 230, 183, 255),
          border:
              Border.all(color: Color.fromARGB(255, 186, 157, 255), width: 3),
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
        )
        );
  }  

// initiating loadToken and getNotifications
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
        title: const Text(
          'History',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 246, 121, 255),
      ),
      body: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                itemCount: _notifications.length, // Example notification count
                itemBuilder: (context, index) {
                  return _buildNotificationDisplay(_notifications[index]["title"], _notifications[index]["body"], _notifications[index]["type"]);
                },
              ),
            ),
      // calling buildBottomNavigationBar() to create buttom navigation bar s
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        _isFirstResponder,
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
