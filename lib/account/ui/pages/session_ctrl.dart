import 'package:cyber_mobile/account/business/models/user_profile.dart';
import 'package:cyber_mobile/account/ui/pages/session_state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'session_ctrl.g.dart';

@riverpod
class SessionCtrl extends _$SessionCtrl {
  @override
  SessionState build() {
    return SessionState();
  }

  Future<Map<String, dynamic>> loadSession() async {
    //
    final prefs = await SharedPreferences.getInstance();

    var id = prefs.getString('sessionID');
    var name = prefs.getString('user_name');
    var firstName = prefs.getString('user_firstname');
    var phoneNumber = prefs.getString('phone_number');
    var email = prefs.getString('email');
    var university = prefs.getString('university');

    var data = UserProfile(
      sessionId: id.toString(),
      email: email.toString(),
      name: name.toString(),
      firstname: firstName.toString(),
      phoneNumber: phoneNumber.toString(),
      university: university.toString(),
    );

    state = state.copyWith(userData: data);

    if (kDebugMode) {
      print('session ${state.userData.name}');
      print('session ${state.userData.sessionId}');
    }

    return {'status': 'OK'};
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionID');
    await prefs.remove('user_name');
    await prefs.remove('user_firstname');
    await prefs.remove('phone_number');
    await prefs.remove('email');
    await prefs.remove('university');
  }
}
