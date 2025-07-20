import 'package:cyber_mobile/service/business/models/experience.dart';
import 'package:cyber_mobile/service/business/models/formation.dart';
import 'package:cyber_mobile/service/business/models/language.dart';
import 'package:cyber_mobile/service/business/models/reference.dart';
import 'package:cyber_mobile/service/business/models/user_perso_infos.dart';
import 'package:cyber_mobile/service/ui/pages/cv_state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../business/models/etude.dart';
import '../../business/models/logiciel.dart';
import '../../business/models/skill.dart';

part 'cv_ctrl.g.dart';

@riverpod
class CvCtrl extends _$CvCtrl {
  @override
  CvState build() {
    return CvState();
  }

  void saveUserPersonalInfo(UserPersoInfos userData) {
    //
    state = state.copyWith(userPersoInfos: userData);

    if (kDebugMode) {
      print('object');
    }
  }

  void deleteUserPersonalInfo() {
    var upi = UserPersoInfos(
      name: 'N/A',
      sexe: 'N/A',
      email: 'N/A',
      phoneNumber: 'N/A',
      dateOfBirth: 'N/A',
      placeOfBirth: 'N/A',
      nationality: 'N/A',
    );

    state = state.copyWith(userPersoInfos: upi);
  }

  void saveExperience(Experience exp) {
    final List<Experience> data = [...state.experiences]; // copie propre
    data.add(exp);

    state = state.copyWith(experiences: data);
  }

  void deleteExp(int index) {
    final newExperiences = List<Experience>.from(state.experiences)
      ..removeAt(index);

    state = state.copyWith(experiences: newExperiences);
  }

  void saveEtude(Etude exp) {
    final List<Etude> data = [...state.etudes]; // copie propre
    data.add(exp);

    state = state.copyWith(etudes: data);
  }

  void deleteEtude(int index) {
    final newEtudes = List<Etude>.from(state.etudes)..removeAt(index);

    state = state.copyWith(etudes: newEtudes);
  }

  void saveFormation(Formation formation) {
    final List<Formation> data = [...state.formations]; // copie propre
    data.add(formation);

    state = state.copyWith(formations: data);
  }

  void deleteFormation(int index) {
    final newFormations = List<Formation>.from(state.formations)
      ..removeAt(index);

    state = state.copyWith(formations: newFormations);
  }

  void saveSkill(Skill skill) {
    final List<Skill> data = [...state.skills]; // copie propre
    data.add(skill);

    state = state.copyWith(skills: data);
  }

  void deleteSkill(int index) {
    final newSkills = List<Skill>.from(state.skills)..removeAt(index);

    state = state.copyWith(skills: newSkills);
  }

  void saveLanguage(Language language) {
    final List<Language> data = [...state.languages]; // copie propre
    data.add(language);

    state = state.copyWith(languages: data);
  }

  void deleteLanguage(int index) {
    final newLanguages = List<Language>.from(state.languages)..removeAt(index);

    state = state.copyWith(languages: newLanguages);
  }

  void saveLogiciel(Logiciel interet) {
    final List<Logiciel> data = [...state.logiciels]; // copie propre
    data.add(interet);

    state = state.copyWith(logiciels: data);
  }

  void deleteLogiciel(int index) {
    final newLogiciels = List<Logiciel>.from(state.logiciels)..removeAt(index);

    state = state.copyWith(logiciels: newLogiciels);
  }

  void saveReference(Reference ref) {
    final List<Reference> data = [...state.references]; // copie propre
    data.add(ref);

    state = state.copyWith(references: data);
  }

  void deleteReference(int index) {
    final newReferences = List<Reference>.from(state.references)
      ..removeAt(index);

    state = state.copyWith(references: newReferences);
  }
}
