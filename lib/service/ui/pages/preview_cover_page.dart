import 'package:cyber_mobile/routers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreviewCoverPage extends StatefulWidget {
  const PreviewCoverPage({super.key});

  @override
  State<PreviewCoverPage> createState() => _PreviewCoverPageState();
}

class _PreviewCoverPageState extends State<PreviewCoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aperçu de la page de garde', style: TextStyle(fontFamily: 'Poppins',)),
      ),
      body: SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height:
              500, // La hauteur de l'élément, peut être la même que le SizedBox parent
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0), // Pou
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
        Text('Nom : cover_page.pdf, taille: 324 KB, Type : Page de garde, Nombre de pages: 10', style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins'
        ),),
            SizedBox(
              height: 24.0,
            ),
            Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              //Navigator.pop(context, true); // Retour avec succès
              context.pushNamed(Urls.payment.name);
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text("Utiliser cette page de garde"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
            ),
          ),),

          ],
        ),
      ),),
    );
  }
}
