import 'dart:convert';

String registerRequestDataToJson(RegisterRequest data) => json.encode(data.toJson());

class RegisterRequest {
  final String email;
  final String password;
  final String name;
  String? firstname;
  String? lastname;
  final String phoneNumber;
  final String university;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.firstname,
    this.lastname,
    required this.phoneNumber,
    required this.university,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'firstname': firstname,
      'lastname': lastname,
      'phoneNumber': phoneNumber,
      'university': university,
    };
  }
}
