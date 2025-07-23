import 'package:cyber_mobile/account/ui/pages/session_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/payment_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_ctrl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';

import '../../../routers.dart';
import '../../business/models/cover_page_model.dart';
import '../../business/models/print_info.dart';

class CoversPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const CoversPage({super.key, required this.onNext});

  @override
  ConsumerState<CoversPage> createState() => _CoversPageState();
}

class _CoversPageState extends ConsumerState<CoversPage> {
  List<CoverPageModel> pages = [];
  String? selectedPageId;
  bool isLoading = false;

  Future<void> _ajouterNouvellePageDeGarde() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      setState(() {
        pages.add(
          CoverPageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            path: file.path!,
            title: file.name,
            ownerId: '',
            content: '',
            createdAt: null,
          ),
        );
      });
    }
  }

  void _validerPageDeGarde() {
    final selectedPage = pages.firstWhere((page) => page.id == selectedPageId);
    //Navigator.pop(context, selectedPage);
    if (kDebugMode) {
      print('object OK Ok');
    }
    if (kDebugMode) {
      print('object: ${selectedPage.path}');
    }
  }

  Future<Map<String, dynamic>> _handlePdfCreation() async {
    setState(() {
      isLoading = true;
    });

    if (kDebugMode) {
      print('object go');
    }
    final selectedPage =
        selectedPageId != null
            ? pages.firstWhere((page) => page.id == selectedPageId)
            : null;

    if (kDebugMode) {
      print('object selected page id = $selectedPageId');
    }

    var ctrl = ref.watch(uploadWorkCtrlProvider.notifier);

    var result =
        selectedPageId != null
            ? await ctrl.createPdfFromSelectedPages(
              withCoverPage: true,
              coverPageFile: selectedPage,
            )
            : await ctrl.createPdfFromSelectedPages();
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
    var state = ref.read(uploadWorkCtrlProvider);
    if (kDebugMode) {
      print('in coversPage : ${state.pdfFile}');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Choisir une Page de Garde"),
        actions: [
          IconButton(
            onPressed: () {
              //context.pushNamed(Urls.cover.name);
              _ajouterNouvellePageDeGarde();
            },
            icon: Icon(Icons.add),
            tooltip: "Ajouter une nouvelle page de garde",
          ),
        ],
      ),
      body:
          pages.isEmpty
              ? SafeArea(
                child: Center(child: Text("Aucune page de garde disponible.")),
              )
              : SafeArea(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    final isSelected = page.id == selectedPageId;

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedPageId = page.id);
                        if (kDebugMode) {
                          print('page selected : $selectedPageId');
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                              color: Colors.grey[100],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: PdfView(
                                    controller: PdfController(
                                      document: PdfDocument.openFile(page.path),
                                    ),
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    page.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
                    );
                  },
                ),
              ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              isLoading
                  ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                  : ElevatedButton.icon(
                    onPressed: () async {
                      if (selectedPageId != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Ajouter une page de garde',
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

                      final result = await _handlePdfCreation();

                      String messageToShow =
                          result['message'] ?? 'Opération terminée.';
                      bool isSuccess = result['status'] == 'OK';

                      if (!context.mounted) return;

                      if (!isSuccess) {
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
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            messageToShow,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                      );
                      //context.pushNamed(Urls.paymentPrintService.name);
                      showPrintModeSelector(context);
                    },
                    icon: const Icon(Icons.payment),
                    label: Text(
                      selectedPageId != null
                          ? "Valider la page de garde"
                          : "Continuer vers le paiement",
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
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
              final sessionState = ref.watch(sessionCtrlProvider);

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
                                      pages:
                                          uploadState.selectedPages.length
                                              .toString(),
                                      sessionId:
                                          sessionState.userData.sessionId,
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
