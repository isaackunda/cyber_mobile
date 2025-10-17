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
  Future<Map<String, dynamic>> uploadFile(
    String file,
    String reference,
    String sessionId,
    bool print,
  ) async {
    try {
      // ✅ CORRECTION CRITIQUE : Supprime les espaces dans l'URL !
      final url = 'https://odigroup.cd/cbmplus/api/cart/print/send-file/';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Ajouter les champs textuels
      request.fields['reference'] = reference;
      request.fields['sessionId'] = sessionId;
      // Si l'API attend un champ "print" en string, décommente :
      // request.fields['print'] = print ? 'true' : 'false';

      // Ajouter le fichier sous le champ 'print' (comme demandé par l'API)
      var multipartFile = await http.MultipartFile.fromPath(
        'print', // ← Nom du champ attendu par l'API
        file,
        filename: file.split('/').last,
      );
      request.files.add(multipartFile);

      // Envoyer la requête
      final response = await request.send();

      // Lire la réponse
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(responseBody);

      // Retourner la réponse brute (succès ou erreur)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        // L'API a retourné une erreur (ex: 400, 500)
        return {...responseData, 'statusCode': response.statusCode};
      }
    } catch (e) {
      // Erreur réseau, fichier manquant, etc.
      return {'error': 'Erreur serveur inattendue', 'message': e.toString()};
    }
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
  Future<dynamic> payBill(
    String ref,
    String phoneNumber,
    String sessionId,
  ) async {
    try {

      if (kDebugMode) {
        print('PAIEMENT - DONNÉES ENVOYÉES :');
        print('ref : $ref');
        print('phone : $phoneNumber');
        print('session : $sessionId');
      }
      final response = await http.post(
        Uri.parse('https://odigroup.cd/cbmplus/api/cart/print/pay-bill/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reference': ref,
          'phone': phoneNumber,
          'sessionID': sessionId,
          'reset': '',
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
}
