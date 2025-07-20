
import 'package:cyber_mobile/account/business/models/university.dart';

class RegisterAccountState {
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? university;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  List<University> universities = [];

  RegisterAccountState({
    this.email,
    this.password,
    this.confirmPassword,
    this.name,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.university,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.universities = const [],
  });

  RegisterAccountState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? university,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<University>? universities,
  }) {
    return RegisterAccountState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      university: university ?? this.university,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      universities: universities ?? this.universities,
    );
  }
}