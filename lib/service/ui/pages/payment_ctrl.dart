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

  Future<Map<String, dynamic>> checkPayment(String sId) async {
    state = state.copyWith(isLoading: true);
    //
    var usecase = ref.watch(documentInteractorProvider).checkPaymentUseCase;

    final start = DateTime.now();
    const timeout = Duration(minutes: 2);

    while (true) {
      final result = await usecase.execute(state.reference, sId);
      final status = result['status'];

      if (result['status'] == 'OK') {
        if (kDebugMode) {
          print("Succès : Statut OK");
        }

        if (status == 'OK') {
          final db = await DatabaseHelper.instance.database;

          await db.update(
            'orders',
            {'status': 'complété'},
            where: 'ref = ?',
            whereArgs: [state.reference],
          );

          state = state.copyWith(isLoading: false);
          return {'status': 'OK', 'message': result['message']};
        }

        // Vérifie si le délai est dépassé
        final elapsed = DateTime.now().difference(start);
        if (elapsed >= timeout) {
          state = state.copyWith(isLoading: false);
          print("Temps dépassé. Statut toujours différent de OK.");
          return {'status': 'OK', 'message': result['message']};
        }

        // Petite pause pour éviter de spammer la fonction
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  Future<Map<String, dynamic>> payBill(String phoneNumber, String sId) async {
    state = state.copyWith(isLoading: true);

    final usecase = ref.watch(documentInteractorProvider).payBillUseCase;

    try {
      final res = await usecase.execute(state.reference, phoneNumber, sId);
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
}
