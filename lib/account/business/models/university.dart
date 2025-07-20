import 'dart:convert';

/// Convertit une chaîne JSON en un objet University.
University universityFromJson(String str) => University.fromJson(json.decode(str));

/// Convertit un objet University en une chaîne JSON.
String universityToJson(University data) => json.encode(data.toJson());

class University {
  final String name;
  final String city;

  University({
    required this.name,
    required this.city,
  });

  /// Crée un objet University à partir d'une carte JSON.
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      city: json['city'],
    );
  }

  /// Convertit l'objet University en une carte JSON.
  Map<String, dynamic> toJson() => {
    'name': name,
    'city': city,
  };
}