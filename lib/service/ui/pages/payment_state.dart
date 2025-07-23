import 'package:cyber_mobile/service/business/models/print_info.dart';

class PaymentState {
  final PrintInfo dataPrintInfos;
  final String reference;
  final String montant;
  final String sessionId;
  final bool isLoading;

  PaymentState({
    this.dataPrintInfos = const PrintInfo(
      key: 'N/A',
      pages: 'N/A',
      sessionId: 'N/A',
    ),
    //
    this.sessionId = 'N/A',
    this.reference = 'N/A',
    this.montant = 'N/A',
    this.isLoading = false,
  });

  PaymentState copyWith({
    PrintInfo? dataPrintInfos,
    String? reference,
    String? montant,
    String? sessionId,
    bool? isLoading,
  }) {
    return PaymentState(
      dataPrintInfos: dataPrintInfos ?? this.dataPrintInfos,
      reference: reference ?? this.reference,
      montant: montant ?? this.montant,
      sessionId: sessionId ?? this.sessionId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
