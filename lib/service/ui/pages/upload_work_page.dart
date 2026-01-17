import 'dart:io';

import 'package:cyber_mobile/account/ui/pages/login_ctrl.dart';
import 'package:cyber_mobile/account/ui/pages/session_ctrl.dart';
import 'package:cyber_mobile/service/business/models/print_info.dart';
import 'package:cyber_mobile/service/ui/pages/payment_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_ctrl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:printing/printing.dart';
import '../../../routers.dart';

class UploadWorkPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const UploadWorkPage({super.key, required this.onNext});

  @override
  ConsumerState<UploadWorkPage> createState() => _UploadWorkPageState();
}

class _UploadWorkPageState extends ConsumerState<UploadWorkPage> {
  // Variables d'état pour gérer le fichier sélectionné et la progression
  String? _selectedFilePath;
  String? _selectedFileName;
  double _fileSizeMB = 0.0;
  double _downloadProgress =
      0.0; // Pour simuler la progression ou l'utiliser avec flutter_downloader
  String _selectedPagesInput = '';
  List<int> _selectedPages = [];
  int _pageCount = 0;
  Uint8List? _generatedPdf;
  PdfController? _previewController;
  final Map<int, PdfControllerPinch> _pageControllers = {};
  File? _pdfFile;
  PdfDocument? _pdfDoc;
  File? savedFile;
  bool isChecked = false;
  bool isLoading = false;
  bool _isFileValid = false;

  @override
  void initState() {
    super.initState();
    // Vous pouvez initialiser des valeurs par défaut si nécessaire
  }

  // Fonction pour sélectionner le fichier PDF

