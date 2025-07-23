import 'package:cyber_mobile/service/business/service/document_service.dart';

class PayBillUseCase {
  final DocumentService _documentService;

  PayBillUseCase(this._documentService);

  Future<dynamic> execute(String ref, String phoneNumber, String sessionId) {
    return _documentService.payBill(ref, phoneNumber, sessionId);
  }
}
