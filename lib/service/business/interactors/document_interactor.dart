import 'package:cyber_mobile/service/business/interactors/check_payment_usecase.dart';
import 'package:cyber_mobile/service/business/interactors/create_cover_page_usecase.dart';
import 'package:cyber_mobile/service/business/interactors/create_cv.dart';
import 'package:cyber_mobile/service/business/interactors/get_cover_page_templates_usecase.dart';
import 'package:cyber_mobile/service/business/interactors/get_cover_page_usecase.dart';
import 'package:cyber_mobile/service/business/interactors/get_cv_templates_usecase.dart';
import 'package:cyber_mobile/service/business/interactors/get_cv_usecase.dart';
import 'package:cyber_mobile/service/business/interactors/get_print_infos_usecase.dart';
import 'package:cyber_mobile/service/business/interactors/pay_bill_usecase.dart';
import 'package:cyber_mobile/service/business/interactors/send_file_usecase.dart';
import 'package:cyber_mobile/service/business/service/document_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_interactor.g.dart';

class DocumentInteractor {
  GetCoverPagetemplatesUseCase getCoverPageTemplatesUseCase;
  GetCoverPageUseCase getCoverPageUseCase;
  GetCvTemplatesUseCase getCvTemplatesUseCase;
  GetCvUseCase getCvUseCase;
  CreateCoverPageUseCase createCoverPageUseCase;
  CreateCvUseCase createCvUseCase;
  GetPrintInfosUseCase getPrintInfosUseCase;
  CheckPaymentUseCase checkPaymentUseCase;
  PayBillUseCase payBillUseCase;
  SendFileUseCase sendFileUseCase;

  DocumentInteractor._(
    this.getCoverPageTemplatesUseCase,
    this.getCoverPageUseCase,
    this.getCvTemplatesUseCase,
    this.getCvUseCase,
    this.createCoverPageUseCase,
    this.createCvUseCase,
    this.getPrintInfosUseCase,
    this.checkPaymentUseCase,
    this.payBillUseCase,
    this.sendFileUseCase,
  );

  static DocumentInteractor build(DocumentService service) {
    return DocumentInteractor._(
      GetCoverPagetemplatesUseCase(service),
      GetCoverPageUseCase(service),
      GetCvTemplatesUseCase(service),
      GetCvUseCase(service),
      CreateCoverPageUseCase(service),
      CreateCvUseCase(service),
      GetPrintInfosUseCase(service),
      CheckPaymentUseCase(service),
      PayBillUseCase(service),
      SendFileUseCase(service),
    );
  }
}

@Riverpod(keepAlive: true)
DocumentInteractor documentInteractor(Ref ref) {
  throw Exception(
    "This method should not be called directly. Use CompteInteractor.build() instead.",
  );
}
