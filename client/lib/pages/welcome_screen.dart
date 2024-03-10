import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'add_event.dart';
import 'register_screen_1.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: null,
        ),
        body: Container(
          child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(253, 179, 179, 1),
                    Color.fromRGBO(255, 189, 189, 1),
                    Color.fromRGBO(250, 213, 213, 1),
                    Color.fromRGBO(255, 230, 230, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset("assets/doctor_2.png"),
                    ),
                    const SizedBox(
                      height: 95,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(51, 153, 255, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.85,
                              MediaQuery.of(context).size.height * 0.08),
                        ),
                        child: const Text(
                          "Sign in",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserTypeSelection())),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(51, 153, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            //padding: EdgeInsets.symmetric(horizontal: 120, vertical: 20)
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.85,
                                MediaQuery.of(context).size.height * 0.08)),
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Center(
                        child: ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const add_event())),
                            child: const Text("To Add Event (Test)"))),
                  ])),
        ));
  }
}
