class FirstResponder {
  String? firstName;
  String? lastName;
  String? nicNo;
  String? gender;
  DateTime? birthDay;
  String? phoneNumber;
  String? email;
  String? type;
  String? workId;
  String? workAddress;
  String? username;
  String? password;

  FirstResponder({
    this.firstName,
    this.lastName,
    this.nicNo,
    this.gender,
    this.birthDay,
    this.phoneNumber,
    this.email,
    this.type,
    this.workId,
    this.workAddress, // work plece
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nicNo': nicNo,
      'gender': gender,
      'birthDay':
          birthDay?.toIso8601String(), // Convert DateTime to ISO 8601 string
      'phoneNumber': phoneNumber,
      'email': email,
      'type': type,
      'workId': workId,
      'workAddress': workAddress,
      'username': username,
      'password': password,
    };
  }
}
