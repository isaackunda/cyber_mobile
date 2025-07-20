import 'dart:convert';

String cvDataToJson(CvData data) => json.encode(data.toJson());

class CvData {
  final List<String> experiences;
  final List<String> skills;
  final String templateId;

  CvData({
    required this.experiences,
    required this.skills,
    required this.templateId,
  });

  Map<String, dynamic> toJson() => {
    'experiences': experiences,
    'skills': skills,
    'templateId': templateId,
  };
}
