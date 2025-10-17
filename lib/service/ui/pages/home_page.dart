import 'package:cyber_mobile/account/ui/pages/login_ctrl.dart';
import 'package:cyber_mobile/account/ui/pages/register_account_ctrl.dart';
import 'package:cyber_mobile/account/ui/pages/session_ctrl.dart';
import 'package:cyber_mobile/routers.dart';
import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'orders_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysHide;

  // 2. La liste de toutes vos pages
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    OrdersPage(),
    //ProfilePage(),
  ];

  // 3. Fonction appelée quand un onglet est tapé
  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index; // Met à jour l'index sélectionné
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(sessionCtrlProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cyber Mobile +'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: ListView(
            //physics: ,
            children: [
              //SizedBox(height: 24),
              Text(
                'Bienvenue, ${state.userData.name}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  overflow: TextOverflow.ellipsis, // si jamais ça déborde
                ),
              ),

              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    // <--- ici
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Imprimez Votre Travail',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            overflow:
                                TextOverflow.ellipsis, // si jamais ça déborde
                          ),
                          maxLines: 6,
                        ),
                        Text(
                          'Envoyez vos documents depuis l’application et récupérez-les en point relais ou à domicile',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            overflow:
                                TextOverflow.ellipsis, // si jamais ça déborde
                          ),
                          maxLines: 2, // ou plus selon ton envie
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.pushNamed(Urls.upload.name);
                            if (kDebugMode) {
                              print('object');
                            }
                          },
                          icon: Icon(Icons.print_outlined, color: Colors.white),
                          iconAlignment: IconAlignment.end,
                          label: Text(
                            'Télécharger',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ), // petit espace entre le texte et l’image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'images/visuel-03.jpg',
                      width: 100,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

              /*SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    // <--- ici
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Créer une Page de Garde',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            overflow:
                                TextOverflow.ellipsis, // si jamais ça déborde
                          ),
                          maxLines: 6,
                        ),
                        Text(
                          'Conception de page de couverture professionnelle pour vos documents',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            overflow:
                                TextOverflow.ellipsis, // si jamais ça déborde
                          ),
                          maxLines: 2, // ou plus selon ton envie
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.pushNamed(Urls.cover.name);
                          },
                          icon: Icon(
                            Icons.create_outlined,
                            color: Colors.white,
                          ),
                          iconAlignment: IconAlignment.end,
                          label: Text(
                            'Créer Maintenant',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ), // petit espace entre le texte et l’image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'images/visuel-04.jpg',
                      width: 100,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    // <--- ici
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Créer un CV',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            overflow:
                                TextOverflow.ellipsis, // si jamais ça déborde
                          ),
                          maxLines: 6,
                        ),
                        Text(
                          'rédigez un CV professionnel pour mettre en valeur vos compétences et votre expérience',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            overflow:
                                TextOverflow.ellipsis, // si jamais ça déborde
                          ),
                          maxLines: 2, // ou plus selon ton envie
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.pushNamed(Urls.cvs.name);
                          },
                          icon: Icon(
                            Icons.article_outlined,
                            color: Colors.white,
                          ),
                          iconAlignment: IconAlignment.end,
                          label: Text(
                            'Créer',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ), // petit espace entre le texte et l’image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'images/visuel-07.jpg',
                      width: 100,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),*/

              /*Row(
                children: [
                  Expanded(
                    // <--- ici
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suivre Vos Commandes',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            overflow:
                            TextOverflow.ellipsis, // si jamais ça déborde
                          ),
                          maxLines: 6,
                        ),
                        Text(
                          'Suivez l\'avancement de vos commandes en temps réel',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            overflow:
                            TextOverflow.ellipsis, // si jamais ça déborde
                          ),
                          maxLines: 2, // ou plus selon ton envie
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.pushNamed(Urls.orders.name);
                          },
                          icon: Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.white,
                          ),
                          iconAlignment: IconAlignment.end,
                          label: Text(
                            'Suivre',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ), // petit espace entre le texte et l’image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'images/visuel-03.jpg',
                      width: 100,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),*/
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
