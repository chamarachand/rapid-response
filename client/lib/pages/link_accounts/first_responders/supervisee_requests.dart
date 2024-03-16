import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

class SuperviseeRequests extends StatefulWidget {
  const SuperviseeRequests({super.key});

  @override
  State<SuperviseeRequests> createState() => SuperviseeRequestsState();
}

class SuperviseeRequestsState extends State<SuperviseeRequests> {
  Future<List<dynamic>>? _requests;

  Future<List<dynamic>> getRequests() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final decodedAccessToken = JwtDecoder.decode(accessToken!);

    final response = await http.get(Uri.parse(
        "http://10.0.2.2:3000/api/notification/requests/${decodedAccessToken["id"]}?type=supervisee-request"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load supervisee requests');
    }
  }

  updateNotificationStatus(String notificationId) async {
    final response = await http.patch(Uri.parse(
        "http://10.0.2.2:3000/api/notification/responded/$notificationId"));
    if (response.statusCode == 200) {
      return true;
    }
  }

  addAsSupervisee(String requestedUserId) async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final decodedAccessToken = JwtDecoder.decode(accessToken!);

    final response = await http.patch(Uri.parse(
        "http://10.0.2.2:3000/api/linked-accounts/supervisee-accounts/add/${decodedAccessToken["id"]}/$requestedUserId"));

    if (response.statusCode == 200) {
      return true;
    }
  }

  sendRequestConfirmNotification(String to) async {
    final idToken = await UserSecureStorage.getIdToken();
    final decodedIdToken = JwtDecoder.decode(idToken!);

    final response =
        await http.post(Uri.parse("http://10.0.2.2:3000/api/notification/send"),
            body: jsonEncode({
              "from": decodedIdToken["id"],
              "to": to,
              "type": "supervisee-request-accept",
              "title": "Request Accepted",
              "body":
                  "${decodedIdToken["firstName"]} ${decodedIdToken["lastName"]} accepted the request to be added as your supervisee"
            }));

    if (response.statusCode == 200) {
      print("Notification send successfully!");
    }
  }

  void showSampleDialog(String notificationId, String requestedUserId) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Accept Request!",
                style: TextStyle(fontSize: 20),
              ),
              content: const Text(
                "You want accept request?",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(
                Icons.warning,
                color: Colors.orange,
                size: 40,
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await updateNotificationStatus(notificationId);
                      await addAsSupervisee(requestedUserId);
                      if (mounted) {
                        Navigator.pop(context);
                      }
                      showRequestAcceptedDialog();
                      setState(() {
                        _requests = getRequests();
                      });
                      sendRequestConfirmNotification(requestedUserId);
                    },
                    child: const Text("Yes")),
                TextButton(
                    onPressed: () async {
                      await updateNotificationStatus(notificationId);
                      if (mounted) {
                        Navigator.pop(context);
                      }
                      setState(() {
                        _requests = getRequests();
                      });
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"))
              ],
              actionsAlignment: MainAxisAlignment.center,
            ));
  }

  void showRequestAcceptedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Request Accepted",
                style: TextStyle(fontSize: 20),
              ),
              content: const Text(
                "You have been added as an emergency contact for the user",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(
                Icons.warning,
                color: Colors.orange,
                size: 40,
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok")),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ));
  }

  @override
  void initState() {
    super.initState();
    _requests = getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        backgroundColor: const Color(0xFFadd8e6),
        title: const Row(
          children: [
            Text("Supervisee Requests"),
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
        future: _requests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else {
            final requests = snapshot.data!;
            print(requests);
            if (requests.isEmpty) {
              return const Center(child: Text('No supervisee requests'));
            }
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var request = requests[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                              radius: 24,
                            ),
                            title: Text(request["from"]["firstName"] +
                                " " +
                                request["from"]["lastName"]),
                            subtitle: const Text("Supervisee request"),
                            onTap: () => {
                              showSampleDialog(
                                  request["_id"], request["from"]["_id"])
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.reply, size: 22),
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
