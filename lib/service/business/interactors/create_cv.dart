import 'package:cyber_mobile/service/business/models/cv_data.dart';
import 'package:cyber_mobile/service/business/service/document_service.dart';

class CreateCvUseCase {
  final DocumentService _documentService;

  CreateCvUseCase(this._documentService);

  Future<void> call(CvData data) {
    return _documentService.createCv(data);
  }
}