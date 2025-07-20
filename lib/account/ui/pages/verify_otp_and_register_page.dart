import 'package:cyber_mobile/account/ui/pages/register_account_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpAndRegisterPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const VerifyOtpAndRegisterPage({super.key, required this.onNext});

  @override
  ConsumerState<VerifyOtpAndRegisterPage> createState() =>
      _OtpRegisterPageState();
}

class _OtpRegisterPageState extends ConsumerState<VerifyOtpAndRegisterPage> {
  String otpCode = '';

  /*void _verifyOtp(String code) {
    // Appelle le service ici
    if (OtpService.verifyOtp(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Code correct !')),
      );
      // Naviguer vers la page suivante
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Code incorrect')),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(registerAccountCtrlProvider);
    return Scaffold(
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
                      var ctrl = ref.watch(
                        registerAccountCtrlProvider.notifier,
                      );
                      var result = await ctrl.verifyOtpAndRegister(
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

                        widget.onNext();
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
