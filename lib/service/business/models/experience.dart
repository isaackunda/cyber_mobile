import 'dart:convert';

Experience experienceFromJson(String str) =>
    Experience.fromJson(json.decode(str));
String experiencePageToJson(Experience data) => json.encode(data.toJson());

class Experience {
  final String titre;
  final String entreprise;
  final String dateDebut;
  final String dateFin;
  final String description;
  final bool enPoste;

  const Experience({
    required this.titre,
    required this.entreprise,
    required this.dateDebut,
    required this.dateFin,
    this.description = '',
    this.enPoste = false,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      titre: json['titre'],
      entreprise: json['entreprise'],
      dateDebut: json['dateDebut'],
      dateFin: json['dateFin'],
      description: json['description'],
      enPoste: json['enPoste'],
    );
  }

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'entreprise': entreprise,
    'dateDebut': dateDebut,
    'dateFin': dateFin,
    'description': description,
    'enPoste': enPoste,
  };
}
