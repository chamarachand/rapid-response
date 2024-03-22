import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:client/pages/utils/alert_dialogs.dart';

abstract class Requests extends StatefulWidget {
  final String displayName;
  final String notificationType;
  final String notificationAcceptType;
  final String endpoint;

  const Requests(this.displayName, this.notificationType,
      this.notificationAcceptType, this.endpoint,
      {super.key});

  @override
  State<Requests> createState() => RequestsState();
}

class RequestsState extends State<Requests> {
  late String? _accessToken;
  Future<List<dynamic>>? _requests;

  Future<List<dynamic>> getRequests() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    final response = await http.get(
        Uri.parse(
            "http://10.0.2.2:3000/api/notification/requests/?type=${widget.notificationType}"),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token': accessToken
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception(
          'Failed to load ${widget.displayName.toLowerCase()} requests');
    }
  }

  void _getAccessToken() async {
    _accessToken = await UserSecureStorage.getAccessToken();
  }

  updateNotificationStatus(String notificationId) async {
    final response = await http.patch(
        Uri.parse(
            "http://10.0.2.2:3000/api/notification/responded/$notificationId"),
        headers: {
          'Content-Type': 'application/json',
          if (_accessToken != null) 'x-auth-token': _accessToken!
        });
    if (response.statusCode == 200) {
      return true;
    }
  }

  addAsLinkedAccount(String requestedUserId) async {
    final response = await http.patch(
        Uri.parse(
            "http://10.0.2.2:3000/api/linked-accounts/${widget.endpoint}/add/$requestedUserId"),
        headers: {
          'Content-Type': 'application/json',
          if (_accessToken != null) 'x-auth-token': _accessToken!
        });

    if (response.statusCode == 200) {
      return true;
    }
  }

  sendRequestConfirmNotification(String to) async {
    final idToken = await UserSecureStorage.getIdToken();
    final decodedIdToken = JwtDecoder.decode(idToken!);

    final response =
        await http.post(Uri.parse("http://10.0.2.2:3000/api/notification/send"),
            headers: {
              'Content-Type': 'application/json',
              if (_accessToken != null) 'x-auth-token': _accessToken!
            },
            body: jsonEncode({
              "from": decodedIdToken["id"],
              "to": to,
              "type": widget.notificationAcceptType,
              "title": "Request Accepted",
              "body":
                  "${decodedIdToken["firstName"]} ${decodedIdToken["lastName"]} accepted the request to be added as your ${widget.displayName.toLowerCase()}"
            }));

    if (response.statusCode == 200) {
      print("Notification send successfully!");
    }
  }

  void showDecisionDialog(String notificationId, String requestedUserId) {
    showAlertDialog(
      context,
      "Accept Request?",
      "You want to accept the request?",
      const Icon(
        Icons.warning,
        color: Colors.orange,
        size: 40,
      ),
      actions: [
        TextButton(
            onPressed: () async {
              await updateNotificationStatus(notificationId);
              await addAsLinkedAccount(requestedUserId);
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
    );
  }

  void showRequestAcceptedDialog() {
    showAlertDialog(
        context,
        "Request Accepted",
        "You have been added as an ${widget.displayName.toLowerCase()} for the requested user",
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 40,
        ));
  }

  @override
  void initState() {
    super.initState();
    _requests = getRequests();
    _getAccessToken();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        backgroundColor: const Color(0xFFadd8e6),
        title: Row(
          children: [
            Text("${widget.displayName}s"),
            const Padding(
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
            if (requests.isEmpty) {
              return Center(
                  child:
                      Text('No ${widget.displayName.toLowerCase()} requests'));
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
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(request["from"]
                                      ["profilePic"] ??
                                  "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"),
                              radius: 24,
                            ),
                            title: Text(request["from"]["firstName"] +
                                " " +
                                request["from"]["lastName"]),
                            subtitle: Text("${widget.displayName} Request"),
                            onTap: () => {
                              showDecisionDialog(
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
