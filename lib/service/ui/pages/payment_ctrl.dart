import 'dart:io';

import 'package:cyber_mobile/service/business/interactors/document_interactor.dart';
import 'package:cyber_mobile/service/business/models/print_info.dart';
import 'package:cyber_mobile/service/ui/pages/payment_state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database_helper.dart';

part 'payment_ctrl.g.dart';

@riverpod
class PaymentCtrl extends _$PaymentCtrl {
  @override
  PaymentState build() {
    return PaymentState();
  }

  Future<Map<String, dynamic>> getPrintPriceInfos(PrintInfo data) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.watch(documentInteractorProvider).getPrintInfosUseCase;

    try {
      final res = await usecase.execute(data);
      final status = res['status'];

      if (status == 'OK') {
        state = state.copyWith(
          dataPrintInfos: data,
          isLoading: false,
          reference: res['reference'],
          montant: res['montant'],
        );
        return {'status': 'OK', 'message': res['message']};
      } else {
        state = state.copyWith(isLoading: false);
        return {'status': 'KO', 'message': res['message'] ?? 'Echec'};
      }
    } catch (e) {
      final msg =
          e.toString().contains('Exception:')
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Erreur inattendue: ${e.toString()}';

      if (kDebugMode) {
        print('step-echec-04 : $msg');
      }

      state = state.copyWith(isLoading: false);
      return {'status': 'KO', 'message': msg};
    }
  }

  Future<Map<String, dynamic>> checkPayment(
    String sId,
    DateTime start,
    Duration timeout,
  ) async {
    state = state.copyWith(isLoading: true);
    //
    var usecase = ref.watch(documentInteractorProvider).checkPaymentUseCase;

    //final start = DateTime.now();
    //const timeout = Duration(seconds: 30);

    try {
      final result = await usecase.execute(state.reference, sId);
      final status = result['status'];
      final message = result['message'] ?? 'Opération en cours.';

      if (kDebugMode) {
        print('🔍 CheckPayment | Status: $status | Message: $message');
      }

      // ✅ Cas 1 : Succès
      if (status == 'OK') {
        if (kDebugMode) {
          print('✅ Paiement confirmé, mise à jour de la base.');
        }

        final db = await DatabaseHelper.instance.database;
        await db.update(
          'orders',
          {'status': 'Paiement confirmé'},
          where: 'ref = ?',
          whereArgs: [state.reference],
        );

        return {'status': 'OK', 'message': message};
      }

      // ✅ Cas 2 : Timeout atteint
      final elapsed = DateTime.now().difference(start);
      if (elapsed >= timeout) {
        if (kDebugMode) {
          print('⏰ Timeout atteint. Arrêt de la vérification.');
        }
        return {
          'status': 'NOK',
          'message':
              'Le délai de vérification a expiré. Veuillez vérifier votre historique de paiement.',
        };
      }

      // ✅ Cas 3 : En attente → réessaye après délai
      if (kDebugMode) {
        print(
          '⏳ Attente de confirmation... Réessai dans 5s. $elapsed & $timeout',
        );
      }

      await Future.delayed(const Duration(seconds: 5));

      // 🔁 Récursion : on relance la fonction
      return await checkPayment(sId, start, timeout);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors de la vérification du paiement : $e');
      }
      return {
        'status': 'ERROR',
        'message': 'Erreur réseau ou serveur. Veuillez réessayer plus tard.',
      };
    }
  }

  Future<Map<String, dynamic>> payBill(String refe, String phoneNumber, String sId) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.watch(documentInteractorProvider).payBillUseCase;

    try {
      final res = await usecase.execute(refe, phoneNumber, sId);
      final status = res['status'];

      if (status == 'OK') {
        state = state.copyWith(isLoading: false, reference: res['reference']);
        return {'status': 'OK', 'message': res['message']};
      } else {
        state = state.copyWith(isLoading: false);
        return {'status': 'KO', 'message': res['message'] ?? 'Echec'};
      }
    } catch (e) {
      final msg =
          e.toString().contains('Exception:')
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Erreur inattendue: ${e.toString()}';

      if (kDebugMode) {
        print('step-echec-04 : $msg');
      }

      state = state.copyWith(isLoading: false);
      return {'status': 'KO', 'message': msg};
    }
  }

  Future<Map<String, dynamic>> sendFile(
    String file,
    String reference,
    String sessionId,
    bool printe,
  ) async {
    state = state.copyWith(isLoading: true);
    state = state.copyWith(sendingFile: true);

    final usecase = ref.watch(documentInteractorProvider).sendFileUseCase;

    try {
      final response = await usecase.execute(
        file,
        reference,
        sessionId,
        printe,
      );

      final status = response['status'];

      // Vérifier si la réponse contient une erreur globale (ex: réseau)
      if (response.containsKey('error')) {
        final msg = response['error'] as String;
        if (kDebugMode) {
          print('❌ [sendFile] Erreur serveur : $msg');
        }
        state = state.copyWith(isLoading: false);
        state = state.copyWith(sendingFile: false);
        return {'status': 'KO', 'message': msg};
      }

      // L'API a répondu normalement (même en cas d'échec HTTP)
      //final statusCode = response['statusCode'] as int?;
      //final success = statusCode == 200 || statusCode == 201;

      if (status == 'OK') {
        // Réponse positive de l'API
        state = state.copyWith(sendingFile: false);
        state = state.copyWith(
          isLoading: false,
          reference: reference,
        ); // Optionnel : tu peux mettre d'autres données ici
        return {
          'status': 'OK',
          'message': response['message'] ?? 'Fichier envoyé avec succès',
        };
      } else {
        // Réponse négative de l'API (ex: 400, 500)
        final message =
            response['message'] ?? 'Échec de l’envoi. Veuillez réessayer.';
        if (kDebugMode) {
          print('⚠️ [sendFile] Échec API : $response');
        }
        state = state.copyWith(isLoading: false);
        state = state.copyWith(sendingFile: false);
        return {'status': 'KO', 'message': message};
      }
    } catch (e) {
      // Erreur inattendue (ex: fichier introuvable, permission refusée, etc.)
      final msg =
          e.toString().contains('Exception:')
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Erreur inattendue : ${e.toString()}';

      if (kDebugMode) {
        print('❌ [sendFile] Exception non gérée : $msg');
      }

      state = state.copyWith(isLoading: false);
      state = state.copyWith(sendingFile: false);
      return {'status': 'KO', 'message': msg};
    }
  }
}
