import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AddUserPage extends StatefulWidget {
  final dynamic _user;
  const AddUserPage(this._user, {super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  dynamic _accessToken;
  bool _alreadyEmergencyContact = false;
  bool _requestAlreadySent = false;

  recieveAccessToken() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    _accessToken = JwtDecoder.decode(accessToken!);
  }

  isEmergencyContact() async {
    try {
      var response = await http.get(Uri.parse(
          "http://10.0.2.2:3000/api/linked-accounts/emergency-contacts/${_accessToken["id"]}/${widget._user["_id"]}"));
      if (response.statusCode == 200) {
        setState(() {
          _alreadyEmergencyContact = true;
        });
      } else if (response.statusCode == 404) {
        print("false"); //remove this
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  isRequestSent() async {
    try {
      var response = await http.get(Uri.parse(
          "http://10.0.2.2:3000/api/notification/search/request/${_accessToken["id"]}/${widget._user["_id"]}"));
      if (response.statusCode == 200) {
        _requestAlreadySent = true;
      } else if (response.statusCode == 404) {
        _requestAlreadySent = false;
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  void showRequestAlreadySentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Request Already Sent!",
                style: TextStyle(fontSize: 20),
              ),
              content: const Text(
                "A request has already been sent to this user, is currently pending",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(
                Icons.warning,
                color: Colors.orange,
                size: 40,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"))
              ],
              actionsAlignment: MainAxisAlignment.center,
            ));
  }

  showNotificationSuccessDialog(String firstName, String lastName) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Request Sent Successfully!",
                style: TextStyle(fontSize: 20),
              ),
              content: Text(
                "The request has been sent to $firstName $lastName",
                textAlign: TextAlign.center,
              ),
              icon: const Icon(
                Icons.check,
                color: Colors.green,
                size: 40,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"))
              ],
              actionsAlignment: MainAxisAlignment.center,
            ));
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() async {
    await recieveAccessToken();
    isEmergencyContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: Text(widget._user["firstName"] + " " + widget._user["lastName"]),
        title: const Row(
          children: [
            Text("Add as Emergency Contact", style: TextStyle(fontSize: 18)),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.people, size: 30),
            )
          ],
        ),
        backgroundColor: const Color(0xFFadd8e6),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29uJTIwYXZhdGFyfGVufDB8fDB8fHww"),
            radius: 70,
          ),
          const SizedBox(height: 20),
          Text(
            widget._user["firstName"] + " " + widget._user["lastName"],
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(widget._user["username"]),
          const SizedBox(height: 40),
          _alreadyEmergencyContact
              ? const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Card(
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Emergency Contact!",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    await (isRequestSent());
                    if (_requestAlreadySent) {
                      return showRequestAlreadySentDialog();
                    }
                    try {
                      var response = await http.post(
                          Uri.parse(
                              "http://10.0.2.2:3000/api/notification/send"),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            "from": _accessToken["id"],
                            "to": widget._user["_id"],
                            "title": "Add Emergency Contact Request",
                            "body":
                                "${_accessToken["firstName"]} sent add as emergency contact request",
                          }));
                      if (response.statusCode == 200) {
                        print("Notification send successfully");
                        showNotificationSuccessDialog(widget._user["firstName"],
                            widget._user["lastName"]);
                      } else {
                        print(response.statusCode);
                      }
                    } catch (error) {
                      print("Error: $error");
                    }
                  },
                  child: const Text("Send Request"),
                ),
          const SizedBox(height: 8),
          if (!_alreadyEmergencyContact)
            ElevatedButton(onPressed: () {}, child: const Text("Cancel"))
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            label: "Link",
            icon: Icon(Icons.link),
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
