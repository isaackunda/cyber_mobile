import 'package:cyber_mobile/account/ui/pages/register_account_ctrl.dart';
import 'package:cyber_mobile/account/ui/pages/session_ctrl.dart';
import 'package:cyber_mobile/service/business/models/cover_page_model.dart';
import 'package:cyber_mobile/service/ui/pages/cover_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/payment_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../routers.dart';
import '../../business/models/print_info.dart';

class CoverPage extends ConsumerStatefulWidget {
  const CoverPage({super.key});

  @override
  ConsumerState<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends ConsumerState<CoverPage> {
  final _formKey = GlobalKey<FormState>();
  final titreCtrl = TextEditingController(text: '');
  final nameCtrl = TextEditingController(text: '');
  final TextEditingController _dateController = TextEditingController();

  String? selectedPageId;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // Fonction pour afficher le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Date initiale affichée dans le sélecteur
      firstDate: DateTime(
        2000,
      ), // Date la plus ancienne que l'utilisateur peut choisir
      lastDate: DateTime(
        2101,
      ), // Date la plus récente que l'utilisateur peut choisir
      builder: (context, child) {
        return Theme(
          // Personnaliser le thème du date picker (optionnel)
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Theme.of(
                    context,
                  ).colorScheme.primary, // Couleur principale du picker
              onPrimary:
                  Colors.white, // Couleur du texte sur la couleur principale
              surface: Colors.white, // Couleur de fond du picker
              onSurface: Colors.black, // Couleur du texte sur le fond
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(context)
                        .colorScheme
                        .primary, // Couleur des boutons "OK", "Annuler"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Formater la date sélectionnée en une chaîne (ex: 2024-05-30)
      String formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(pickedDate); // Ou 'dd/MM/yyyy'
      setState(() {
        _dateController.text = formattedDate; // Mettre à jour le texte du champ
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(registerAccountCtrlProvider);
    var coverPageState = ref.watch(coverCtrlProvider);
    var sessionState = ref.watch(sessionCtrlProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Page de garde')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                const Text(
                  'Modèles',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20.0),

            // *** CORRECTION ICI : Donnez une hauteur fixe au ListView.builder ***
            SizedBox(
              // Ou Container
              height:
                  280.0, // Donnez la hauteur que vous souhaitez pour votre liste horizontale
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    coverPageState
                        .coverPages
                        .length, // <--- IMPORTANT : Ajoutez un itemCount, sinon le builder n'affichera rien
                itemBuilder: (BuildContext context, int index) {
                  final page = coverPageState.coverPages[index];
                  final isSelected = page.id == selectedPageId;

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (selectedPageId == page.id) {
                            //
                            setState(() {
                              selectedPageId = '';
                            });

                            return;
                          }

                          setState(() => selectedPageId = page.id);

                          var data = CoverPageModel(
                            id: page.id,
                            title: page.title,
                            ownerId: page.ownerId,
                            content: page.content,
                            path: page.path,
                          );

                          var ctrl = ref.read(coverCtrlProvider.notifier);
                          ctrl.selectCoverPage(data);
                          if (kDebugMode) {
                            print('page selected : $selectedPageId');
                          }
                          if (kDebugMode) {
                            print('J\'ai cliquer ici !');
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              height:
                                  280, // La hauteur de l'élément, peut être la même que le SizedBox parent
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8.0), // Pou
                              ),
                              child: Center(
                                child: Text(
                                  'Modèle ${index + 1}', // Pour visualiser les différents éléments
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
              ],
            ),
            SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    //controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Titre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white, // Couleur de la bordure
                          width: 1.5, // Épaisseur
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.article_outlined, // Icône utilisateur
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
                  TextFormField(
                    //controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white, // Couleur de la bordure
                          width: 1.5, // Épaisseur
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person, // Icône utilisateur
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
                  Column(
                    children: [
                      TextFormField(
                        controller: _dateController,
                        readOnly: true, // Empêche l'édition directe du texte
                        onTap:
                            () => _selectDate(
                              context,
                            ), // Appelle le sélecteur de date au clic
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_today, // Icône de calendrier
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          suffixIcon: IconButton(
                            // Icône pour effacer la date (optionnel)
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _dateController.clear();
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner une date';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    //controller: emailCtrl,
                    enabled: false,
                    initialValue: sessionState.userData.university,
                    decoration: InputDecoration(
                      labelText: sessionState.userData.university,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white, // Couleur de la bordure
                          width: 1.5, // Épaisseur
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.school_outlined, // Icône utilisateur
                        color: Colors.white12, // Couleur de l'icône
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (coverPageState.selectCoverPage.id == 'N/A') {
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Choisissez un modele de page de garde !',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        }

                        if (!_formKey.currentState!.validate()) {
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ajoutez les informations de la page de garde',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        }

                        //context.pushNamed(Urls.previewCover.name);
                        showPrintModeSelector(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Créer votre page de garde',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showPrintModeSelector(BuildContext context) async {
    String? selectedMode;
    bool isLoading = false;

    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              final state = ref.watch(paymentCtrlProvider);
              final uploadState = ref.watch(uploadWorkCtrlProvider);
              var sessionState = ref.watch(sessionCtrlProvider);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Choisissez le mode d'impression",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Option Noir et Blanc
                    ListTile(
                      leading: const Icon(Icons.print, color: Colors.grey),
                      title: const Text("Noir et Blanc"),
                      trailing:
                          selectedMode == 'bw'
                              ? const Icon(Icons.check_circle)
                              : null,
                      onTap: () => setState(() => selectedMode = 'bw'),
                    ),

                    // Option Couleur
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: const Text("Couleur"),
                      trailing:
                          selectedMode == 'color'
                              ? const Icon(Icons.check_circle)
                              : null,
                      onTap: () => setState(() => selectedMode = 'color'),
                    ),

                    const SizedBox(height: 24),

                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                          onPressed:
                              selectedMode != null
                                  ? () async {
                                    setState(() => isLoading = true);

                                    if (kDebugMode) {
                                      print('object $selectedMode');
                                    }

                                    final data = PrintInfo(
                                      key: selectedMode!,
                                      pages: '1',
                                      sessionId: sessionState.userData.sessionId,
                                    );

                                    final ctrl = ref.watch(
                                      paymentCtrlProvider.notifier,
                                    );

                                    final result = await ctrl
                                        .getPrintPriceInfos(data);

                                    if (!context.mounted) return;

                                    final isSuccess = result['status'] == 'OK';
                                    final message =
                                        result['message'] ??
                                        'Opération terminée.';

                                    if (isSuccess) {
                                      setState(() => isLoading = false);
                                      context.pushNamed(Urls.payment.name);
                                    } else {
                                      setState(() => isLoading = false);
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            message,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                  : null,
                          icon: const Icon(Icons.check),
                          label: const Text("Confirmer"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey,
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
}
