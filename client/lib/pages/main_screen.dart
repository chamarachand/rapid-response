import 'package:client/pages/profile_screen.dart';
import 'package:client/pages/registered_locations.dart';
import 'package:flutter/material.dart';
import 'SOS_page.dart';
import 'report_incident_screen.dart';
import 'package:client/pages/welcome_screen.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/link_accounts/link_account_home.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});
  @override
  MainMenuScreen createState() => MainMenuScreen();
}

class MainMenuScreen extends State<MainMenu> {
  int _selectedIndex = 1;

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
                      child: Image.asset('assets/RR_logo.png'),
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
                                title: const Center(child: Text('View Profile')),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Profile())),
                              ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SOSpage())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                child: const Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportScreen())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 33, vertical: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                child: const Text(
                  'Report',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              // Implement Map functionality
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 138, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'MAP',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterLocation())),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 29, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'Registered Locations',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: ListView.builder(
                itemCount: 10, // Example notification count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Notification $index'),
                    // Add more details here if needed
                  );
                },
              ),
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
                          builder: ((context) => LinkAccountHome())));
                },
              ),
              label: 'Link',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  _onItemTapped(1);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const MainMenu())));
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
