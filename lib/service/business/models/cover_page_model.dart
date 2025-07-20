import 'dart:convert';

CoverPageModel coverPageFromJson(String str) =>
    CoverPageModel.fromJson(json.decode(str));
String coverPageToJson(CoverPageModel data) => json.encode(data.toJson());

class CoverPageModel {
  final String id;
  final String title;
  final String ownerId;
  final String content;
  final String path;
  final DateTime? createdAt;

  const CoverPageModel({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.content,
    required this.path,
    this.createdAt,
  });

  factory CoverPageModel.fromJson(Map<String, dynamic> json) {
    return CoverPageModel(
      id: json['id'],
      title: json['title'],
      ownerId: json['ownerId'],
      content: json['content'],
      path: json['path'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'ownerId': ownerId,
    'content': content,
    'path': path,
    'createdAt': createdAt?.toIso8601String(),
  };
}
