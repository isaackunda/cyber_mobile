import 'package:cyber_mobile/account/business/models/user_profile.dart';

class SessionState {
  //
  final UserProfile userData;

  SessionState({
    this.userData = const UserProfile(
      sessionId: 'N/A',
      email: 'N/A',
      name: 'N/A',
      firstname: 'N/A',
      phoneNumber: 'N/A',
      university: 'N/A',
    ),
  });

  SessionState copyWith({UserProfile? userData}) {
    return SessionState(userData: userData ?? this.userData);
  }
}
