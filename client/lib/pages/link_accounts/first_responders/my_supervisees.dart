// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:client/pages/utils/alert_dialogs.dart';
// import 'package:client/storage/user_secure_storage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

// class MySupervisees extends StatefulWidget {
//   const MySupervisees({super.key});

//   @override
//   State<MySupervisees> createState() => _MySuperviseesState();
// }

// class _MySuperviseesState extends State<MySupervisees> {
//   Future<List<dynamic>>? _futureSupervisees;

//   Future<List<dynamic>> getSupervisees() async {
//     final accessToken = await UserSecureStorage.getAccessToken();

//     final response = await http.get(
//         Uri.parse("http://10.0.2.2:3000/api/linked-accounts/supervisees"),
//         headers: {
//           'Content-Type': 'application/json',
//           if (accessToken != null) 'x-auth-token': accessToken
//         });

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else if (response.statusCode == 404) {
//       return [];
//     } else {
//       throw Exception('Failed to load supervisees');
//     }
//   }

//   removeFromSupervisees(String superviseeId) async {
//     final accessToken = await UserSecureStorage.getAccessToken();

//     final response = await http.delete(
//         Uri.parse(
//             "http://10.0.2.2:3000/api/first-responder/remove/supervisee/${superviseeId}"),
//         headers: {
//           'Content-Type': 'application/json',
//           if (accessToken != null) 'x-auth-token': accessToken
//         });

//     return response.statusCode == 200;
//   }

//   void showDecisionConfirmDialog(String superviseeId) {
//     showAlertDialog(
//       context,
//       "Remove from Supervisee",
//       "Sure you want to remove selected user from your supervisees?",
//       const Icon(
//         Icons.warning,
//         color: Colors.orange,
//         size: 40,
//       ),
//       actions: [
//         TextButton(
//             onPressed: () async {
//               bool result = await removeFromSupervisees(superviseeId);
//               print(result);
//               if (mounted) {
//                 Navigator.pop(context);
//               }
//               showSuperviseeRemovedDialog();
//               setState(() {
//                 _futureSupervisees = getSupervisees();
//               });
//               sendRemoveSuperviseeNotification(superviseeId);
//             },
//             child: const Text("Yes")),
//         TextButton(
//             onPressed: () => Navigator.pop(context), child: const Text("No")),
//         TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"))
//       ],
//     );
//   }

//   sendRemoveSuperviseeNotification(String to) async {
//     final accessToken = await UserSecureStorage.getAccessToken();
//     final idToken = await UserSecureStorage.getIdToken();
//     final decodedIdToken = JwtDecoder.decode(idToken!);

//     final response =
//         await http.post(Uri.parse("http://10.0.2.2:3000/api/notification/send"),
//             headers: {
//               'Content-Type': 'application/json',
//               if (accessToken != null) 'x-auth-token': accessToken
//             },
//             body: jsonEncode({
//               "from": decodedIdToken["id"],
//               "to": to,
//               "type": "supervisee-remove",
//               "title": "Removed from Supervisee",
//               "body":
//                   "${decodedIdToken["firstName"]} ${decodedIdToken["lastName"]} removed you from their supervisees"
//             }));

//     if (response.statusCode == 200) {
//       print("Notification send successfully!");
//     }
//   }

//   void showSuperviseeRemovedDialog() {
//     showAlertDialog(
//         context,
//         "Removed from Supervisee",
//         "The user has been successfully removed from supervisees",
//         const Icon(
//           Icons.check_circle,
//           color: Colors.green,
//           size: 40,
//         ));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _futureSupervisees = getSupervisees();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 242, 243, 247),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFadd8e6),
//         title: const Row(
//           children: [
//             Text("Supervisee Accounts"),
//             Padding(
//               padding: EdgeInsets.only(left: 10),
//               child: Icon(
//                 Icons.people_alt_rounded,
//                 size: 32,
//               ),
//             )
//           ],
//         ),
//       ),
//       body: FutureBuilder(
//         future: _futureSupervisees,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text("Error loading data"));
//           } else {
//             final supervisees = snapshot.data!;
//             if (supervisees.isEmpty) {
//               return const Center(child: Text('No supervisees'));
//             }
//             return ListView.builder(
//               itemCount: supervisees.length,
//               itemBuilder: (context, index) {
//                 var user = supervisees[index];

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 0),
//                   child: Card(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: NetworkImage(user[
//                                       "profilePic"] ??
//                                   "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"),
//                               radius: 24,
//                             ),
//                             title: Text(
//                                 user["firstName"] + " " + user["lastName"]),
//                             subtitle: Text(user["email"]),
//                             onTap: () => {},
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete_rounded,
//                                   color: Color.fromARGB(255, 179, 39, 29),
//                                   size: 30),
//                               onPressed: () {
//                                 showDecisionConfirmDialog(user["_id"]);
//                               },
//                             ),
//                           ),
//                         ),
//                         // const Padding(
//                         //   padding: EdgeInsets.symmetric(horizontal: 15),
//                         //   child: Icon(Icons.open_in_new, size: 22),
//                         // )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:client/pages/link_accounts/common/my_accounts.dart';

class MySupervisees extends MyAccounts {
  const MySupervisees({super.key})
      : super(
          "Supervisee", // displayName
          "first-responder", // userType
          "supervisee-remove", //notificationType
          "supervisee", // endpoint
        );
}