  Future<void> pickPdfFile() async {
    try {
      // ... sélection avec FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final file = result.files.first;
        final tempFile = File(file.path!);

        // Copier dans le dossier app
        final appDir = await getApplicationDocumentsDirectory();
        final newPath = '${appDir.path}/${file.name}';
        savedFile = await tempFile.copy(newPath);

        // Valider le fichier
        _isFileValid =
            await savedFile!.exists() && (await savedFile!.length() > 0);

        if (_isFileValid) {
          _selectedFilePath = savedFile!.path;
          _selectedFileName = file.name;
          _fileSizeMB = file.size / (1024 * 1024);
          _pageCount = (await PdfDocument.openFile(savedFile!.path)).pagesCount;

          await _loadPreviewPdf(savedFile!.path); // ✅ Utilise savedFile
        }

        setState(() {});
      }
    } catch (e) {
      // gestion erreur
    }
  }

  Future<void> _loadPreviewPdf(String filePath) async {
    _previewController?.dispose();
    try {
      setState(() {
        _previewController = PdfController(
          document: PdfDocument.openFile(filePath),
        );
      });
    } catch (e) {
      // gestion erreur
      setState(() {
        _previewController = null;
      });
    }
  }

  // Nouvelle fonction pour supprimer le fichier
  Future<void> _deleteSelectedPdf() async {
    if (_selectedFilePath != null) {
      try {
        final file = File(_selectedFilePath!);
        if (await file.exists()) {
          await file.delete(); // Supprime le fichier du système de fichiers
          setState(() {
            _selectedFilePath = null; // Réinitialise le chemin du fichier
            _selectedFileName = null; // Réinitialise le nom du fichier
            _fileSizeMB = 0.0; // Réinitialise la taille
            _downloadProgress = 0.0; // Réinitialise la progression
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fichier PDF supprimé avec succès !')),
          );
          if (kDebugMode) {
            print('Fichier supprimé : $_selectedFilePath');
          }
        } else {
          if (kDebugMode) {
            print('Le fichier n\'existe pas : $_selectedFilePath');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le fichier n\'existe plus.')),
          );
          // Même si le fichier n'existe plus, réinitialiser l'état
          setState(() {
            _selectedFilePath = null;
            _selectedFileName = null;
            _fileSizeMB = 0.0;
            _downloadProgress = 0.0;
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erreur lors de la suppression du fichier: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression du fichier: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun fichier à supprimer.')),
      );
    }
  }

  List<int> parsePageRanges(String input, int maxPage) {
    final Set<int> pages = {};
    final regex = RegExp(r'(\d+)(?:-(\d+))?');

    for (final match in regex.allMatches(input)) {
      int start = int.parse(match.group(1)!);
      int end = match.group(2) != null ? int.parse(match.group(2)!) : start;

      if (start > end) {
        final temp = start;
        start = end;
        end = temp;
      }

      for (int i = start; i <= end && i <= maxPage; i++) {
        pages.add(i);
      }
    }

    return pages.where((p) => p >= 1 && p <= maxPage).toList()..sort();
  }

  void _updateSelectedPages(String value) {
    setState(() {
      _selectedPagesInput = value;
      _selectedPages = parsePageRanges(value, _pageCount);
    });

    if (kDebugMode) {
      print(' Page Selectioner $_selectedPages');
    }
  }

  void _selectQuick(String type) {
    switch (type) {
      case 'all':
        setState(
          () => _selectedPages = List.generate(_pageCount, (i) => i + 1),
        );
        if (kDebugMode) {
          print(' Page Selectioner $_selectedPages');
        }
        break;
      case 'even':
        setState(
          () =>
              _selectedPages =
                  List.generate(
                    _pageCount,
                    (i) => i + 1,
                  ).where((p) => p % 2 == 0).toList(),
        );
        break;
      case 'odd':
        setState(
          () =>
              _selectedPages =
                  List.generate(
                    _pageCount,
                    (i) => i + 1,
                  ).where((p) => p % 2 != 0).toList(),
        );
        break;
      case 'reverse':
        setState(() => _selectedPages = _selectedPages.reversed.toList());
        break;
    }
  }

  Future<Map<String, dynamic>> _handlePdfCreation() async {
    setState(() {
      isLoading = true;
    });

    if (kDebugMode) {
      print('object go');
    }

    var ctrl = ref.watch(uploadWorkCtrlProvider.notifier);

    var result = await ctrl.createPdfFromSelectedPages();
    //widget.onNext();
    if (kDebugMode) {
      print('object resuslt = $result');
    }

    bool isSuccess = result['status'] == 'OK';

    if (isSuccess) {
      setState(() {
        isLoading = false;
      });
      return {'status': 'OK', 'message': 'Document PDF créé avec succès.'};
    } else {
      setState(() {
        isLoading = false;
      });
      return {
        'status': 'KO',
        'message': 'Une erreur est survenue lors de la création du PDF.',
      };
    }
  }

  Future<bool> _handleUpload() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final currentPreviewController = _previewController;
    final currentSelectedPath = _selectedFilePath;

    // Largeur maximale pour le conteneur de l'aperçu
    double previewWidth =
        MediaQuery.of(context).size.width -
        (2 * 24.0); // Largeur de l'écran - padding

    return Scaffold(
      appBar: AppBar(
        //
        title: Text('Telecharger votre fichier'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            //
            Text(
              'Téléchargez vos travaux scientifiques',
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Sélectionnez le fichier PDF contenant le fichier. Assurez vous qu\'il respecte les exigences de taille et de format.',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  //
                  pickPdfFile();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Sélectionner le fichier PDF',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ),
            SizedBox(height: 24),
            const SizedBox(height: 24),

            // Section de téléchargement (affichage conditionnel si un fichier est sélectionné)
            if (_selectedFilePath != null) ...[
              Row(
                children: [
                  const Text(
                    'Fichier sélectionné:', // Changement de texte pour refléter "sélectionné"
                    style: TextStyle(fontFamily: 'Poppins'),
                    textAlign: TextAlign.start,
                  ),
                  const Spacer(),
                  // Bouton de suppression !
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed:
                        _deleteSelectedPdf, // Appel de la fonction de suppression
                    tooltip: 'Supprimer le PDF sélectionné',
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),

            // Section de téléchargement (affichage conditionnel si un fichier est sélectionné)
            if (_selectedFilePath != null) ...[
              Row(
                children: [
                  const Text(
                    'Téléchargement...',
                    style: TextStyle(fontFamily: 'Poppins'),
                    textAlign: TextAlign.start,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16.0),
              LinearProgressIndicator(
                value: _downloadProgress,
              ), // Progression dynamique
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    '${(_downloadProgress * 100).toStringAsFixed(0)}% Complet', // Affichage dynamique du %
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 24.0),
              Text(
                // Affichage dynamique de la taille et du nom du fichier
                'Taille du fichier: ${_fileSizeMB.toStringAsFixed(2)}MB (${_selectedFileName ?? 'N/A'})',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            Row(
              children: [
                const Text(
                  'Format: PDF uniquement',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Text(
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
            if (currentPreviewController != null &&
                currentSelectedPath != null &&
                File(_selectedFilePath!).existsSync())
              Container(
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
                  controller: currentPreviewController,
                  builders: PdfViewBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    pageLoaderBuilder:
                        (_) => const Center(child: CircularProgressIndicator()),
                  ),
                  scrollDirection: Axis.vertical,
                ),
              )
            else if (_selectedFilePath == null)
              // Message à afficher si aucun fichier n'est sélectionné
              const Center(
                child: Text(
                  'Aucun fichier PDF sélectionné pour l\'aperçu.',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              // Message à afficher si le fichier est sélectionné mais introuvable/corrompu
              const Center(
                child: Text(
                  'Impossible d\'afficher l\'aperçu. Fichier non valide ou introuvable.',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            SizedBox(height: 24.0),

            if (_selectedFilePath != null)
              TextField(
                decoration: InputDecoration(
                  hintText: "1, 3-5, 7",
                  labelText: "Entrer les pages à imprimer",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _updateSelectedPages,
              ),
            if (_selectedFilePath != null) ...[
              const SizedBox(height: 8),
              const Text(
                "Entrez les numéros de pages à inclure, séparés par un espace, une virgule ou un tiret.\n"
                "Exemples valides :\n"
                "• 1 3 5    → Pages 1, 3 et 5\n"
                "• 2-4      → Pages 2 à 4\n"
                "• 1,3-5 7 → Pages 1, 3 à 5, et 7\n\n"
                "Les espaces, virgules et tirets sont tous acceptés.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  fontFamily: 'Poppins',
                ),
              ),

              SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: Text(
                      "Tout sélectionner",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        fontFamily: 'Poppins'
                      ),
                    ),
                    selected: false, // fixe, pas besoin d'état ici
                    backgroundColor: Colors.white,
                    elevation: 3,
                    pressElevation: 6,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    avatar: Icon(
                      Icons.check_circle_outline,
                      color: Colors.grey.shade400,
                      size: 18,
                    ),
                    onSelected: (_) => _selectQuick('all'),
                  )

                ],
              ),
              SizedBox(height: 12),
              Text("Pages sélectionnées : ${_selectedPages.join(", ")}"),
              SizedBox(height: 24),
            ],

            if (_generatedPdf != null) ...[
              SizedBox(height: 24),
              Text(
                "Aperçu du nouveau PDF généré",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                height: 300,
                margin: EdgeInsets.only(top: 8),
                child: PdfPreview(build: (format) async => _generatedPdf!),
              ),
            ],

            //SizedBox(height: 16.0),
            /*CheckboxListTile(
              title: Text("Impression avec page de garde"),
              subtitle: Text(
                "Permet d'insérer une page de garde avant le contenu principal",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
              ),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),*/
            /*if (_selectedFilePath != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Impression avec page de garde",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 16.0),
            ],*/
            if (_selectedFilePath != null)
              SizedBox(
                width: double.infinity,
                child:
                    isLoading
                        ? Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              /*SizedBox(height: 12.0),
                              Text(
                                'Veiller patienter...',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12, // si jamais ça déborde
                                ),
                              ),*/
                            ],
                          ),
                        )
                        : ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    if (currentSelectedPath != null) {
                                      var ctrl = ref.read(
                                        uploadWorkCtrlProvider.notifier,
                                      );
                                      if (kDebugMode) {
                                        print('object saved dile $savedFile');
                                      }

                                      if (_selectedPages.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Aucune page selectionner.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );

                                        return;
                                      }

                                      await ctrl.setPdf(savedFile!);

                                      if (!context.mounted) return;

                                      ctrl.updateSelectedPages(_selectedPages);
                                      if (kDebugMode) {
                                        print('object file $savedFile');
                                        print('object pages $_selectedPages');
                                      }

                                      //pickPdfFile();
                                      //widget.onNext();
                                      if (!isChecked) {
                                        //
                                        final result =
                                            await _handlePdfCreation();

                                        String messageToShow =
                                            result['message'] ??
                                            'Opération terminée.';
                                        bool isSuccess =
                                            result['status'] == 'OK';

                                        if (!context.mounted) return;

                                        if (!isSuccess) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
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
                                          return;
                                        }

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              messageToShow,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                        );
                                        //context.pushNamed(Urls.paymentPrintService.name);
                                        showPrintModeSelector(context);
                                      } else {
                                        context.pushNamed(
                                          Urls.covers.name,
                                          extra: savedFile,
                                        );
                                      }

                                      //context.pushNamed(Urls.covers.name, extra: savedFile);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Aucun fichier sélectionné.',
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
                          child: Text(
                            isChecked
                                ? 'Ajouter une page de garde'
                                : 'Continuer vers le paiement',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
              ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /*Future showPrintModeSelector(BuildContext context) async {
    var state = ref.watch(paymentCtrlProvider);
    String? selectedMode;

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
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Choisissez le mode d'impression",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Option : Noir et Blanc
                    ListTile(
                      leading: const Icon(Icons.print, color: Colors.grey),
                      title: const Text("Noir et Blanc"),
                      trailing:
                          selectedMode == 'bw'
                              ? const Icon(Icons.check_circle)
                              : null,
                      onTap: () => setState(() => selectedMode = 'bw'),
                    ),

                    // Option : Couleur
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

                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ElevatedButton.icon(
                        onPressed:
                            selectedMode != null
                                ? () async {
                                  var data = PrintInfo(
                                    key: selectedMode.toString(),
                                    pages: _selectedPages.length.toString(),
                                    sessionId: state.sessionId.toString(),
                                  );

                                  var ctrl = ref.read(
                                    paymentCtrlProvider.notifier,
                                  );

                                  var result = await ctrl.getPriceInfos(data);
                                  //Navigator.pop(context, selectedMode);
                                  //var isSucess = await _handleUpload();

                                  if (!context.mounted) return;

                                  String messageToShow =
                                      result['message'] ??
                                      'Opération terminée.';
                                  bool isSuccess = result['status'] == 'OK';
                                  //bool pending = result['status'] == 'NOK';

                                  if (isSuccess) {
                                    if (!context.mounted) return;

                                    context.pushNamed(
                                      Urls.paymentPrintService.name,
                                    );
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
  }*/

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
              var state = ref.watch(sessionCtrlProvider);

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
                          selectedMode == 'n&b'
                              ? const Icon(Icons.check_circle)
                              : null,
                      onTap: () => setState(() => selectedMode = 'n&b'),
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
                                      pages: _selectedPages.length.toString(),
                                      sessionId: state.userData.sessionId,
                                    );

                                    final ctrl = ref.watch(
                                      paymentCtrlProvider.notifier,
                                    );

                                    final result = await ctrl
                                        .getPrintPriceInfos(data);

                                    //print('');

                                    if (!context.mounted) return;

                                    final isSuccess = result['status'] == 'OK';
                                    final message =
                                        result['message'] ??
                                        'Opération terminée.';

                                    if (isSuccess) {
                                      setState(() => isLoading = false);
                                      context.pushNamed(
                                        Urls.paymentPrintService.name,
                                      );
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
