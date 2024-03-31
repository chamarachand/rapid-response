import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:client/pages/utils/alert_dialogs.dart';

abstract class MyAccounts extends StatefulWidget {
  final String displayName;
  final String userType;
  final String notificationType;
  final String endpoint;

  const MyAccounts(
      this.displayName, this.userType, this.notificationType, this.endpoint,
      {super.key});

  @override
  State<MyAccounts> createState() => MyAccountsState();
}

class MyAccountsState extends State<MyAccounts> {
  Future<List<dynamic>>? _futureAccounts;

  Future<List<dynamic>> getAccounts() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    final response = await http.get(
        Uri.parse(
            "https://rapid-response-pi.vercel.app/api/linked-accounts/${widget.endpoint}s"),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token': accessToken
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load ${widget.displayName.toLowerCase()}s');
    }
  }

  removeFromAccounts(String accountId) async {
    final accessToken = await UserSecureStorage.getAccessToken();

    final response = await http.delete(
        Uri.parse(
            "https://rapid-response-pi.vercel.app/api/${widget.userType}/remove/${widget.endpoint}/${accountId}"),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token': accessToken
        });

    return response.statusCode == 200;
  }

  void showDecisionConfirmDialog(String accountId) {
    showAlertDialog(
      context,
      "Remove from ${widget.displayName}",
      "Sure you want to remove selected user from your ${widget.displayName.toLowerCase()}s?",
      const Icon(
        Icons.warning,
        color: Colors.orange,
        size: 40,
      ),
      actions: [
        TextButton(
            onPressed: () async {
              bool result = await removeFromAccounts(accountId);
              print("Removed from ${widget.displayName.toLowerCase()}s");
              if (mounted) {
                Navigator.pop(context);
              }
              showSuperviseeRemovedDialog();
              setState(() {
                _futureAccounts = getAccounts();
              });
              sendRemoveAccountNotification(accountId);
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

  sendRemoveAccountNotification(String to) async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final idToken = await UserSecureStorage.getIdToken();
    final decodedIdToken = JwtDecoder.decode(idToken!);

    final response = await http.post(
        Uri.parse("https://rapid-response-pi.vercel.app/api/notification/send"),
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'x-auth-token': accessToken
        },
        body: jsonEncode({
          "from": decodedIdToken["id"],
          "to": to,
          "type": widget.notificationType,
          "title": "Removed from ${widget.displayName}",
          "body":
              "${decodedIdToken["firstName"]} ${decodedIdToken["lastName"]} removed you from their ${widget.displayName.toLowerCase()}s"
        }));

    if (response.statusCode == 200) {
      print("Notification send successfully!");
    }
  }

  void showSuperviseeRemovedDialog() {
    showAlertDialog(
        context,
        "Removed from ${widget.displayName}",
        "The user has been successfully removed from ${widget.displayName.toLowerCase()}s",
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 40,
        ));
  }

  @override
  void initState() {
    super.initState();
    _futureAccounts = getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        backgroundColor: const Color(0xFFadd8e6),
        title: Row(
          children: [
            Text("My ${widget.displayName}s"),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: _futureAccounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else {
            final supervisees = snapshot.data!;
            if (supervisees.isEmpty) {
              return Center(
                  child: Text('No ${widget.displayName.toLowerCase()}s'));
            }
            return ListView.builder(
              itemCount: supervisees.length,
              itemBuilder: (context, index) {
                var user = supervisees[index];

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
                                  size: 25),
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
