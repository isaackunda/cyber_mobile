import 'package:cyber_mobile/service/business/models/print_info.dart';
import 'package:cyber_mobile/service/business/service/document_service.dart';

class GetPrintInfosUseCase {
  final DocumentService _documentService;

  GetPrintInfosUseCase(this._documentService);

  Future<dynamic> execute(PrintInfo data) {
    return _documentService.getPrintPrice(data);
  }
}
