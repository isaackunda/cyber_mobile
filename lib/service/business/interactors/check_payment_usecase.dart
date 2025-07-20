import 'package:cyber_mobile/service/business/service/document_service.dart';

class CheckPaymentUseCase {
  final DocumentService _documentService;

  CheckPaymentUseCase(this._documentService);

  Future<dynamic> execute(String ref, String sId) {
    return _documentService.checkPayment(ref, sId);
  }
}
