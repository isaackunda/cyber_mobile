import 'dart:ffi';

import 'package:cyber_mobile/account/ui/pages/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business/interactors/account_interactor.dart';

part 'login_ctrl.g.dart';

@riverpod
class LoginCtrl extends _$LoginCtrl {
  @override
  LoginState build() {
    return LoginState();
  }

  Future<Map<String, dynamic>> login(String phone) async {
    //Declancher le CircularProgressIndicator
    state = state.copyWith(
      isLoading: true,
      errorMessage: null, // Réinitialise le message d'erreur/succès précédent
      isSuccess: false, // Réinitialise aussi le succès précédent
    );

    var usecase = ref.watch(accountInteractorProvider).loginUseCase;

    try {
      var res = await usecase.execute(phone);
      if (res['status'] == 'OK') {
        state = state.copyWith(
          phoneNumber: phone,
          isLoading: false,
          isSuccess: true,
          errorMessage: res['message'],
        );
        return {'status': 'OK', 'message': res['message']};
      } else if (res['status'] == 'KO') {
        // Do nothing if the email is already set
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: res['message'],
        );
        return {'status': 'KO', 'message': res['message']};
      } else {
        // Do nothing if the email is already set
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: res['message'],
        );
        if (kDebugMode) {
          print('step-echec-02');
        }
        return {
          'status': 'KO',
          'message': res['message'] ?? 'Erreur lors de l\'opération.',
        }; // Retourne le résultat
      }
    } catch (e) {
      String msg =
          e.toString().contains('Exception:')
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Erreur inattendue: ${e.toString()}';
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      );
      if (kDebugMode) {
        print('step-echec-04 : ${e.toString()}');
      }
      return {'status': 'KO', 'message': msg};
    }
  }

  Future<Map<String, dynamic>> otpLogin(String phone, String otp) async {
    // Déclencher le CircularProgressIndicator
    state = state.copyWith(
      isLoading: true,
      errorMessage: null, // Réinitialise le message d'erreur/succès précédent
      isSuccess: false, // Réinitialise aussi le succès précédent
    );

    final usecase = ref.watch(accountInteractorProvider).otpLoginUseCase;

    try {
      final res = await usecase.execute(phone, otp);
      final prefs = await SharedPreferences.getInstance();

      if (res['status'] == 'OK') {
        state = state.copyWith(
          sessionId: res['info']['sessionID'],
          name: res['info']['nom'],
          phoneNumber: res['info']['téléphone'],
          university: res['info']['université'],
          isLoading: false,
          isSuccess: true,
          errorMessage: res['message'],
        );

        await prefs.setString('sessionID', res['info']['sessionID']);
        await prefs.setString('user_name', res['info']['nom']);
        //await prefs.setString('user_firstname', res['info']['prénom']);
        await prefs.setString('phone_number', res['info']['téléphone']);
        //await prefs.setString('email', state.email.toString());
        await prefs.setString('university', res['info']['université']);

        return {'status': 'OK', 'message': res['message']};
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: res['message'] ?? 'Erreur inconnue',
        );
        return {
          'status': 'KO',
          'message': res['message'] ?? 'Erreur lors de l\'opération.',
        }; // Retourne le résultat
      }
    } catch (e) {
      String msg =
          e.toString().contains('Exception:')
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Erreur inattendue: ${e.toString()}';
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: 'Erreur : ${e.toString()}',
      );

      if (kDebugMode) {
        print('requete erreur $e');
      }
      return {'status': 'KO', 'message': msg};
    }
  }
}
