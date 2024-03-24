import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:client/storage/user_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/pages/navigation_bar/bottom_navigation_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  ProfileScreen createState() => ProfileScreen();
}

class ProfileScreen extends State<Profile> {
  // initializing the global variables used in the page
  int _selectedIndex = 1;  // variable used by ButtomNavigationBar
  File? image;
  // sample imaged used as profile image
  String profileImg =
      "https://th.bing.com/th/id/R.7e652b13150cba9f278a112dd4b3703e?rik=KdflSdVwJBl4zg&pid=ImgRaw&r=0";
  // variables used to store user data
  var _username = "";
  var _firstName = "";
  var _lastName = "";
  var _nicNo = "";
  var _phnNo = "";
  var _email = "";

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
          Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  // checking whether user has updated profile pic and showing it if updated
                  child: ClipOval(
                    child: image != null
                        ? Image.file(
                            image!,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => popup(),
                    );
                  },
                  // creating button for updating profile picture
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
        ],
      ),
      // applying navi bar using buildBottomNavigationBar()
      bottomNavigationBar: BottomNavigationBarUtils.buildBottomNavigationBar(
        context,
        _selectedIndex,
        _onItemTapped,
        false, // passing as false since page belogs to civilain
      ),
    );
  }
  
  // creating method to change selected index on tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget popup() => AlertDialog(
        title: const Text('Camera Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                // Code to handle taking a photo
                pickImage1(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                // Code to choose from gallery
                pickImage1(ImageSource.gallery);
              },
            ),
          ],
        ),
      );

  Future pickImage1(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
      final downloadUrl = await uploadImageToFirebase();
      if (downloadUrl != null) {
        print(
            "Profile Picture Send to the fire base storage and downlode link: $downloadUrl");
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<String?> uploadImageToFirebase() async {
    if (image == null) return null; // Early exit if no image

    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("Profile_Pic/${DateTime.now()}.jpg");

    try {
      await imagesRef.putFile(image!); // Upload!
      final downloadURL = await imagesRef.getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      // Handle errors (consider showing a dialog or a snackbar)
      print("Upload failed: $e");
      return null;
    }
  }
}
