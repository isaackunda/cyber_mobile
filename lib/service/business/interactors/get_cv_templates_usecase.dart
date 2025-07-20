import 'package:cyber_mobile/service/business/models/template.dart';
import 'package:cyber_mobile/service/business/service/document_service.dart';

class GetCvTemplatesUseCase {
  final DocumentService _documentService;

  GetCvTemplatesUseCase(this._documentService);

  Future<List<Template>> call() {
    return _documentService.getCvTemplates();
  }
}