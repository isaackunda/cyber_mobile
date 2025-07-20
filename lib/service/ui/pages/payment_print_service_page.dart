import 'dart:io';

import 'package:cyber_mobile/service/ui/pages/upload_work_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';

import '../../../routers.dart';

class PaymentPrintServicePage extends ConsumerStatefulWidget {
  const PaymentPrintServicePage({super.key});

  @override
  ConsumerState<PaymentPrintServicePage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPrintServicePage> {
  String? selectedPayment; // "airtel" ou "mpesa"
  // Variables d'état pour gérer le fichier sélectionné et la progression
  String? _selectedFilePath;
  String? _selectedFileName;
  PdfController? _previewController;

  @override
  void initState() {
    super.initState();
    // Important : exécuter après le rendu initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreviewPdf();
    });
    // Vous pouvez initialiser des valeurs par défaut si nécessaire
  }

  Future<void> _loadPreviewPdf() async {
    // Libère l'ancien controller s'il existe déjà
    var state = ref.watch(uploadWorkCtrlProvider);
    if (kDebugMode) {
      print('object ${state.filepath}');
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

  void _selectPayment(String payment) {
    setState(() {
      selectedPayment = payment;
    });
  }

  Widget _buildPaymentButton(String label, String value, Color color) {
    final isSelected = selectedPayment == value;

    return GestureDetector(
      onTap: () => _selectPayment(value),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? color
                    : (Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }

  void _showPaymentBottomSheet(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
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
                ElevatedButton.icon(
                  onPressed: () {
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

                    // Logique de paiement ici
                    Navigator.pop(context); // Ferme le sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Paiement en cours pour $number',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    );
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(uploadWorkCtrlProvider);
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
                        '#123456',
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
                        '\$20.00',
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
              SizedBox(height: 24.0),
              /*Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mode de paiement',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Text("Choisissez votre mode de paiement", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      _buildPaymentButton(
                        "Airtel",
                        "airtel money",
                        Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 16.0),
                      _buildPaymentButton(
                        "M-Pesa",
                        "m-pesa",
                        Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                ],
              ),*/
              SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    //context.pushNamed(Urls.previewCover.name);
                    // Afficher le nouveau banner
                    /*if (selectedPayment == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Veuillez sélectionner un mode de paiement',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }*/
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
