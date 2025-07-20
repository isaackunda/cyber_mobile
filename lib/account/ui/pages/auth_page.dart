import 'package:cyber_mobile/account/ui/pages/register_otp_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //const Spacer(),
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'images/logo-04.png'
                    : 'images/logo-06.png',
                width: 150,
                height: 100,
              ),
              const Spacer(),
              /*IconButton(
                icon: Icon(
                    Icons.nightlight_round,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  // Action à faire quand tu cliques sur la lune
                },
              ),*/
            ],
          ),
          bottom: const TabBar(
            //padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
            tabs: [Tab(text: 'CONNEXION'), Tab(text: 'INSCRIPTION')],
          ),
        ),
        body: SafeArea(
          child: const TabBarView(
            children: [LoginPage(), RegisterOtpPage()],
          ),
        ),
      ),
    );
  }
}
