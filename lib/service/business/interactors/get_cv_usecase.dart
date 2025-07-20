import 'package:cyber_mobile/service/business/service/document_service.dart';

import '../models/cv.dart';

class GetCvUseCase {
  final DocumentService _documentService;

  GetCvUseCase(this._documentService);

  Future<Cv> call(String id) {
    return _documentService.getCv(id);
  }
}