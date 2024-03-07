import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

class MyEmergencyContacts extends StatefulWidget {
  const MyEmergencyContacts({super.key});

  @override
  State<MyEmergencyContacts> createState() => _MyEmergencyContactsState();
}

class _MyEmergencyContactsState extends State<MyEmergencyContacts> {
  Future<List<dynamic>>? _futureEmergencyContacts;

  Future<List<dynamic>> getEmergencyContacts() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final decodedAccessToken = JwtDecoder.decode(accessToken!);

    final response = await http.get(Uri.parse(
        "http://10.0.2.2:3000/api/linked-accounts/emergency-contacts/${decodedAccessToken["id"]}"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load emergency contacts');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureEmergencyContacts = getEmergencyContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://i.scdn.co/image/ab676161000051747d5aa798103bfb8562427274"),
                              radius: 24,
                            ),
                            title: Text(
                                user["firstName"] + " " + user["lastName"]),
                            subtitle: Text(user["email"]),
                            onTap: () => {},
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
