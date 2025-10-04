import 'package:cyber_mobile/account/business/models/register_request.dart';
import 'package:cyber_mobile/account/ui/pages/register_account_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../routers.dart';

class RegisterAccountPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const RegisterAccountPage({super.key, required this.onNext});

  @override
  ConsumerState<RegisterAccountPage> createState() =>
      _RegisterAccountPageState();
}

class _RegisterAccountPageState extends ConsumerState<RegisterAccountPage> {
  var nameCtrl = TextEditingController(text: '');
  var firstNameCtrl = TextEditingController(text: '');
  //var lastNameCtrl = TextEditingController(text: '');
  //var phoneCtrl = TextEditingController(text: '');
  var phoneCtrl = '';
  var emailCtrl = TextEditingController(text: '');
  var passwordCtrl = TextEditingController(text: '');
  var confirmPasswordCtrl = TextEditingController(text: '');
  var universityCtrl = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  String? selectedUniversity;

  // 1. Variable pour contrôler la visibilité du mot de passe

  @override
  void dispose() {
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(registerAccountCtrlProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Création de ton compte',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Remplis tes informations pour finaliser ton inscription.',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                ),
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nom Complet',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white, // Couleur de la bordure
                              width: 1.5, // Épaisseur
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.person, // Icône utilisateur
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primary, // Couleur de l'icône
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      /*TextFormField(
                        controller: firstNameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white, // Couleur de la bordure
                              width: 1.5, // Épaisseur
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.person_2_outlined, // Icône utilisateur
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primary, // Couleur de l'icône
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          return null;
                        },
                      ),*/
                      //const SizedBox(height: 16),

                      IntlPhoneField(
                        //controller: phoneCtrl,
                        decoration: InputDecoration(
                          labelText: 'Numéro de téléphone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white, // Couleur de la bordure
                              width: 1.5, // Épaisseur
                            ),
                          ),
                        ),
                        initialCountryCode: 'CD', // 🇨🇩 Code pays RDC
                        onChanged: (phone) {
                          if (kDebugMode) {
                            print('Numéro : ${phone.completeNumber}');
                          }
                          setState(() {
                            phoneCtrl = phone.completeNumber;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      /*TextFormField(
                        //controller: emailCtrl,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: '${state.email}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white, // Couleur de la bordure
                              width: 1.5, // Épaisseur
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.email, // Icône utilisateur
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primary, // Couleur de l'icône
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          return null;
                        },
                      ),*/
                      //const SizedBox(height: 16),

                      // Déclarez votre variable pour stocker l'université sélectionnée
                      // Assurez-vous qu'elle est bien déclarée dans votre State (ex: _MonEcranState)
                      // String? selectedUniversity; // Peut être null au début
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Université",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(
                            Icons.school, // Icône utilisateur
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primary, // Couleur de l'icône
                          ),
                        ),
                        isExpanded: true,
                        // Le 'value' du DropdownButton doit correspondre au type des 'value' des DropdownMenuItem
                        // Ici, il doit être une String (le nom de l'université)
                        value:
                            selectedUniversity, // selectedUniversity doit être de type String?

                        items:
                            state.universities.map((universityObject) {
                              // universityObject est de type University (avec .name et .city)
                              return DropdownMenuItem<String>(
                                // La 'value' du DropdownMenuItem sera le nom de l'université
                                value: universityObject.name,
                                // Le 'child' affichera le nom de l'université
                                child: Text(universityObject.name),
                              );
                            }).toList(),

                        onChanged: (String? newValue) {
                          // newValue est maintenant de type String? (le nom)
                          setState(() {
                            selectedUniversity =
                                newValue; // On stocke le nom de l'université
                            // Si vous avez besoin de l'objet University complet, voir l'approche 2
                          });
                        },
                        // Optionnel: Ajouter un validator si l'université est obligatoire
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner une université';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (kDebugMode) {
                          print('object : $phoneCtrl');
                        }
                        var data = RegisterRequest(
                          email: state.email.toString(),
                          password: passwordCtrl.text,
                          name: nameCtrl.text,
                          firstname: firstNameCtrl.text,
                          //lastname: lastNameCtrl.text,
                          phoneNumber: phoneCtrl,
                          university: selectedUniversity.toString(),
                        );

                        var ctrl = ref.watch(
                          registerAccountCtrlProvider.notifier,
                        );
                        var result = await ctrl.registerAccount(data);

                        if (!context.mounted) return;

                        String messageToShow =
                            result['message'] ?? 'Opération terminée.';
                        bool isSuccess = result['status'] == 'OK';

                        if (isSuccess) {
                          emailCtrl.clear();
                          passwordCtrl.clear();
                          confirmPasswordCtrl.clear();
                          nameCtrl.clear();
                          firstNameCtrl.clear();
                          //lastNameCtrl.clear();
                          phoneCtrl = '';
                          selectedUniversity = '';

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                messageToShow,
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                          );
                          context.pushReplacementNamed(Urls.auth.name);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                messageToShow,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        //widget.onNext();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Créer mon compte",
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
