import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';

class ProfileFr extends StatefulWidget {
  const ProfileFr({super.key});
  @override
  ProfileScreenFr createState() => ProfileScreenFr();
}

class ProfileScreenFr extends State<ProfileFr> {
  // initializing the global variables used in the page
  int _selectedIndex = 1;   // variable used by ButtomNavigationBar
  // sample imaged used as profile image
  final profileImg = 
      "https://static.vecteezy.com/system/resources/previews/005/164/094/non_2x/nurse-professional-using-face-mask-with-stethoscope-free-vector.jpg";
  // variables used to store user data
  var _username = "";
  var _firstName = "";
  var _lastName = "";
  var _nicNo = "";
  var _phnNo = "";
  var _email = "";
  var _type = "";
  var _workId = "";
  var _workAddress = "";

  // creating widget to load user token when initaited
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

  // initiating widgets
  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // creating widget to build user information display
  @override
  Widget buildUserInfoDisplay(IconData iconData, String title, String data) {  // getting icon, title and details relavent to display
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
          // icon button to enable future implimentation of user info updating
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    ));
  }

  // creating the main widget
  @override
  Widget build(BuildContext context) {
    // using Scaffold to build user profile screen
    return Scaffold(
      // creating the Appbar for user profile screen
      appBar: AppBar(
        // adding screen title
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
      // creating body of Scafold using a column
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // using stack to display user image and a update image button on top of it
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
                // creating button for updating profile picture functionality that will be implimented in the future
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
          // creating the information displays with user information
          buildUserInfoDisplay(Icons.person, "Username", _username),
          buildUserInfoDisplay(
              Icons.info_outline, "Name", "$_firstName $_lastName"),
          buildUserInfoDisplay(Icons.credit_card, "NIC Number", _nicNo),
          buildUserInfoDisplay(Icons.phone, "Contact Number", _phnNo),
          buildUserInfoDisplay(Icons.email, "Email Address", _email),
          buildUserInfoDisplay(Icons.emergency, "First Responder Type", _type),
          buildUserInfoDisplay(Icons.perm_identity_sharp, "Work ID", _workId),
          buildUserInfoDisplay(
              Icons.location_city, "Work Address", _workAddress),
        ],
      ),
      // applying navi bar using buildBottomNavigationBar()
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        true, // passing as true since page belogs to FR
      ),
    );
  }

  // creating method to change selected index on tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
