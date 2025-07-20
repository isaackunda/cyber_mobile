import 'dart:convert';

String coverPageDataToJson(CoverPageData data) => json.encode(data.toJson());

class CoverPageData {
  final String title;
  final String content;
  final String templateId;

  CoverPageData({
    required this.title,
    required this.content,
    required this.templateId,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'templateId': templateId,
  };
}
