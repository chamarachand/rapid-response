import 'package:client/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:client/authenticator.dart';
import 'package:provider/provider.dart';
import 'providers/registration_provider.dart';
import 'api/firebase_api.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // if isAndroid??
      options: const FirebaseOptions(
          apiKey: 'AIzaSyB3-XWUh108BvTcdwiuC1jJgTtJGB0H1zQ',
          appId: '1:198757308599:android:65fe518f39f3c266769532',
          messagingSenderId: '198757308599',
          projectId: 'rapid-response-802d3')
    );

  await FirebaseAPI().initNotifications();
  flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings()));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegistrationProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC06565),
              foregroundColor: Colors.white,
            ))),
        home: const AuthenticationWrapper(),
      ),
    );
  }
}
