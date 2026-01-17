import 'package:cyber_mobile/account/ui/pages/login_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../routers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  var emailCtrl = TextEditingController(text: '');
  //var phoneCtrl = TextEditingController(text: '');
  var phoneCtrl = '';
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
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              children: [
                TextSpan(text: 'Entre ton numero '),
                TextSpan(
                  text: 'WhatsApp',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' pour accéder à ton compte.'),
              ],
            ),
          ),
          SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                IntlPhoneField(
                  //controller: phoneCtrl,
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white, // Couleur de la bordure
                        width: 1.5, // Épaisseur
                      ),
                    ),
                  ),
                  initialCountryCode: 'CD', // 🇨🇩 Code pays RDC
                  onChanged: (phone) {
                    if (kDebugMode) {
                      print('Numéro : ${phone.completeNumber}');
                    }
                    setState(() {
                      phoneCtrl = phone.completeNumber;
                    });
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
                  var result = await ctrl.login(phoneCtrl);

                  if (!context.mounted) return;

                  String messageToShow =
                      result['message'] ?? 'Opération terminée.';
                  bool isSuccess = result['status'] == 'OK';
                  bool pending = result['status'] == 'NOK';

                  if (isSuccess) {
                    setState(() {
                      phoneCtrl = '';
                    });
                    //emailCtrl.clear();
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
