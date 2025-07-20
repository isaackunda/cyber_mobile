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
        Uri.parse('https://odigroup.cd/cbmplus/api/cart/get-price'),
        body: {
          'key': data.key,
          'pages': data.pages,
          'sessionID': data.sessionId,
        },
      );
      //
      //final response = await http.get(uri);

      if (kDebugMode) {
        print('--- DÉBOGAGE DE LA RÉPONSE API ---');
        //print('URL de la requête: $uri');
        print('Statut HTTP reçu: ${response.statusCode}');
        print(
          'Corps de la réponse brut du serveur: "${response.body}"',
        ); // <<< REGARDEZ ICI !!!
        print('Longueur du corps: ${response.body.length}');
        print('--- FIN DÉBOGAGE ---');
      }

      if (kDebugMode) {
        print('c\'est dohi');
      }
      if (response.statusCode == 200) {
        // Successfully registered the email
        if (kDebugMode) {
          print('Email registered successfully: ?');
        }

        var data = jsonDecode(response.body);

        if (kDebugMode) {
          print(' requete success :  $data} ');
        }

        return Future.value(data);
      } else {
        // Handle the error response
        if (kDebugMode) {
          print(
            'Failed to register email: ${response.reasonPhrase}, ${response.statusCode}',
          );
        }
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print('object: $data');
        }
        return Future.value(data);
      }
    } catch (e) {
      // Handle any exceptions that may occur during the registration process
      if (kDebugMode) {
        print('step-echec-05');
      }
      throw Exception('Failed to register email: $e');
    }
  }

  @override
  Future checkPayment(String ref, String sId) {
    // TODO: implement checkPayment
    throw UnimplementedError();
  }

  @override
  Future payBill() {
    // TODO: implement payBill
    throw UnimplementedError();
  }
}
