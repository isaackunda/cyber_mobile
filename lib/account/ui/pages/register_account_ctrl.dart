import 'package:cyber_mobile/account/business/models/register_request.dart';
import 'package:cyber_mobile/account/ui/pages/register_account_state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../business/interactors/account_interactor.dart';
import '../../business/models/university.dart';

part 'register_account_ctrl.g.dart';

@riverpod
class RegisterAccountCtrl extends _$RegisterAccountCtrl {
  @override
  RegisterAccountState build() {
    return RegisterAccountState();
  }

  Future<Map<String, dynamic>> registerEmail(String phone) async {
    //Declancher le CircularProgressIndicator
    state = state.copyWith(
      isLoading: true,
      errorMessage: null, // Réinitialise le message d'erreur/succès précédent
      isSuccess: false, // Réinitialise aussi le succès précédent
    );

    var usecase = ref.watch(accountInteractorProvider).registerEmailUseCase;
    if (kDebugMode) {
      print('step-02');
    }

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
      } else if (res['status'] == 'PENDING_OTP_VERIFICATION') {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: res['message'],
        );
        return {
          'status': 'PENDING_OTP_VERIFICATION',
          'message': res['message'],
        }; // Retourne le résultat
      } else if (res['status'] == 'NOK') {
        // On vérifie que "universities" existe bien et est une liste de Map<String, dynamic>
        final List<dynamic>? rawUniversities =
            res['universités'] as List<dynamic>?;

        // Ici, nous transformons la liste de maps en une liste d'objets University
        final List<University> parsedUniversities =
            (rawUniversities ?? [])
                .map((e) => University.fromJson(e as Map<String, dynamic>))
                .toList();

        state = state.copyWith(
          phoneNumber: phone,
          universities: parsedUniversities,
          isLoading: false,
          isSuccess: false,
          errorMessage: res['message'],
        );
        return {
          'status': 'NOK',
          'message': res['message'],
        }; // Retourne le résultat
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

  Future<Map<String, dynamic>> registerAccount(RegisterRequest data) async {
    //Declencher le CircularProgressIndicator
    state = state.copyWith(
      isLoading: true,
      errorMessage: null, // Réinitialise le message d'erreur/succès précédent
      isSuccess: false, // Réinitialise aussi le succès précédent
    );

    var usecase = ref.watch(accountInteractorProvider).registerAccountUseCase;

    try {
      var res = await usecase.call(data);

      if (res['status'] == 'OK') {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          errorMessage: res['message'],
        );

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
        errorMessage: e.toString(),
      );
      return {'status': 'KO', 'message': msg};
    }
  }

  Future<Map<String, dynamic>> verifyOtpAndRegister(
    String phone,
    String otp,
  ) async {
    // Déclencher le CircularProgressIndicator
    state = state.copyWith(
      isLoading: true,
      errorMessage: null, // Réinitialise le message d'erreur/succès précédent
      isSuccess: false, // Réinitialise aussi le succès précédent
    );

    if (kDebugMode) {
      print(' object 1 $phone + object 2 $otp ');
    }

    final usecase =
        ref.watch(accountInteractorProvider).verifyOtpAndRegisterUseCase;

    try {
      final res = await usecase.execute(phone, otp);

      // On vérifie que "universities" existe bien et est une liste de Map<String, dynamic>
      final List<dynamic>? rawUniversities =
          res['universités'] as List<dynamic>?;

      // Ici, nous transformons la liste de maps en une liste d'objets University
      final List<University> parsedUniversities =
          (rawUniversities ?? [])
              .map((e) => University.fromJson(e as Map<String, dynamic>))
              .toList();

      if (res['status'] == 'OK') {
        state = state.copyWith(
          universities: parsedUniversities,
          isLoading: false,
          isSuccess: true,
          errorMessage: res['message'],
        );
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
