import 'package:flutter/material.dart';
import '../models/civilian.dart';

class RegistrationProvider extends ChangeNotifier {
  Civilian civilian = Civilian();

  void updateCivilian(Civilian civilian) {
    this.civilian = civilian;
    notifyListeners();
  }
}
