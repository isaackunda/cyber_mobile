import 'dart:convert';

Template templateFromJson(String str) => Template.fromJson(json.decode(str));
String templateToJson(Template data) => json.encode(data.toJson());

class Template {
  final String id;
  final String name;
  final String previewUrl;

  Template({
    required this.id,
    required this.name,
    required this.previewUrl,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'],
      name: json['name'],
      previewUrl: json['previewUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'previewUrl': previewUrl,
  };
}
