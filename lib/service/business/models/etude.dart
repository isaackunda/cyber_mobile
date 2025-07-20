import 'dart:convert';

Etude etudeFromJson(String str) => Etude.fromJson(json.decode(str));
String etudeToJson(Etude data) => json.encode(data.toJson());

class Etude {
  final String titre;
  final String specialite;
  final String etablissement;
  final String dateDebut;
  final String dateFin;
  final String description;
  final bool enFormation;

  const Etude({
    required this.titre,
    required this.specialite,
    required this.etablissement,
    required this.dateDebut,
    required this.dateFin,
    this.description = '',
    this.enFormation = false,
  });

  factory Etude.fromJson(Map<String, dynamic> json) {
    return Etude(
      titre: json['titre'],
      specialite: json['specialite'],
      etablissement: json['etablissement'],
      dateDebut: json['dateDebut'],
      dateFin: json['dateFin'],
      description: json['description'],
      enFormation: json['enFormation'],
    );
  }

  Map<String, dynamic> toJson() => {
    'titre': titre,
    'specialite': specialite,
    'etablissement': etablissement,
    'dateDebut': dateDebut,
    'dateFin': dateFin,
    'description': description,
  };
}
