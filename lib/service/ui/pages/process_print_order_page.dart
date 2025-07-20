import 'package:cyber_mobile/service/ui/pages/covers_page.dart';
import 'package:cyber_mobile/service/ui/pages/payment_print_service_page.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routers.dart';

class ProcessPrintOrderPage extends StatefulWidget {
  const ProcessPrintOrderPage({super.key});

  @override
  State<ProcessPrintOrderPage> createState() => _ProcessPrintOrderPageState();
}

class _ProcessPrintOrderPageState extends State<ProcessPrintOrderPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _nextPage() {
    if (_currentIndex < 2) {
      setState(() => _currentIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Action finale : valider l'inscription
      // Navigator.push(...);
    }
  }

  final List<String> titles = [
    'Telecharger votre fichier',
    'Choisir une Page de Garde',
    'Paiement',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        actions: [
          if (_currentIndex == 1)
            IconButton(
              onPressed: () {
                context.pushNamed(Urls.cover.name);
                //_ajouterNouvellePageDeGarde();
              },
              icon: Icon(Icons.add),
              tooltip: "Ajouter une nouvelle page de garde",
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            //SizedBox(height: 16.0),
            //buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  UploadWorkPage(
                    onNext: () {
                      _nextPage();
                    },
                  ),
                  /*CoversPage(
                    onNext: () {
                      _nextPage();
                    }, file: null, selectedPages: [],
                  ),*/
                  //PaymentPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
