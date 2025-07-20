import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));
String templateToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String university;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.university,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phoneNumber: json['phoneNumber'],
      university: json['university'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'firstname': firstname,
    'lastname': lastname,
    'phoneNumber': phoneNumber,
    'university': university,
  };
}
