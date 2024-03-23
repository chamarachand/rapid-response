import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// creating widget to get notifications array from the database
  Future<List> _getNotifications() async {
    List notifications = [];
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
         notifications = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        //no notifications for user
      }
    } catch (error) {
      // error message used in testing
      print("Error: $error");
    }
    return notifications;
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