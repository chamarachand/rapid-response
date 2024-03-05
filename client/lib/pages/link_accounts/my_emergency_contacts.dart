// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:client/storage/user_secure_storage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'dart:convert';

// class MyEmergencyContacts extends StatefulWidget {
//   const MyEmergencyContacts({super.key});

//   @override
//   State<MyEmergencyContacts> createState() => _MyEmergencyContactsState();
// }

// class _MyEmergencyContactsState extends State<MyEmergencyContacts> {
//   var _emergencyContacts;

//   getEmergencyContacts() async {
//     final accessToken = await UserSecureStorage.getAccessToken();
//     final decodedAccessToken = JwtDecoder.decode(accessToken!);

//     try {
//       var response = await http.get(Uri.parse(
//           "http://10.0.2.2:3000/api/linked-accounts/emergency-contacts/${decodedAccessToken["id"]}"));
//       if (response.statusCode == 200) {
//         print(200);
//         setState(() {
//           _emergencyContacts = jsonDecode(response.body);
//           print(_emergencyContacts);
//           print(_emergencyContacts[0]["firstName"]);
//         });

//         print(_emergencyContacts);
//       } else if (response.statusCode == 404) {
//         print(400);
//       } else {
//         print(response.statusCode);
//       }
//     } catch (error) {
//       print("Error: $error");
//     }
//   }

//   @override
//   void initState() {
//     intializeData();
//     super.initState();
//   }

//   void intializeData() async {
//     await getEmergencyContacts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFFadd8e6),
//           title: const Row(children: [
//             Text("Emergency Contacts"),
//             Padding(
//               padding: EdgeInsets.only(left: 10),
//               child: Icon(
//                 Icons.people_alt_rounded,
//                 size: 32,
//               ),
//             )
//           ]),
//         ),
//         body: _emergencyContacts == null
//             ? const CircularProgressIndicator()
//             : ListView.builder(
//                 itemCount:
//                     _emergencyContacts != null ? _emergencyContacts.length : 0,
//                 itemBuilder: (context, index) {
//                   var user = _emergencyContacts[index];

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Card(
//                       child: Row(children: [
//                         Expanded(
//                             child: ListTile(
//                           leading: const CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"),
//                           ),
//                           title: Text(user["firstName"]),
//                           subtitle:
//                               Text(user["firstName"] + " " + user["lastName"]),
//                           // trailing: const Icon(Icons.open_in_new, size: 22),
//                           onTap: () => {},
//                         )),
//                         const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15),
//                             child: Icon(Icons.open_in_new, size: 22))
//                       ]),
//                     ),
//                   );
//                 },
//               ));
//   }
// }

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
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"),
                            ),
                            title: Text(user["firstName"] ?? ""),
                            subtitle: Text((user["firstName"] ?? "") +
                                " " +
                                (user["lastName"] ?? "")),
                            onTap: () => {},
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.open_in_new, size: 22),
                        )
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
