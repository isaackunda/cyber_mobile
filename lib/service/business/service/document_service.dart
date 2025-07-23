import 'dart:io';

import 'package:cyber_mobile/service/business/models/print_info.dart';

import '../models/cover_page_model.dart';
import '../models/cover_page_data.dart';
import '../models/cv.dart';
import '../models/cv_data.dart';
import '../models/order_status.dart';
import '../models/service_data.dart';
import '../models/template.dart';

abstract class DocumentService {
  Future<void> uploadFile(File file);
  Future<List<Template>> getCoverPageTemplates();
  Future<List<Template>> getCvTemplates();
  Future<void> createCoverPage(CoverPageData data);
  Future<void> createCv(CvData data);
  Future<CoverPageModel> getCoverPage(String id);
  Future<Cv> getCv(String id);
  Future<OrderStatus> trackCoverPageOrder(String orderId);
  Future<void> payForService(ServiceData service);
  Future<dynamic> getPrintPrice(PrintInfo data);
  Future<dynamic> checkPayment(String ref, String sId);
  Future<dynamic> payBill(String ref, String phoneNumber, String sessionId);
}
