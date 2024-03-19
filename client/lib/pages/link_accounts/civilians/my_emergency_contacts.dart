import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/storage/user_secure_storage.dart';
import 'dart:convert';
import 'package:client/pages/utils/alert_dialogs.dart';

class MyEmergencyContacts extends StatefulWidget {
  const MyEmergencyContacts({super.key});

  @override
  State<MyEmergencyContacts> createState() => _MyEmergencyContactsState();
}

class _MyEmergencyContactsState extends State<MyEmergencyContacts> {
  Future<List<dynamic>>? _futureEmergencyContacts;

  Future<List<dynamic>> getEmergencyContacts() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    final response = await http.get(
        Uri.parse(
            "http://10.0.2.2:3000/api/linked-accounts/emergency-contacts"),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token': accessToken
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load emergency contacts');
    }
  }

  void showDecisionConfirmDialog(String emergencyContactId) {
    showAlertDialog(
      context,
      "Remove from Emergency Contacts",
      "Sure you want to remove selected user from emergency contacts?",
      const Icon(
        Icons.warning,
        color: Colors.orange,
        size: 40,
      ),
      actions: [
        TextButton(
            onPressed: () async {
              await removeFromEmergencyContacts(emergencyContactId);
              if (mounted) {
                Navigator.pop(context);
              }
              showEmergencyContactRemovedDialog();
              setState(() {
                _futureEmergencyContacts = getEmergencyContacts();
              });
              // sendRequestConfirmNotification(requestedUserId);
            },
            child: const Text("Yes")),
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text("No")),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
    );
  }

  removeFromEmergencyContacts(String emergencyContactId) async {
    final accessToken = await UserSecureStorage.getAccessToken();

    final response = await http.get(
        Uri.parse(
            "http://10.0.2.2:3000/api/notification/requests?type=emergency-contact-request"),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token': accessToken
        });
    // api call to remove
  }

  void showEmergencyContactRemovedDialog() {
    showAlertDialog(
        context,
        "Removed from Emergency Contacts",
        "The user has been successfully removed from your emergency contacts",
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 40,
        ));
  }

  @override
  void initState() {
    super.initState();
    _futureEmergencyContacts = getEmergencyContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        backgroundColor: const Color(0xFFadd8e6),
        title: const Row(
          children: [
            Text("Emergency Contacts"),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.people_alt_rounded,
                size: 32,
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: _futureEmergencyContacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else {
            final emergencyContacts = snapshot.data!;
            if (emergencyContacts.isEmpty) {
              return const Center(child: Text('No emergency contacts'));
            }
            return ListView.builder(
              itemCount: emergencyContacts.length,
              itemBuilder: (context, index) {
                var user = emergencyContacts[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user[
                                      "profilePic"] ??
                                  "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"),
                              radius: 24,
                            ),
                            title: Text(
                                user["firstName"] + " " + user["lastName"]),
                            subtitle: Text(user["email"]),
                            onTap: () => {},
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_rounded,
                                  color: Color.fromARGB(255, 179, 39, 29),
                                  size: 30),
                              onPressed: () {
                                showDecisionConfirmDialog(user["_id"]);
                              },
                            ),
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 15),
                        //   child: Icon(Icons.open_in_new, size: 22),
                        // )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
