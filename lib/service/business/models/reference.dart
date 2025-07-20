import 'dart:convert';

Reference referenceFromJson(String str) => Reference.fromJson(json.decode(str));
String referenceToJson(Reference data) => json.encode(data.toJson());

class Reference {
  final String name;
  final String titre;
  final String phoneNumber;
  final String link;

  Reference({
    required this.name,
    this.titre = '',
    this.phoneNumber = '',
    this.link = '',
  });

  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      name: json['name'],
      titre: json['titre'],
      phoneNumber: json['phoneNumber'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'titre': titre,
    'phoneNumber': phoneNumber,
    'link': link,
  };
}
