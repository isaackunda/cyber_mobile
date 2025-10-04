import 'package:cyber_mobile/routers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward(); // Démarre l'animation dès l'initialisation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Icône de succès animée
              AnimatedOpacity(
                opacity: _opacityAnimation.value,
                duration: const Duration(milliseconds: 800),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE8F5E9), // Vert très clair
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 📣 Titre principal
              Text(
                'Paiement effectué avec succès !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // 📝 Sous-titre explicatif
              Text(
                'Votre commande a été validée et le fichier sera traité rapidement.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // 🔘 Bouton d'action principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.pushReplacementNamed(context, Routes.home); // ← Redirige vers la home
                    context.pushReplacementNamed(Urls.main.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    //mainAxisSize: MainAxisSize.center,
                    children: [
                      const Icon(Icons.home, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Retour à l’accueil',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔗 Lien secondaire (optionnel)
              TextButton(
                onPressed: () {
                  //Navigator.pushReplacementNamed(context, Routes.orders);
                  context.pushReplacementNamed(Urls.main.name);
                },
                child: Text(
                  'Voir mes commandes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontFamily: 'Poppins',
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
