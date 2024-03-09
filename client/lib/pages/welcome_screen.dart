import 'package:client/pages/add_event.dart';
import 'package:client/pages/report_incident_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen_2.dart';
import 'SOS_page.dart';
import 'link_accounts/add_em_comtact_screen.dart';
import 'main_screen.dart';
import 'register_screen_1.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome Page"),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage())),
                    child: const Text("Login"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainMenu())),
                    child: const Text("Main menu"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserTypeSelection())),
                    child: const Text("Register"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SOSpage())),
                    child: const Text("SOS Page (Test)"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportScreen())),
                    child: const Text("To Report Screen (Test)"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const add_event())),
                    child: const Text("To Add Event (Test)"))),
            Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserSearchPage())),
                    child: const Text("Add Emergency Contacts")))
          ],
        ));
  }
}
