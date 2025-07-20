import 'package:cyber_mobile/service/business/models/cv.dart';
import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routers.dart';

class CvsPage extends ConsumerStatefulWidget {
  const CvsPage({super.key});

  @override
  ConsumerState<CvsPage> createState() => _CoversPageState();
}

class _CoversPageState extends ConsumerState<CvsPage> {
  List<Cv> pages = [];
  String? selectedPageId;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var cvState = ref.watch(cvCtrlProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Choisir une Page de Garde")),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 12,
          ),
          itemCount: cvState.cvs.length,
          itemBuilder: (context, index) {
            final model = cvState.cvs[index];
            final isSelected = model.id.toString() == selectedPageId;

            return GestureDetector(
              onTap: () {
                if (selectedPageId == model.id.toString()) {
                  setState(() {
                    selectedPageId = null;
                  });
                  return;
                }

                setState(
                  () => selectedPageId = cvState.cvs[index].id.toString(),
                );
                if (kDebugMode) {
                  print('page selected : $selectedPageId');
                }
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap:
                              () => Navigator.pop(
                                context,
                              ), // Ferme le preview au tap
                          child: InteractiveViewer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                model.image,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[100],
                      border: Border.all(
                        color:
                            (isSelected)
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        cvState.cvs[index].image,
                        fit: BoxFit.fitHeight,
                        width: double.infinity,
                        //height: double.infinity,
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
                      if (kDebugMode) {
                        print(' modele $selectedPageId ');
                      }
                      if (selectedPageId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Choisissez un modele de cv',
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

                      context.pushNamed(Urls.createCv.name);
                    },
                    icon: const Icon(Icons.edit_note_outlined),
                    label: Text(
                      "Configurer vos données",
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
}
