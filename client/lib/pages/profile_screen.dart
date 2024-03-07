import 'package:flutter/material.dart';
import 'SOS_page.dart';
import 'report_incident_screen.dart';
import 'package:client/pages/welcome_screen.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/link_accounts/add_em_comtact_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  ProfileScreen createState() => ProfileScreen();
}

class ProfileScreen extends State<Profile> {
  int _selectedIndex = 1;
  
  final profileImg = "https://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png";

  var _firstName = "";

  void _loadToken() async {
    final accessToken = await UserSecureStorage.getAccessToken();

    if (accessToken != null) {
      var decodedToken = JwtDecoder.decode(accessToken);
      // Access token claims
      setState(() {
        _firstName = decodedToken["firstName"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (BuildContext context) {
                double appBarHeight = AppBar().preferredSize.height;
                return Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: SizedBox(
                      width: appBarHeight - 20,
                      height: appBarHeight - 20,
                      child: const Text(
                        "User Profile",
                        ),
                    ),
                    onPressed: () {},
                  ),
                );
              },
            ),
            Builder(
              builder: (BuildContext context) {
                double appBarHeight = AppBar().preferredSize.height;
                return Container(
                  alignment: Alignment.center,
                  child: PopupMenuButton(
                      icon: SizedBox(
                        height: appBarHeight,
                        child: Row(
                          children: [
                            const Icon(Icons.person),
                            Text(
                              _firstName,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                          ],
                        ),
                      ),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width: appBarHeight - 20,
                                  height: appBarHeight - 20,
                                  child: Image.asset('assets/RR_logo.png'),
                                  ), 
                              const SizedBox(height: 25),
                              ListTile(
                                title: const Center(child: Text('Logout')),
                                onTap: () {
                                  UserSecureStorage.deleteAccessToken();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WelcomePage()),
                                      (route) => false);
                                },
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                );
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFF8497B0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: ClipOval(
                child: Image.network(
                  profileImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     const Icon(Icons.person),
          //     Column(
          //       children: [
          //         Row(
          //           children: [
          //             const Text(
          //               "Name"
          //             ),
          //             IconButton(
          //               onPressed: (){}, 
          //               icon: const Icon(Icons.update),
          //             ),
          //           ],
          //         ),
          //         const Text(
          //           "Sahan_01"
          //         ),
          //       ],
          //     )
          //   ],
          // ),
          const Text(
            "Username: ",
            style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
          ),
          Text(
            _firstName +" "+ _firstName,
            style: const TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
          ),
          Text(
            "NIC Number: ",
            style: const TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
          ),
          Text(
            "Phone Number: ",
            style: const TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
          ),
          Text(
            "Email Address: ",
            style: const TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
          ),
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