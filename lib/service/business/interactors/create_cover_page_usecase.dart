import 'package:cyber_mobile/service/business/service/document_service.dart';

import '../models/cover_page_data.dart';

class CreateCoverPageUseCase {
  final DocumentService _documentService;

  CreateCoverPageUseCase(this._documentService);

  Future<void> call(CoverPageData data) {
    return _documentService.createCoverPage(data);
  }
}