import 'dart:convert';

Formation formationFromJson(String str) => Formation.fromJson(json.decode(str));
String formationToJson(Formation data) => json.encode(data.toJson());

class Formation {
  final String titre;
  final String certificat;
  final String etablissement;
  final String dateDebut;
  final String dateFin;
  final String description;
  final bool enFormation;

  Formation({
    this.titre = '',
    required this.certificat,
    required this.etablissement,
    required this.dateDebut,
    required this.dateFin,
    this.description = '',
    this.enFormation = false,
  });

  factory Formation.fromJson(Map<String, dynamic> json) {
    return Formation(
      titre: json['titre'],
      certificat: json['certificat'],
      etablissement: json['etablissement'],
      dateDebut: json['dateDebut'],
      dateFin: json['dateFin'],
      description: json['description'],
      enFormation: json['enFormation'],
    );
  }

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'certificat': certificat,
    'etablissement': etablissement,
    'dateDebut': dateDebut,
    'dateFin': dateFin,
    'description': description,
  };
}
