import 'package:cyber_mobile/service/business/models/cover_page_model.dart';
import 'package:cyber_mobile/service/business/service/document_service.dart';

class GetCoverPageUseCase {
  final DocumentService _documentService;

  GetCoverPageUseCase(this._documentService);

  Future<CoverPageModel> call(String id) {
    return _documentService.getCoverPage(id);
  }
}