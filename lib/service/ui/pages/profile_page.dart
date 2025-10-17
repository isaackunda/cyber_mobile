import 'package:cyber_mobile/account/ui/pages/login_ctrl.dart';
import 'package:cyber_mobile/account/ui/pages/session_ctrl.dart';
import 'package:cyber_mobile/main.dart';
import 'package:cyber_mobile/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routers.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Theme.of(context).brightness == Brightness.dark) {
        //
        setState(() {
          isDark = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(sessionCtrlProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.03),
          child: Column(
            children: [
              Center(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.0),
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(30, 30, 31, 1),
                        borderRadius: BorderRadius.circular(63),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.person_2_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      state.userData.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                        overflow: TextOverflow.ellipsis, // si jamais ça déborde
                      ),
                    ),
                    Text(
                      state.userData.university,
                      style: TextStyle(
                        fontSize: 17,
                        //fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                        overflow: TextOverflow.ellipsis, // si jamais ça déborde
                      ),
                    ),
                    Text(
                      state.userData.phoneNumber,
                      style: TextStyle(
                        fontSize: 17,
                        //fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                        overflow: TextOverflow.ellipsis, // si jamais ça déborde
                      ),
                    ),
                    SizedBox(height: 24.0),
                    SizedBox(height: 24.0),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      //
                      Text(
                        'Paramètres',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Container(
                        decoration: BoxDecoration(
                          //color: const Color.fromRGBO(30, 30, 31, 1),
                          borderRadius: BorderRadius.circular(63),
                        ),
                        child: Icon(Icons.room_preferences_outlined),
                      ),
                      SizedBox(width: 12.0),
                      Text(
                        'Mode Sombre',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Spacer(),
                      CupertinoSwitch(
                        activeColor: Colors.red,
                        value: isDark,
                        onChanged: (val) {
                          setState(() {
                            isDark = val;
                            isDark
                                ? themeManager.setTheme(ThemeMode.dark)
                                : themeManager.setTheme(ThemeMode.light);
                          });
                        },
                      ),
                    ],
                  ),
                  //SizedBox(height: 16.0),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Container(
                        decoration: BoxDecoration(
                          //color: const Color.fromRGBO(30, 30, 31, 1),
                          borderRadius: BorderRadius.circular(63),
                        ),
                        child: Icon(Icons.monetization_on_outlined),
                      ),
                      SizedBox(width: 12.0),
                      Text(
                        'Methode de paiement',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward),
                    ],
                  ),*/
                  SizedBox(height: 16.0),
                    /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Container(
                        decoration: BoxDecoration(
                          //color: const Color.fromRGBO(30, 30, 31, 1),
                          borderRadius: BorderRadius.circular(63),
                        ),
                        child: Icon(Icons.help_outline),
                      ),
                      SizedBox(width: 12.0),
                      Text(
                        'Aide & Support',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                  SizedBox(height: 16.0),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Container(
                        decoration: BoxDecoration(
                          //color: const Color.fromRGBO(30, 30, 31, 1),
                          borderRadius: BorderRadius.circular(63),
                        ),
                        child: Icon(Icons.exit_to_app),
                      ),
                      SizedBox(width: 12.0),
                      Text(
                        'Deconnexion',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          var ctrl = ref.read(sessionCtrlProvider.notifier);
                          await ctrl.clearSession();

                          if (!context.mounted) return;

                          context.pushReplacementNamed(Urls.auth.name);
                        },
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  SizedBox(height: 48.0),
                  Container(
                    padding: EdgeInsets.all(16),
                    //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red.withOpacity(0.05),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Desactiver mon compte",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'En desactivant votre compte, vous ne pourrez plus accéder à vos données. Cette action est réversible.',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Ajouter confirmation ou logique de desactivation
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: Icon(Icons.power_settings_new),
                          label: Text("Désactiver"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
