import 'package:cyber_mobile/account/ui/pages/register_account_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../routers.dart';

class RegisterOtpPage extends ConsumerStatefulWidget {
  const RegisterOtpPage({super.key});

  @override
  ConsumerState<RegisterOtpPage> createState() => _RegisterOtpPageState();
}

class _RegisterOtpPageState extends ConsumerState<RegisterOtpPage> {
  var emailCtrl = TextEditingController(text: '');
  var phoneCtrl = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(registerAccountCtrlProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                'Créer un compte',
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
                TextSpan(text: ' pour commencer ton inscription.'),
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
                  var ctrl = ref.watch(registerAccountCtrlProvider.notifier);
                  var result = await ctrl.registerEmail(phoneCtrl);

                  if (!context.mounted) return;

                  String messageToShow =
                      result['message'] ?? 'Opération terminée.';
                  bool isSuccess = result['status'] == 'OK' || result['status'] == 'PENDING_OTP_VERIFICATION' ;
                  bool pending = result['status'] == 'NOK' ;

                  if (kDebugMode) {
                    print('step-01');
                  }

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
                    context.pushNamed(Urls.processRegister.name);
                  } if (pending) {
                    setState(() {
                      phoneCtrl = '';
                    });
                    emailCtrl.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          messageToShow,
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    );
                    context.pushNamed(Urls.registerAccount.name);
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
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Commencer l\'inscription',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
