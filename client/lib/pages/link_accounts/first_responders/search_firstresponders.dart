import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/storage/user_secure_storage.dart';
import 'package:client/pages/link_accounts/first_responders/first_responder_user.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  late String? _accessToken;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  List _searchResults = [];

  void _getAccessToken() async {
    _accessToken = await UserSecureStorage.getAccessToken();
  }

  void _updateSearchQuery(String newQuery) {
    _searchQuery = newQuery;
    _searchUsers();
  }

  void _searchUsers() async {
    try {
      var response = await http.get(
        Uri.parse(
            "http://10.0.2.2:3000/api/first-responder/search?username=$_searchQuery"),
        headers: {
          'Content-Type': 'application/json',
          if (_accessToken != null) 'x-auth-token': _accessToken!
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _searchResults = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        title: const Row(
          children: [
            Text("Add Supervisee"),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.people, size: 32),
            )
          ],
        ),
        backgroundColor: const Color(0xFFadd8e6),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
                hintText: "Search", suffixIcon: Icon(Icons.search)),
            onChanged: _updateSearchQuery,
          ),
        ),
        _searchQuery == ""
            ? const Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Search First Responders by their Username")
                    ]),
              )
            : Expanded(child: UserList(_searchResults))
      ]),
    );
  }
}

class UserList extends StatefulWidget {
  final List _users;
  // const UserList({super.key});
  const UserList(this._users, {super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget._users.length,
      itemBuilder: (context, index) {
        var user = widget._users[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            child: Row(children: [
              Expanded(
                  child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"),
                ),
                title: Text(user["username"]),
                subtitle: Text(user["firstName"] + " " + user["lastName"]),
                // trailing: const Icon(Icons.open_in_new, size: 22),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => AddUserPage(user)))),
              )),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(Icons.open_in_new, size: 22))
            ]),
          ),
        );
      },
    );
  }
}
