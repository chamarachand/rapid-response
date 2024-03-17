validatePassword(String value) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  if (!regex.hasMatch(value)) {
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    if (value.length > 255) {
      return "Password too long";
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Password should have atleast 1 uppercase letter";
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return "Password should have atleast 1 lowercase letter";
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Password should have atleast 1 digit";
    }

    if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      return "Password should have atleast 1 special character";
    }
  }
  return null;
}
