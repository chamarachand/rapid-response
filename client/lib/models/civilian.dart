class Civilian {
  String? firstName;
  String? lastName;
  String? nicNo;
  String? gender;
  DateTime? birthDay;
  String? phoneNumber;
  String? email;
  String? username;
  String? password;

  Civilian({
    this.firstName,
    this.lastName,
    this.nicNo,
    this.gender,
    this.birthDay,
    this.phoneNumber,
    this.email,
    this.username,
    this.password,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'nicNo': nicNo,
  //     'gender': gender,
  //     'birthDay':
  //         birthDay?.toIso8601String(), // Convert DateTime to ISO 8601 string
  //     'phoneNumber': phoneNumber,
  //     'email': email,
  //     'username': username,
  //     'password': password,
  //   };
  // }
}
