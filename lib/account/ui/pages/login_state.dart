class LoginState {
  final String? token;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? university;
  final String? sessionId;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  List<String> universities = [];

  LoginState({
    this.token,
    this.email,
    this.password,
    this.confirmPassword,
    this.name,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.university,
    this.sessionId,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.universities = const [],
  });

  LoginState copyWith({
    String? token,
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? university,
    String? sessionId,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<String>? universities,
  }) {
    return LoginState(
      token: token ?? this.token,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      university: university ?? this.university,
      sessionId: sessionId ?? this.sessionId,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      universities: universities ?? this.universities,
    );
  }
}
