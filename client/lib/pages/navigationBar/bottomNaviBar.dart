import 'package:client/pages/main_screen.dart';
import 'package:client/pages/main_screen_fr.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/link_accounts/first_responders/link_accounts_home_fr.dart';
import 'package:client/pages/link_accounts/civilians/link_account_home.dart'; 

class BottomNavigationBarUtils {
  static Widget buildBottomNavigationBar(BuildContext context, int selectedIndex, Function(int) onItemTapped, bool isFirstResponder) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFD9D9D9),
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.link),
            onPressed: () {
              if (isFirstResponder == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const LinkAccountHomeFR()),
                  ),
                );
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
          label: 'Link',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              if (isFirstResponder == true) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MainMenuFR()),
                  (route) => false);
              } else if (isFirstResponder == false) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MainMenu()),
                  (route) => false);
              }
            },
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              
            },
          ),
          label: 'History',
        ),
      ],
    );
  }
}