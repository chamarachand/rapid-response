import 'package:flutter/material.dart';
import '../models/civilian.dart';
import '../models/first_responder.dart';

class RegistrationProvider extends ChangeNotifier {
  final Civilian _civilian = Civilian();
  final FirstResponder _firstResponder = FirstResponder();

  Civilian get civilian => _civilian;
  FirstResponder get firstResponder => _firstResponder;

  void updateCivilian(
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
    _civilian.nicNo = nicNumber ?? _civilian.nicNo;
    _civilian.gender = gender ?? _civilian.gender;
    _civilian.birthDay = dateOfBirth ?? _civilian.birthDay;
    _civilian.phoneNumber = mobileNumber ?? _civilian.phoneNumber;
    _civilian.email = email ?? _civilian.email;
    _civilian.username = username ?? _civilian.username;
    _civilian.password = password ?? _civilian.password;
    notifyListeners();
  }

  void updateFirstResponder(
      {String? firstName,
      String? lastName,
      String? nicNumber,
      String? gender,
      DateTime? dateOfBirth,
      String? mobileNumber,
      String? email,
      String? type,
      String? workId,
      String? workAddress,
      String? username,
      String? password}) {
    _firstResponder.firstName = firstName ?? _firstResponder.firstName;
    _firstResponder.lastName = lastName ?? _firstResponder.lastName;
    _firstResponder.nicNo = nicNumber ?? _firstResponder.nicNo;
    _firstResponder.gender = gender ?? _firstResponder.gender;
    _firstResponder.birthDay = dateOfBirth ?? _firstResponder.birthDay;
    _firstResponder.phoneNumber = mobileNumber ?? _firstResponder.phoneNumber;
    _firstResponder.type = type ?? _firstResponder.type;
    _firstResponder.email = email ?? _firstResponder.email;
    _firstResponder.username = username ?? _firstResponder.username;
    _firstResponder.password = password ?? _firstResponder.password;
    notifyListeners();
  }
}
