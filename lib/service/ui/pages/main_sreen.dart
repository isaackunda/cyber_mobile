// lib/main_screen.dart (ou où tu veux l'appeler, ex: app_scaffold.dart)
import 'package:cyber_mobile/account/ui/pages/session_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Si tu as besoin de Riverpod ici
import 'home_page.dart';
import 'orders_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  // ConsumerStatefulWidget si besoin de ref
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0; // L'index de la page sélectionnée
  bool isLoading = true;
  // La liste des widgets de page. L'ordre doit correspondre aux BottomNavigationBarItem.
  // Ces widgets ne sont pas des Scaffolds complets, juste le contenu de la page.
  static const List<Widget> _pages = <Widget>[
    HomePage(), // Ta page d'accueil simplifiée
    OrdersPage(), // Ta page de commandes
    ProfilePage(), // Ta page de profil (à créer si pas encore faite)
  ];

  // Titres pour l'AppBar (optionnel, si tu veux un titre dynamique)
  final List<String> _pageTitles = ['Accueil', 'Mes Commandes', 'Mon Profil'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var ctrl = ref.read(sessionCtrlProvider.notifier);
      await ctrl.loadSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // C'est ici que le contenu de la page change
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        // Utilise NavigationBar (plus moderne)
        // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide, // Si tu veux cacher les labels
        //labelTextStyle: ,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Commandes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
