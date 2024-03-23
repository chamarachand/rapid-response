import 'package:client/pages/main_page/main_screen.dart';
import 'package:client/pages/main_page/main_screen_fr.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/link_accounts/first_responders/link_accounts_home_fr.dart';
import 'package:client/pages/link_accounts/civilians/link_account_home.dart'; 

//creating a common BottomNavigationBar for tha application.
class BottomNavigationBarUtils {
  // using the bool isFirstResponder to differenciate the pages for civilians and first responders
  static Widget buildBottomNavigationBar(BuildContext context, int selectedIndex, Function(int) onItemTapped, bool isFirstResponder) {
    // returning the built BottomNavigationBar based on the logic given by the BuildContext context, int selectedIndex, Function(int) onItemTapped, and bool isFirstResponder
    return BottomNavigationBar(
      // setting background color and selected button for the navi bar
      backgroundColor: const Color(0xFFD9D9D9),
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      // defining each item of the navi bar
      items: [
        // creating a BottomNavigationBarItem for the link_accounts pages
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.link),
            // navigating on pressed to LinkAccountHomeFR and LinkAccountHome based on user type 
            onPressed: () {
              // using if condition to direct user to LinkAccountHomeFR if bool isFirstResponder is true
              if (isFirstResponder == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const LinkAccountHomeFR()),
                  ),
                );
              // using else if condition to direct user to LinkAccountHome if bool isFirstResponder is false
              } else if (isFirstResponder == false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const LinkAccountHome()),
                  ),
                );
              }
            },
          ),
          // adding 'Link' label to navi button
          label: 'Link',
        ),
        // creating a BottomNavigationBarItem for the main_page pages
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.home),
            // navigating on pressed to MainMenuFR and MainMenu based on user type 
            onPressed: () {
              // using if condition to direct user to MainMenuFR if bool isFirstResponder is true
              if (isFirstResponder == true) {
                // removing previous routes to disable user from going to previous pages
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MainMenuFR()),
                  (route) => false);
              // using else if condition to direct user to MainMenu if bool isFirstResponder is false
              } else if (isFirstResponder == false) {
                // removing previous routes to disable user from going to previous pages
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MainMenu()),
                  (route) => false);
              }
            },
          ),
          // adding 'Home' label to navi button
          label: 'Home',
        ),
        // creating a BottomNavigationBarItem for the history page
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              
            },
          ),
          // adding 'History' label to navi button
          label: 'History',
        ),
      ],
    );
  }
}