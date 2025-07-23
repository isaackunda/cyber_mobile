import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));
String templateToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  final String sessionId;
  final String email;
  final String name;
  final String firstname;
  final String phoneNumber;
  final String university;

  const UserProfile({
    required this.sessionId,
    required this.email,
    required this.name,
    required this.firstname,
    required this.phoneNumber,
    required this.university,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      sessionId: json['session_id'],
      email: json['email'],
      name: json['name'],
      firstname: json['firstname'],
      phoneNumber: json['phoneNumber'],
      university: json['university'],
    );
  }

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'email': email,
    'name': name,
    'firstname': firstname,
    'phoneNumber': phoneNumber,
    'university': university,
  };
}
