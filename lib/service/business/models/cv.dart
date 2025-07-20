import 'dart:convert';

Cv coverPageFromJson(String str) => Cv.fromJson(json.decode(str));
String coverPageToJson(Cv data) => json.encode(data.toJson());

class Cv {
  final String id;
  final String ownerId;
  final List<String> experiences;
  final List<String> skills;
  final DateTime createdAt;

  Cv({
    required this.id,
    required this.ownerId,
    required this.experiences,
    required this.skills,
    required this.createdAt,
  });

  factory Cv.fromJson(Map<String, dynamic> json) {
    return Cv(
      id: json['id'],
      ownerId: json['ownerId'],
      experiences: List<String>.from(json['experiences']),
      skills: List<String>.from(json['skills']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ownerId': ownerId,
    'experiences': experiences,
    'skills': skills,
    'createdAt': createdAt.toIso8601String(),
  };
}
