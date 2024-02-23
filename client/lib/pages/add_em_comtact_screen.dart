import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  List _searchResults = [];

  void _updateSearchQuery(String newQuery) {
    _searchQuery = newQuery;
    _searchUsers();
  }

  void _searchUsers() async {
    try {
      var response = await http.get(
        Uri.parse(
            "http://10.0.2.2:3000/api/civilian/search?username=$_searchQuery"),
        headers: {
          'Content-Type': 'application/json',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text("Add Emergency"),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.people, size: 32),
            )
          ],
        ),
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
        Expanded(child: UserList(_searchResults))
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
              )),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.open_in_new),
              )
            ]),
          ),
        );
      },
    );
  }
}
