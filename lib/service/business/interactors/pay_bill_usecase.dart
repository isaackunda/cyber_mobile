import 'package:cyber_mobile/service/business/service/document_service.dart';

class PayBillUseCase {
  final DocumentService _documentService;

  PayBillUseCase(this._documentService);

  Future<dynamic> execute() {
    return _documentService.payBill();
  }
}
