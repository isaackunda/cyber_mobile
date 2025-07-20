
import 'package:cyber_mobile/service/business/models/template.dart';
import 'package:cyber_mobile/service/business/service/document_service.dart';

class GetCoverPagetemplatesUseCase {
  final DocumentService _documentService;

  GetCoverPagetemplatesUseCase(this._documentService);

  Future<List<Template>> call() {
    return _documentService.getCoverPageTemplates();
  }
}