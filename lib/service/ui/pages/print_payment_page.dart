import 'dart:io';

import 'package:cyber_mobile/account/ui/pages/session_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/order_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/payment_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_ctrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';

import '../../../routers.dart';

class PrintPaymentPage extends ConsumerStatefulWidget {
  const PrintPaymentPage({super.key});

  @override
  ConsumerState<PrintPaymentPage> createState() => _PrintPaymentPageState();
}

class _PrintPaymentPageState extends ConsumerState<PrintPaymentPage> {
  String? selectedPayment; // "airtel" ou "mpesa"
  // Variables d'état pour gérer le fichier sélectionné et la progression
  String? _selectedFilePath;
  String? _selectedFileName;
  PdfController? _previewController;

  @override
  void initState() {
    super.initState();
    // Vous pouvez initialiser des valeurs par défaut si nécessaire

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreviewPdf();
    });
  }

  Future<void> _loadPreviewPdf() async {
    // Libère l'ancien controller s'il existe déjà
    var state = ref.watch(uploadWorkCtrlProvider);
    var orderState = ref.watch(orderCtrlProvider);
    if (kDebugMode) {
      print('object ${state.filepath}');
    }

    try {
      _previewController?.dispose();
    } catch (_) {}

    if (await File(state.filepath).exists()) {
      setState(() {
        _previewController = PdfController(
          document: PdfDocument.openFile(orderState.order.link),
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
        var sessionState = ref.watch(sessionCtrlProvider);
        var payState = ref.watch(paymentCtrlProvider);

        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
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
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        //hintText: '0990000000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

                            final number = phoneController.text.trim();
                            if (number.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Veuillez entrer un numéro valide',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ),
                              );
                              return;
                            }

                            var ctrl = ref.watch(paymentCtrlProvider.notifier);
                            ctrl.payBill(
                              number,
                              sessionState.userData.sessionId,
                            );

                            var result = await ctrl.checkPayment(
                              sessionState.userData.sessionId,
                            );

                            if (!context.mounted) return;

                            String messageToShow =
                                result['message'] ?? 'Opération terminée.';
                            bool isSucess = result['status'] == 'OK';
                            bool pending = result['status'] == 'NOK';

                            if (isSucess) {
                              setState(() {
                                isLoading = false;
                              });

                              /*var orderCtrl = ref.read(
                                orderCtrlProvider.notifier,
                              );
                              await orderCtrl.updateOrder(payState.reference);

                              if (!context.mounted) return;*/

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    messageToShow,
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ),
                              );
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context); //
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
    var orderState = ref.watch(orderCtrlProvider);

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
                      Text(
                        'CommandeID',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      Text(
                        orderState.order.ref,
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
                      Text('Total', style: TextStyle(fontFamily: 'Poppins')),
                      Text(
                        orderState.order.total,
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
