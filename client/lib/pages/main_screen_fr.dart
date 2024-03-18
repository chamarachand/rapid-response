import 'package:client/pages/profile_screen_fr.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/welcome_screen.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/link_accounts/first_responders/link_accounts_home_fr.dart';

class MainMenuFR extends StatefulWidget {
  const MainMenuFR({super.key});
  @override
  MainMenuScreenFR createState() => MainMenuScreenFR();
}

class MainMenuScreenFR extends State<MainMenuFR> {
  bool _availability = false;
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
                                    builder: (context) => const ProfileFr())),
                          ),
                          ListTile(
                            title: const Center(child: Text('Logout')),
                            onTap: () {
                              UserSecureStorage.deleteAccessToken();
                              UserSecureStorage.deleteIdToken();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomePage()),
                                  (route) => false);
                            },
                          ),
                        ],
                      )),
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
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text(
              'Availability',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            value: _availability,
            onChanged: (value) {
              setState(() {
                _availability = value; // Toggle the _availability boolean value
                // Implement Availability functionality here
              });
            },
            activeColor: Colors.green, 
            inactiveTrackColor: Colors.red, 
            subtitle: _availability ? const Text('Available') : const Text('Unavailable'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Implement Add event functionality
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 119, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'Add Event',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              // Implement incident posts functionality
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC06565),
                padding:
                    const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
            child: const Text(
              'Incident Posts',
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
                          builder: ((context) => const LinkAccountHome())));
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
                          builder: ((context) => const MainMenuFR())));
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
