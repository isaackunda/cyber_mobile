import 'package:cyber_mobile/account/ui/pages/verify_otp_and_register_page.dart';
import 'package:cyber_mobile/account/ui/pages/register_account_page.dart';
import 'package:flutter/material.dart';

class ProcessRegisterPage extends StatefulWidget {
  const ProcessRegisterPage({super.key});

  @override
  State<ProcessRegisterPage> createState() => _ProcessRegisterPageState();
}

class _ProcessRegisterPageState extends State<ProcessRegisterPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _nextPage() {
    if (_currentIndex < 1) {
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

  double _progressValue() {
    // ici tu peux adapter selon le nombre de pages
    return (_currentIndex + 1) / 2; // ex: page 1 => 0.5, page 2 => 1.0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Vérification' : 'Inscription'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.0),
            buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  VerifyOtpAndRegisterPage(
                    onNext: () {
                      _nextPage();
                    },
                  ),
                  RegisterAccountPage(
                    onNext: () {
                      _nextPage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Step 1
          Column(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor:
                    _currentIndex >= 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                child: Icon(
                  _currentIndex > 0 ? Icons.check : Icons.looks_one_outlined,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(height: 6),
              const Text("Vérification", style: TextStyle(fontSize: 12)),
            ],
          ),

          // Line
          Expanded(
            child: Container(
              height: 2,
              color:
                  _currentIndex >= 1
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
            ),
          ),

          // Step 2
          Column(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor:
                    _currentIndex >= 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
              const SizedBox(height: 6),
              const Text("Inscription", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
