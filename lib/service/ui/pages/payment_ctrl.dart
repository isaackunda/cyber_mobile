import 'package:cyber_mobile/service/business/interactors/document_interactor.dart';
import 'package:cyber_mobile/service/business/models/print_info.dart';
import 'package:cyber_mobile/service/ui/pages/payment_state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_ctrl.g.dart';

@riverpod
class PaymentCtrl extends _$PaymentCtrl {
  @override
  PaymentState build() {
    return PaymentState();
  }

  Future<Map<String, dynamic>> getPriceInfos(PrintInfo data) async {
    //
    state = state.copyWith(isLoading: true);

    var usecase = ref.watch(documentInteractorProvider).getPrintInfosUseCase;

    try {
      //
      var res = await usecase.execute(data);

      if (res['status'] == 'OK') {
        //
        state = state.copyWith(dataPrintInfos: data, isLoading: false);
        return {'status:': 'OK', 'message': res['message']};
      } else if (res['status'] == 'KO') {
        state = state.copyWith(isLoading: false);

        return {'status:': 'KO', 'message': res['message']};
      } else {
        state = state.copyWith(isLoading: false);
        return {'status:': 'KP', 'message': 'Echec'};
      }
    } catch (e) {
      //
      String msg =
          e.toString().contains('Exception:')
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Erreur inattendue: ${e.toString()}';

      if (kDebugMode) {
        print('step-echec-04 : ${e.toString()}');
      }

      state = state.copyWith(isLoading: false);
      return {'status': 'KO', 'message': msg};
    }
  }

  Future<Map<String, dynamic>> checkPayment(String refe, String sId) async {
    //
    var usecase = ref.watch(documentInteractorProvider).checkPaymentUseCase;

    try {
      //
      var res = await usecase.execute(refe, sId);

      if (res['status'] == 'OK') {
        //
        state = state.copyWith(reference: refe, sessionId: sId);
      }

      return {'status:': 'OK', 'message': res['message']};
    } catch (e) {
      //
      String msg =
          e.toString().contains('Exception:')
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Erreur inattendue: ${e.toString()}';

      if (kDebugMode) {
        print('step-echec-04 : ${e.toString()}');
      }
      return {'status': 'KO', 'message': msg};
    }
  }

  Future<Map<String, dynamic>> payBill() async {
    ///TODO: Faire la requete du paybill

    return {'status': 'braa'};
  }
}
