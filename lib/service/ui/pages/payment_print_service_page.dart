import 'dart:io';

import 'package:cyber_mobile/account/ui/pages/session_ctrl.dart';
import 'package:cyber_mobile/routers.dart';
import 'package:cyber_mobile/service/business/models/order.dart';
import 'package:cyber_mobile/service/ui/pages/order_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/payment_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pdfx/pdfx.dart';

class PaymentPrintServicePage extends ConsumerStatefulWidget {
  const PaymentPrintServicePage({super.key});

  @override
  ConsumerState<PaymentPrintServicePage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPrintServicePage> {
  String? selectedPayment; // "airtel" ou "mpesa"
  // Variables d'état pour gérer le fichier sélectionné et la progression
  PdfController? _previewController;
  var phoneCtrl = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Important : exécuter après le rendu initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreviewPdf();
      var state = ref.watch(uploadWorkCtrlProvider);

      var ctrl = ref.read(orderCtrlProvider.notifier);
      var payState = ref.watch(paymentCtrlProvider);

      if (kDebugMode) {
        print('object ZIZI filepath ${state.filepath}');
      }

      var data = Order(
        ref: payState.reference,
        status: 'Paiement en attente',
        total: payState.montant,
        nbreDePages: state.selectedPages.length.toString(),
        link: state.filepath,
      );

      ctrl.addOrder(data);
    });
    // Vous pouvez initialiser des valeurs par défaut si nécessaire
  }

  Future<void> _loadPreviewPdf() async {
    // Libère l'ancien controller s'il existe déjà
    var state = ref.watch(uploadWorkCtrlProvider);
    if (kDebugMode) {
      print('object filepath : ${state.filepath}');
    }

    try {
      _previewController?.dispose();
    } catch (_) {}

    if (await File(state.filepath).exists()) {
      setState(() {
        _previewController = PdfController(
          document: PdfDocument.openFile(state.filepath),
        );
      });
      // ok
    } else {
      if (kDebugMode) {
        print('⚠️ Le fichier PDF n’existe pas à ${state.filepath}');
      }
    }
  }

  void _showPaymentBottomSheet(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        var state = ref.watch(sessionCtrlProvider);
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              var payState = ref.watch(paymentCtrlProvider);
              var sessionState = ref.watch(sessionCtrlProvider);
              //var payState = ref.watch(paymentCtrlProvider);
              var fileState = ref.watch(uploadWorkCtrlProvider);

              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Paiement via mobile',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Entrez votre numéro de téléphone :',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 20),

                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            final number = phoneCtrl;
                            if (number.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Veuillez entrer un numéro valide',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ),
                              );
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }

                            try {
                              final ctrl = ref.read(
                                paymentCtrlProvider.notifier,
                              );

                              // 🟡 ÉTAPE 1 : payBill
                              final resultPay = await ctrl.payBill(
                                payState.reference,
                                number,
                                sessionState.userData.sessionId,
                              );

                              final statusPay = resultPay['status'];
                              final messagePay =
                                  resultPay['message'] ?? 'Opération terminée.';

                              if (statusPay != 'OK') {
                                throw Exception(messagePay);
                              }

                              final start = DateTime.now();
                              final timeout = const Duration(
                                seconds: 30,
                              ); // Par exemple

                              // 🟡 ÉTAPE 2 : checkPayment (attends que le paiement soit confirmé)
                              final resultCheck = await ctrl.checkPayment(
                                sessionState.userData.sessionId,
                                start,
                                timeout,
                              );

                              final statusCheck = resultCheck['status'];
                              final messageCheck =
                                  resultCheck['message'] ??
                                  'Opération terminée.';

                              if (statusCheck != 'OK') {
                                throw Exception(messageCheck);
                              }

                              // 🟡 ÉTAPE 3 : sendFile (envoi du PDF)
                              final resultSend = await ctrl.sendFile(
                                fileState.filepath,
                                payState.reference,
                                payState.sessionId,
                                true,
                              );

                              final statusSend = resultSend['status'];
                              final messageSend =
                                  resultSend['message'] ??
                                  'Opération terminée.';

                              if (statusSend != 'OK') {
                                throw Exception(messageSend);
                              }

                              //if (!context.mounted) return;

                              setState(() {
                                isLoading = false;
                              });

                              // ✅ TOUT EST RÉUSSI → Ferme le bottom sheet + redirige + snack
                              Navigator.pop(context); // Ferme le bottom sheet

                              // 👉 ICI : on affiche le SnackBar sur la page parente (PrintPaymentPage)
                              // Et on redirige vers la page de succès
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Paiement effectué avec succès !\nFichier envoyé.',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              // ⚡ Redirection vers la page de succès (sans passer par une page "chargement")
                              context.pushNamed(Urls.paymentSuccessPage.name);
                            } catch (e) {
                              if (!context.mounted) return;
                              setState(() => isLoading = false);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text(
                            'Payer',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // ⬅️ Coins arrondis
                            ),
                          ),
                        ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(uploadWorkCtrlProvider);
    var payState = ref.watch(paymentCtrlProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Paiement')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Text(
                    'Aperçu',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ), // Ajouter un peu d'espace après le titre Aperçu
              // *** C'EST ICI QUE L'APERÇU DU DOCUMENT EST PLACÉ ***
              // Afficher l'aperçu si un chemin de fichier est disponible
              _previewController == null
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                    height: 300,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    child: PdfView(
                      physics: BouncingScrollPhysics(),
                      controller: _previewController!,
                      builders: PdfViewBuilders<DefaultBuilderOptions>(
                        options: const DefaultBuilderOptions(),
                        pageLoaderBuilder:
                            (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      ),
                      scrollDirection: Axis.vertical,
                    ),
                  ),
              SizedBox(height: 6.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Résumé de la commande',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CommandeID'),
                      Text(
                        payState.reference,
                        style: TextStyle(
                          //fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nombre de pages'),
                      Text(
                        '${state.selectedPages.length}',
                        style: TextStyle(
                          //fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Text(
                        payState.montant,
                        style: TextStyle(
                          //fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Livraison'),
                      Text(
                        'Standard (3-5 jours)',
                        style: TextStyle(
                          //fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //SizedBox(height: 24.0),
              SizedBox(height: 24.0),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _showPaymentBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Proceder aux paiement',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
