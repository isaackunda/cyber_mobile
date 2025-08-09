import 'package:cyber_mobile/account/ui/pages/login_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routers.dart';

class OtpLoginPage extends ConsumerStatefulWidget {
  const OtpLoginPage({super.key});

  @override
  ConsumerState<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends ConsumerState<OtpLoginPage> {
  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(loginCtrlProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Vérification')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Vérifie ton adresse e-mail',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Un code à 6 chiffres a été envoyé à ton e-mail. Entre-le ici.',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),
              OtpTextField(
                numberOfFields: 4,
                borderColor: Theme.of(context).primaryColor,
                focusedBorderColor: Theme.of(context).colorScheme.primary,
                showFieldAsBox: true,
                onSubmit: (code) {
                  otpCode = code;
                  //_verifyOtp(code);
                },
              ),

              const SizedBox(height: 24),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      var ctrl = ref.watch(loginCtrlProvider.notifier);
                      var result = await ctrl.otpLogin(
                        state.email.toString(),
                        otpCode,
                      );

                      if (!context.mounted) return;

                      String messageToShow =
                          result['message'] ?? 'Opération terminée.';
                      bool isSuccess = result['status'] == 'OK';

                      if (isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              messageToShow,
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),
                        );
                        context.goNamed(Urls.main.name);
                      } else {
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
                      //widget.onNext();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Valider le code",
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Vous n\'avez pas reçu de code ? ',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Action à faire quand tu cliques sur le bouton
                        if (kDebugMode) {
                          print('Renvoyer le code');
                        }
                        //context.goNamed(Urls.home.name);
                      },
                      child: Text(
                        'Renvoyer',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
