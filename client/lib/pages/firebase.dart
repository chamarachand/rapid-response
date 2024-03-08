import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future <void> signInUserAnonymously() async{
  try{
    final UserCredential = await FirebaseAuth.instance.signInAnonymously();
    print("signed in with tempororary account, UID: ${UserCredential.user?.uid}");

  } catch (e){
    print(e);
  }
}