import 'package:cyber_mobile/service/business/models/logiciel.dart';
import 'package:cyber_mobile/service/business/models/language.dart';
import 'package:cyber_mobile/service/business/models/skill.dart';

import '../../business/models/cv_modele.dart';
import '../../business/models/etude.dart';
import '../../business/models/experience.dart';
import '../../business/models/formation.dart';
import '../../business/models/reference.dart';
import '../../business/models/user_perso_infos.dart';

class CvState {
  final List<CvModele> cvs;
  final String selectedModelId;
  final UserPersoInfos userPersoInfos;
  final List<Experience> experiences;
  final List<Etude> etudes;
  final List<Formation> formations;
  final List<Skill> skills;
  final List<Language> languages;
  final List<Logiciel> logiciels;
  final List<Reference> references;

  CvState({
    this.cvs = const [
      CvModele(name: 'modern_cv', image: 'images/1.PNG', id: 1),
      CvModele(name: 'classic_cv', image: 'images/2.PNG', id: 2),
    ],
    this.selectedModelId = '',
    this.userPersoInfos = const UserPersoInfos(
      name: 'N/A',
      sexe: 'N/A',
      email: 'N/A',
      phoneNumber: 'N/A',
      dateOfBirth: 'N/A',
      placeOfBirth: 'N/A',
      nationality: 'N/A',
      maritalStatus: 'N/A',
      address: 'N/A',
      profil: 'N/A',
    ),
    this.experiences = const [],
    this.etudes = const [],
    this.formations = const [],
    this.skills = const [],
    this.languages = const [],
    this.logiciels = const [],
    this.references = const [],
  });

  CvState copyWith({
    List<CvModele>? cvs,
    String? selectedModelId,
    UserPersoInfos? userPersoInfos,
    List<Experience>? experiences,
    List<Etude>? etudes,
    List<Formation>? formations,
    List<Skill>? skills,
    List<Language>? languages,
    List<Logiciel>? logiciels,
    List<Reference>? references,
  }) {
    return CvState(
      cvs: cvs ?? this.cvs,
      selectedModelId: selectedModelId ?? this.selectedModelId,
      userPersoInfos: userPersoInfos ?? this.userPersoInfos,
      experiences: experiences ?? this.experiences,
      etudes: etudes ?? this.etudes,
      formations: formations ?? this.formations,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      logiciels: logiciels ?? this.logiciels,
      references: references ?? this.references,
    );
  }
}
