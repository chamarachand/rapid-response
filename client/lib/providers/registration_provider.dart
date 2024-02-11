import 'package:flutter/material.dart';
import '../models/civilian.dart';

class RegistrationProvider extends ChangeNotifier {
  final Civilian _civilian = Civilian();

  Civilian get civilian => _civilian;

  void updateUser(
      {String? firstName,
      String? lastName,
      String? nicNumber,
      String? gender,
      DateTime? dateOfBirth,
      String? mobileNumber,
      String? email,
      String? username,
      String? password}) {
    _civilian.firstName = firstName ?? _civilian.firstName;
    _civilian.lastName = lastName ?? _civilian.lastName;
    _civilian.nicNumber = nicNumber ?? _civilian.nicNumber;
    _civilian.gender = gender ?? _civilian.gender;
    _civilian.dateOfBirth = dateOfBirth ?? _civilian.dateOfBirth;
    _civilian.mobileNumber = mobileNumber ?? _civilian.mobileNumber;
    _civilian.email = email ?? _civilian.email;
    _civilian.username = username ?? _civilian.username;
    _civilian.password = password ?? _civilian.password;
    notifyListeners();
  }
}
