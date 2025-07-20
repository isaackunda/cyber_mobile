import 'package:cyber_mobile/account/ui/pages/login_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  var emailCtrl = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(loginCtrlProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                'Bienvenue !',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          Text(
            'Entre ton adresse e-mail pour accéder à ton compte.',
            style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
          ),
          SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    labelText: 'Saisissez votre adresse e-mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white, // Couleur de la bordure
                        width: 1.5, // Épaisseur
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.email, // Icône utilisateur
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primary, // Couleur de l'icône
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (state.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var ctrl = ref.watch(loginCtrlProvider.notifier);
                  var result = await ctrl.login(emailCtrl.text);

                  if (!context.mounted) return;

                  String messageToShow =
                      result['message'] ?? 'Opération terminée.';
                  bool isSuccess = result['status'] == 'OK';
                  bool pending = result['status'] == 'NOK';

                  if (isSuccess) {
                    emailCtrl.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          messageToShow,
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    );
                    context.pushNamed(Urls.otpLogin.name);
                  } else {
                    if (kDebugMode) {
                      print('step-echec-01 $messageToShow');
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          messageToShow,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  //context.pushNamed(Urls.otpLogin.name);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Envoyer le code OTP',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
