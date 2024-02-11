class Civilian {
  String? firstName;
  String? lastName;
  String? nicNumber;
  String? gender;
  DateTime? dateOfBirth;
  String? mobileNumber;
  String? email;
  String? username;
  String? password;

  Civilian({
    this.firstName,
    this.lastName,
    this.nicNumber,
    this.gender,
    this.dateOfBirth,
    this.mobileNumber,
    this.email,
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nicNumber': nicNumber,
      'gender': gender,
      'dateOfBirth':
          dateOfBirth?.toIso8601String(), // Convert DateTime to ISO 8601 string
      'mobileNumber': mobileNumber,
      'email': email,
      'username': username,
      'password': password,
    };
  }
}
