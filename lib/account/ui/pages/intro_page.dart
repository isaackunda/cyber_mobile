import 'package:cyber_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../routers.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    _IntroContent(
      imageUrl: 'images/visuel-02.jpg',
      title: "Commandez",
      description: "Commandez vos supports de cours en quelques clics",
      //color: Colors.indigo,
    ),
    _IntroContent(
      imageUrl: 'images/visuel-03.jpg',
      title: "On imprime",
      description:
          "Nous imprimons vos documents avec une qualité professionnelle",
      //color: Colors.green,
    ),
    _IntroContent(
      imageUrl: 'images/visuel-04.jpg',
      title: "On vous livre",
      description: "Recevez vos documents directement à votre université",
      //color: Colors.black26,
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Aller à la page d'accueil
      context.pushReplacementNamed(Urls.auth.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Aller à la page d'accueil
                    context.pushReplacementNamed(Urls.auth.name);
                  },
                  child: const Text(
                    "Passer",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            Image.asset(
                Theme.of(context).brightness == Brightness.light ?
                'images/logo-04.png' :
                'images/logo-06.png', width: 300, height: 100),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (_, index) => _pages[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    _currentIndex == _pages.length - 1
                        ? "Commencer"
                        : "Suivant",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroContent extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Color? color;

  const _IntroContent({
    required this.imageUrl,
    required this.title,
    required this.description,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  child: Image.asset(
                    imageUrl,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover, // pour bien remplir le container
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
