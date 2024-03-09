enum UserTypes { civilian, firstResponder }

class UserType {
  static UserTypes? _userType;

  UserType(UserTypes userType);

  // Getter method to retrieve user type
  static UserTypes? getUserType() {
    return _userType;
  }

  // Setter method to set user type
  static void setUserType(UserTypes? userType) {
    _userType = userType;
  }
}
