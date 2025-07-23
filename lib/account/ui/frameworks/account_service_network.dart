import 'dart:convert';

import 'package:cyber_mobile/account/business/models/register_request.dart';
import 'package:cyber_mobile/account/business/service/account_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AccountServiceNetwork implements AccountService {
  @override
  Future<bool> isAuthenticated() {
    // TODO: implement isAuthenticated
    throw UnimplementedError();
  }

  @override
  Future<dynamic> login(String email) async {
    final uri = Uri.parse(
      'https://odigroup.cd/cbmplus/api/auth/login/request-otp/',
    );

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (kDebugMode) {
        print('--- DÉBOGAGE DE LA RÉPONSE API ---');
        print('Statut HTTP: ${response.statusCode}');
        print('Réponse: ${response.body}');
        print('--- FIN DÉBOGAGE ---');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        try {
          final data = jsonDecode(response.body);
          return data;
        } catch (_) {
          return {'error': 'Erreur serveur inattendue'};
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception réseau: $e');
      }
      throw Exception('Échec de la requête: $e');
    }
  }

  @override
  Future<dynamic> otpLogin(String email, String otp) async {
    try {
      //
      final response = await http.post(
        Uri.parse('https://odigroup.cd/cbmplus/api/auth/login/verify-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        // Successfully registered the email
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print('Email registered successfully: $email');
          print('Compte enregistré avec succès via FormData: $email');
          print('Données reçues: $data');
        }
        return data;
      } else {
        // Handle the error response
        if (kDebugMode) {
          print('Failed to register email: ${response.reasonPhrase}');
        }
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print('object: $data');
        }
        return data;
      }
    } catch (e) {
      // Handle any exceptions that may occur during the registration process
      throw Exception('Failed to register email: $e');
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<dynamic> registerEmail(String email) async {
    /*final uri = Uri.parse(
      'https://odigroup.cd/cbmplus/api/auth/signup/request-otp?email=$email',
    );*/

    try {
      final response = await http.post(
        Uri.parse('https://odigroup.cd/cbmplus/api/auth/signup/request-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

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
          print('Email registered successfully: $email');
        }

        var data = jsonDecode(response.body);
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
  Future<dynamic> verifyOtpAndRegister(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('https://odigroup.cd/cbmplus/api/auth/signup/verify-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
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
          print('Email registered successfully: $email');
        }

        var data = jsonDecode(response.body);
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

  /*Future<dynamic> verifyOtpAndRegister2(String email, String otp) async {
    //

    final uri = Uri.https(
      'odigroup.cd', // L'hôte de votre API
      '/cbmplus/api/auth/signup/verify-otp/', // Le chemin de votre endpoint
    );

    // 1. Créez une instance de MultipartRequest
    // La méthode est généralement 'POST' pour l'envoi de données
    var request = http.MultipartRequest('POST', uri);

    // 2. Ajoutez vos champs de texte (email et otp) à la propriété 'fields'
    // Les clés ('email', 'otp') doivent correspondre aux noms attendus par votre API.
    request.fields['email'] = email;
    request.fields['otp'] = otp;

    if (kDebugMode) {
      print('--- Requête FormData PRÊTE ---');
      print('URL de la requête: ${request.url}');
      print('Méthode: ${request.method}');
      print('Champs FormData (email, otp): ${request.fields}');
      print('--- FIN Préparation ---');
    }

    try {
      // 3. Envoyez la requête
      // request.send() retourne un StreamedResponse, pas un Response direct
      var streamedResponse = await request.send();

      // 4. Lisez le corps de la réponse en tant que chaîne
      // Ceci doit être fait APRÈS que la requête est envoyée et que la réponse commence à arriver.
      var responseBody = await streamedResponse.stream.bytesToString();

      if (kDebugMode) {
        print('--- Réponse du Serveur REÇUE ---');
        print('Statut HTTP: ${streamedResponse.statusCode}');
        print('Corps de la réponse brut: "$responseBody"');
        print('--- FIN Réponse ---');
      }

      // 5. Gérez la réponse (qui est censée être JSON)
      final String trimmedBody = responseBody.trim();
      bool isLikelyJson =
          trimmedBody.isNotEmpty &&
          (trimmedBody.startsWith('{') || trimmedBody.startsWith('['));

      if (isLikelyJson) {
        var data = jsonDecode(responseBody); // Décode le JSON
        if (streamedResponse.statusCode >= 200 &&
            streamedResponse.statusCode < 300) {
          // Le statut HTTP est un succès (2xx) et la réponse est JSON
          if (kDebugMode) {
            print('OTP vérifié et email enregistré avec succès via FormData.');
            print('Données reçues: $data');
          }
          return Future.value(data);
        } else {
          // Le statut HTTP indique une erreur (non 2xx), mais la réponse est JSON
          if (kDebugMode) {
            print(
              'Échec de la vérification/enregistrement via FormData. Réponse du serveur: $data',
            );
          }
          return Future.value(data);
        }
      } else {
        // La réponse n'est pas JSON ou est vide, même si le statut est un succès HTTP
        String errorMessage = '';
        if (streamedResponse.statusCode >= 200 &&
            streamedResponse.statusCode < 300) {
          errorMessage =
              'Réponse OK (${streamedResponse.statusCode}), mais corps vide ou non-JSON.';
        } else {
          errorMessage =
              'Erreur HTTP ${streamedResponse.statusCode}: ${streamedResponse.reasonPhrase}. Réponse non JSON.';
        }
        if (kDebugMode) {
          print(errorMessage);
        }
        // Handle any exceptions that may occur during the registration process
        throw Exception('Failed to register email: $errorMessage');
      }
    } catch (e) {
      // Gère les exceptions de bas niveau (réseau, timeout, etc.)
      if (kDebugMode) {
        print('Erreur lors de l\'envoi de la requête FormData: $e');
      }
      // Handle any exceptions that may occur during the registration process
      throw Exception('Failed to register email: $e');
    }
  }*/

  @override
  Future<dynamic> registerAccount(RegisterRequest user) async {
    final response = await http.post(
      Uri.parse('https://odigroup.cd/cbmplus/api/auth/signup/complete/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': user.email,
        'nom': user.name,
        'prenom': user.firstname,
        'universite': user.university,
        'telephone': user.phoneNumber,
      }),
    );

    if (kDebugMode) {
      print('--- Requête FormData PRÊTE ---');
      print('URL de la requête: ${response.headers}');
      print('Méthode: ${response.body}'); // Devrait afficher 'POST'
      print('--- FIN Préparation ---');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);

      if (kDebugMode) {
        print('Compte enregistré avec succès via FormData: ${user.email}');
        print('Données reçues: $data');
      }

      return data; // Pas besoin de Future.value ici, c’est déjà async
    } else {
      // Gère l'erreur
      //throw Exception('Échec de l’enregistrement : ${response.statusCode}');
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print('object: $data');
      }
      return data;
    }
  }
}
