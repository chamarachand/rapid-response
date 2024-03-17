import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/link_accounts/civilians/search_civilian.dart';

class ProfileFr extends StatefulWidget {
  const ProfileFr({super.key});
  @override
  ProfileScreenFr createState() => ProfileScreenFr();
}

class ProfileScreenFr extends State<ProfileFr> {
  int _selectedIndex = 1;

  final profileImg =
      "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";

  var _username = "";
  var _firstName = "";
  var _lastName = "";
  var _nicNo = "";
  var _phnNo = "";
  var _email = "";
  var _type = "";
  var _workId = "";
  var _workAddress = "";

  void _loadToken() async {
    final idToken = await UserSecureStorage.getIdToken();

    if (idToken != null) {
      var decodedToken = JwtDecoder.decode(idToken);
      // Access token claims
      setState(() {
        _username = decodedToken["username"];
        _firstName = decodedToken["firstName"];
        _lastName = decodedToken["lastName"];
        _nicNo = decodedToken["nicNo"];
        _phnNo = decodedToken["phnNo"];
        _email = decodedToken["email"];
        _type = decodedToken["type"];
        _workId = decodedToken["workId"];
        _workAddress = decodedToken["workAddress"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget buildUserInfoDisplay(IconData iconData, String title, String data) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              iconData,
              size: 35,
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 70, 70, 70),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                data,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          )),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: const Color(0xFF8497B0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipOval(
                    child: Image.network(
                      profileImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 100,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.black,
                  ),
                  child: const Icon(Icons.camera_alt),
                ),
              )
            ],
          ),
          buildUserInfoDisplay(Icons.person, "Username", _username),
          buildUserInfoDisplay(
              Icons.info_outline, "Name", "$_firstName $_lastName"),
          buildUserInfoDisplay(Icons.credit_card, "NIC Number", _nicNo),
          buildUserInfoDisplay(Icons.phone, "Contact Number", _phnNo),
          buildUserInfoDisplay(Icons.email, "Email Address", _email),
          buildUserInfoDisplay(Icons.emergency, "First Responder Type", _type),
          buildUserInfoDisplay(Icons.perm_identity_sharp, "Work ID", _workId),
          buildUserInfoDisplay(Icons.location_city, "Work Address", _workAddress),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFD9D9D9),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.link),
                onPressed: () {
                  _onItemTapped(0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const UserSearchPage())));
                },
              ),
              label: 'Link',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
              label: 'History',
            ),
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
