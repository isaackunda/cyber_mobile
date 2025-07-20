import 'package:cyber_mobile/service/business/models/print_info.dart';

class PaymentState {
  final PrintInfo dataPrintInfos;
  final String reference;
  final String sessionId;
  final bool isLoading;

  PaymentState({
    this.dataPrintInfos = const PrintInfo(
      key: 'key',
      pages: 'pages',
      sessionId: 'sessionId',
    ),
    //
    this.sessionId = '',
    this.reference = '',
    this.isLoading = false,
  });

  PaymentState copyWith({
    PrintInfo? dataPrintInfos,
    String? reference,
    String? sessionId,
    bool? isLoading,
  }) {
    return PaymentState(
      dataPrintInfos: dataPrintInfos ?? this.dataPrintInfos,
      reference: reference ?? this.reference,
      sessionId: sessionId ?? this.sessionId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
