import 'dart:convert';
import 'dart:io';

import 'package:cyber_mobile/service/business/models/cover_page_model.dart';
import 'package:cyber_mobile/service/business/models/cover_page_data.dart';
import 'package:cyber_mobile/service/business/models/cv.dart';
import 'package:cyber_mobile/service/business/models/cv_data.dart';
import 'package:cyber_mobile/service/business/models/order_status.dart';
import 'package:cyber_mobile/service/business/models/print_info.dart';
import 'package:cyber_mobile/service/business/models/service_data.dart';
import 'package:cyber_mobile/service/business/models/template.dart';
import 'package:cyber_mobile/service/business/service/document_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DocumentServiceNetwork implements DocumentService {
  @override
  Future<void> createCoverPage(CoverPageData data) {
    // TODO: implement createCoverPage
    throw UnimplementedError();
  }

  @override
  Future<void> createCv(CvData data) {
    // TODO: implement createCv
    throw UnimplementedError();
  }

  @override
  Future<CoverPageModel> getCoverPage(String id) {
    // TODO: implement getCoverPage
    throw UnimplementedError();
  }

  @override
  Future<List<Template>> getCoverPageTemplates() {
    // TODO: implement getCoverPageTemplates
    throw UnimplementedError();
  }

  @override
  Future<Cv> getCv(String id) {
    // TODO: implement getCv
    throw UnimplementedError();
  }

  @override
  Future<List<Template>> getCvTemplates() {
    // TODO: implement getCvTemplates
    throw UnimplementedError();
  }

  @override
  Future<void> payForService(ServiceData service) {
    // TODO: implement payForService
    throw UnimplementedError();
  }

  @override
  Future<OrderStatus> trackCoverPageOrder(String orderId) {
    // TODO: implement trackCoverPageOrder
    throw UnimplementedError();
  }

  @override
  Future<void> uploadFile(File file) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getPrintPrice(PrintInfo data) async {
    try {
      final response = await http.post(
        Uri.parse('https://odigroup.cd/cbmplus/api/cart/print/get-price/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'key': data.key,
          'pages': data.pages,
          'sessionID': data.sessionId,
        }),
      );

      if (kDebugMode) {
        print('--- DÉBOGAGE DE LA RÉPONSE API ---');
        print('Statut HTTP reçu: ${response.statusCode}');
        print('Corps brut: "${response.body}"');
        print('Longueur du corps: ${response.body.length}');
        print('--- FIN DÉBOGAGE ---');
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Requête succès : $responseData');
        }
        return responseData;
      } else {
        if (kDebugMode) {
          print(
            'Échec requête: ${response.reasonPhrase}, ${response.statusCode}',
          );
          print('Réponse d\'erreur : $responseData');
        }
        return responseData;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur dans getPrintPrice: $e');
      }
      throw Exception('Erreur lors de la récupération du prix : $e');
    }
  }

  @override
  Future checkPayment(String ref, String sId) async {
    try {
      final response = await http.post(
        Uri.parse('https://odigroup.cd/cbmplus/api/cart/print/check-payment/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'reference': ref, 'sessionID': sId}),
      );

      if (kDebugMode) {
        print('--- DÉBOGAGE DE LA RÉPONSE API ---');
        print('Statut HTTP reçu: ${response.statusCode}');
        print('Corps brut: "${response.body}"');
        print('Longueur du corps: ${response.body.length}');
        print('--- FIN DÉBOGAGE ---');
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Requête succès : $responseData');
        }
        return responseData;
      } else {
        if (kDebugMode) {
          print(
            'Échec requête: ${response.reasonPhrase}, ${response.statusCode}',
          );
          print('Réponse d\'erreur : $responseData');
        }
        return responseData;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur dans getPrintPrice: $e');
      }
      throw Exception('Erreur lors de la récupération du prix : $e');
    }
  }

  @override
  Future<dynamic> payBill(String ref, String phoneNumber, String sessionId) async {
    try {
      final response = await http.post(
        Uri.parse('https://odigroup.cd/cbmplus/api/cart/print/pay-bill/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'reference': ref, 'phone_number': phoneNumber}),
      );

      if (kDebugMode) {
        print('--- DÉBOGAGE DE LA RÉPONSE API ---');
        print('Statut HTTP reçu: ${response.statusCode}');
        print('Corps brut: "${response.body}"');
        print('Longueur du corps: ${response.body.length}');
        print('--- FIN DÉBOGAGE ---');
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Requête succès : $responseData');
        }
        return responseData;
      } else {
        if (kDebugMode) {
          print(
            'Échec requête: ${response.reasonPhrase}, ${response.statusCode}',
          );
          print('Réponse d\'erreur : $responseData');
        }
        return responseData;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur dans getPrintPrice: $e');
      }
      throw Exception('Erreur lors de la récupération du prix : $e');
    }
  }
}
