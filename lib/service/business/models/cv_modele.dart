import 'dart:convert';

CvModele cvModeleFromJson(String str) => CvModele.fromJson(json.decode(str));
String cvModelePageToJson(CvModele data) => json.encode(data.toJson());

class CvModele {
  final int id;
  final String name;
  final String image;

  const CvModele({required this.id, required this.name, required this.image});

  factory CvModele.fromJson(Map<String, dynamic> json) {
    return CvModele(id: json['id'], name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}
