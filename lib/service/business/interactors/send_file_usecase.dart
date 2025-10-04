import 'dart:io';

import 'package:cyber_mobile/service/business/service/document_service.dart';

class SendFileUseCase {

  final DocumentService _documentService;

  SendFileUseCase(this._documentService);

  Future<dynamic> execute(
    String file,
    String reference,
    String sessionId,
    bool print,
  ) {

    return _documentService.uploadFile(file, reference, sessionId, print);
  }
}
