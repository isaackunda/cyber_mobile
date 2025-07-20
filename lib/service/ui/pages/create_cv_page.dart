import 'package:cyber_mobile/service/business/models/logiciel.dart';
import 'package:cyber_mobile/service/business/models/user_perso_infos.dart';
import 'package:cyber_mobile/service/ui/pages/add_education_page.dart';
import 'package:cyber_mobile/service/ui/pages/add_formation_page.dart';
import 'package:cyber_mobile/service/ui/pages/add_interest_page.dart';
import 'package:cyber_mobile/service/ui/pages/add_language_page.dart';
import 'package:cyber_mobile/service/ui/pages/add_reference_page.dart';
import 'package:cyber_mobile/service/ui/pages/add_skill_page.dart';
import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:cyber_mobile/service/ui/pages/payment_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../business/models/print_info.dart';
import 'add_experience_page.dart';

class CreateCvPage extends ConsumerStatefulWidget {
  const CreateCvPage({super.key});

  @override
  ConsumerState<CreateCvPage> createState() => _CreateCvPageState();
}

class _CreateCvPageState extends ConsumerState<CreateCvPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController(text: '');
  final emailCtrl = TextEditingController(text: '');
  final phoneNumberCtrl = TextEditingController(text: '');
  final placeOfBirthCtrl = TextEditingController(text: '');
  final nationalityCtrl = TextEditingController(text: '');

  final PageController _controller = PageController();
  int _currentPage = 0;
  String? _selectedSexe; // Valeur sélectionnée (null au début)
  String? selectedPayment; // "airtel" ou "mpesa"
  final TextEditingController dateController = TextEditingController();
  String? selectedMode;

  // Données du CV
  final cvData = {
    'name': '',
    'email': '',
    'experience': '',
    'education': '',
    'skills': '',
  };

  final List<String> steps = [
    "Infos",
    "Expérience",
    "Educations",
    "Formation",
    "Compétences",
    "Langues",
    "Interets",
    "References",
    "Aperçu",
  ];

  void _selectPayment(String payment) {
    setState(() {
      selectedPayment = payment;
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(cvCtrlProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Création de CV")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              //SizedBox(height: 12.0),
              _buildProgressSteps(),
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildPersonalInfoPage(context),
                    _buildExperiencePage(),
                    _buildEducationPage(),
                    _buildFormationPage(),
                    _buildSkillsPage(context),
                    _buildLanguagesPage(context),
                    _buildInterestsPage(context),
                    _buildReferencePage(),
                    _buildPreviewPage(),
                    //PreviewPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Bouton Précédent
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      _currentPage == 0
                          ? null
                          : () {
                            setState(() {
                              _currentPage--;
                            });
                            _controller.animateToPage(
                              _currentPage,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                  child: Text(
                    "Précédent",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Bouton Suivant ou Terminer
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < 8) {
                      if (_currentPage == 0) {
                        //
                        if (state.userPersoInfos.name == 'N/A') {
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ajoutez vos informations personnelles',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        }
                        setState(() {
                          _currentPage++;
                        });
                        _controller.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else if (_currentPage == 1) {
                        //
                        if (state.experiences.isEmpty) {
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ajoutez aux moins une experience',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        }

                        setState(() {
                          _currentPage++;
                        });
                        _controller.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else if (_currentPage == 2) {
                        //
                        if (state.etudes.isEmpty) {
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ajoutez aux moins une etudes',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        }
                        setState(() {
                          _currentPage++;
                        });
                        _controller.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else if (_currentPage == 4) {
                        //
                        if (state.skills.isEmpty) {
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ajoutez aux moins une competences',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        }

                        setState(() {
                          _currentPage++;
                        });
                        _controller.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else if (_currentPage == 5) {
                        //
                        if (state.languages.isEmpty) {
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ajoutez aux moins une langue',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );

                          return;
                        }

                        setState(() {
                          _currentPage++;
                        });
                        _controller.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        setState(() {
                          _currentPage++;
                        });
                        _controller.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    } else {
                      if (kDebugMode) {
                        print("CV final : $cvData");
                      }
                    }
                  },
                  child: Text(
                    _currentPage == 8 ? "Terminer" : "Suivant",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSteps() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            steps.asMap().entries.map((entry) {
              int index = entry.key;
              //String label = entry.value;

              bool isActive = index == _currentPage;
              bool isCompleted = index < _currentPage;

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isActive
                                ? Colors.black
                                : isCompleted
                                ? Colors.red
                                : Colors.grey[300],
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        size: 16,
                        color: isCompleted ? Colors.white : Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildPersonalInfoPage(BuildContext context) {
    var state = ref.watch(cvCtrlProvider);

    InputDecoration inputDecoration({
      required String label,
      required IconData icon,
    }) {
      return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Informations personnelles',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Champ Nom complet
            TextFormField(
              decoration: inputDecoration(
                label: 'Nom Complet',
                icon: Icons.person_2_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom complet';
                }
                return null;
              },
              controller: nameCtrl,
            ),
            const SizedBox(height: 16),

            // Sexe
            DropdownButtonFormField<String>(
              value: _selectedSexe,
              decoration: inputDecoration(
                label: 'Sexe',
                icon: Icons.wc_outlined,
              ),
              hint: const Text("Sexe", style: TextStyle(fontFamily: 'Poppins')),
              items:
                  ['Homme', 'Femme'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                    );
                  }).toList(),
              onChanged: (newValue) {
                _selectedSexe = newValue!;
              },
              validator:
                  (value) =>
                      value == null ? 'Veuillez sélectionner votre sexe' : null,
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              decoration: inputDecoration(
                label: 'Adresse email',
                icon: Icons.mail_outline,
              ),
              controller: emailCtrl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre adresse email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Adresse email invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Téléphone
            IntlPhoneField(
              decoration: inputDecoration(
                label: 'Numéro de téléphone',
                icon: Icons.phone,
              ),
              controller: phoneNumberCtrl,
              initialCountryCode: 'CD',
              onChanged: (phone) {
                if (kDebugMode) {
                  print('Numéro : ${phone.completeNumber}');
                }
              },
              validator: (phone) {
                if (phone == null || phone.number.isEmpty) {
                  return 'Veuillez entrer votre numéro';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date de naissance
            TextFormField(
              controller: dateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre date de naissance';
                }
                return null;
              },
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date de naissance',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () {
                picker.DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(1900),
                  maxTime: DateTime.now(),
                  locale: picker.LocaleType.fr,
                  theme: picker.DatePickerTheme(
                    backgroundColor: Colors.black,
                    itemStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                    ),
                    doneStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    cancelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    //headerColor: Colors.deepPurpleAccent,
                    containerHeight: 210.0,
                  ),
                  onConfirm: (date) {
                    dateController.text = DateFormat('dd/MM/yyyy').format(date);
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Lieu de naissance
            TextFormField(
              decoration: inputDecoration(
                label: 'Lieu de naissance',
                icon: Icons.map_outlined,
              ),
              controller: placeOfBirthCtrl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre lieu de naissance';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Nationalité
            TextFormField(
              decoration: inputDecoration(
                label: 'Nationalité',
                icon: Icons.flag,
              ),
              controller: nationalityCtrl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nationalité';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            if (state.userPersoInfos.name != 'N/A')
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.userPersoInfos.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              state.userPersoInfos.email,
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          //
                          var ctrl = ref.read(cvCtrlProvider.notifier);
                          ctrl.deleteUserPersonalInfo();
                        },
                        child: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  //
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Remplissez le formaulaire !',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );

                  return;
                }

                var userData = UserPersoInfos(
                  name: nameCtrl.text,
                  sexe: _selectedSexe.toString(),
                  email: emailCtrl.text,
                  phoneNumber: phoneNumberCtrl.text,
                  dateOfBirth: dateController.text,
                  placeOfBirth: placeOfBirthCtrl.text,
                  nationality: nationalityCtrl.text,
                );

                var ctrl = ref.read(cvCtrlProvider.notifier);
                ctrl.saveUserPersonalInfo(userData);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Formulaire valide !')),
                );

                if (kDebugMode) {
                  print('object ${state.userPersoInfos.name} ');
                }
              },
              child: Text(
                state.userPersoInfos.name == 'N/A' ? "Enregistrer" : "Modifier",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperiencePage() {
    var state = ref.watch(cvCtrlProvider);

    return ListView(
      //padding: const EdgeInsets.all(16),
      children: [
        // Titre + bouton de fermeture
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Expériences Professionnelles',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),

        SizedBox(height: 24),

        // Liste des expériences
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              state
                  .experiences
                  .length, // à remplacer par la longueur réelle d'une liste
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.experiences[index].titre,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            state.experiences[index].entreprise,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        var ctrl = ref.read(cvCtrlProvider.notifier);
                        ctrl.deleteExp(index);
                      },
                      child: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: 16),

        // Bouton ajouter
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () async {
                final newExperience = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddExperiencePage()),
                );

                if (newExperience != null) {
                  // Ajouter à ta liste d'expériences ici
                  if (kDebugMode) {
                    print(newExperience);
                  }
                }
                // Ajouter une nouvelle expérience
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEducationPage() {
    var state = ref.watch(cvCtrlProvider);
    return ListView(
      //padding: const EdgeInsets.all(16),
      children: [
        // Titre + bouton de fermeture
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Etudes',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),

        SizedBox(height: 24),

        // Liste des expériences
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              state
                  .etudes
                  .length, // à remplacer par la longueur réelle d'une liste
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.etudes[index].etablissement,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            state.etudes[index].titre,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print('object $index');
                        }
                        var ctrl = ref.read(cvCtrlProvider.notifier);

                        ctrl.deleteEtude(index);
                      },
                      child: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: 16),

        // Bouton ajouter
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () async {
                final newExperience = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddEducationPage()),
                );

                if (newExperience != null) {
                  // Ajouter à ta liste d'expériences ici
                  if (kDebugMode) {
                    print(newExperience);
                  }
                }
                // Ajouter une nouvelle expérience
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormationPage() {
    var state = ref.watch(cvCtrlProvider);

    return ListView(
      //padding: const EdgeInsets.all(16),
      children: [
        // Titre + bouton de fermeture
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Formations',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),

        SizedBox(height: 24),

        // Liste des expériences
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              state
                  .formations
                  .length, // à remplacer par la longueur réelle d'une liste
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.formations[index].etablissement,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            state.formations[index].certificat,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        var ctrl = ref.read(cvCtrlProvider.notifier);
                        ctrl.deleteFormation(index);
                      },
                      child: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: 16),

        // Bouton ajouter
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () async {
                final newExperience = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddFormationPage()),
                );

                if (newExperience != null) {
                  // Ajouter à ta liste d'expériences ici
                  if (kDebugMode) {
                    print(newExperience);
                  }
                }
                // Ajouter une nouvelle expérience
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsPage(BuildContext context) {
    var state = ref.watch(cvCtrlProvider);

    return ListView(
      //padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Compétences',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        /// Voici le bloc de compétences en 2 par ligne avec largeur fixe
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              state.skills.map((skill) {
                return GestureDetector(
                  onLongPress: () {
                    var ctrl = ref.read(cvCtrlProvider.notifier);
                    //ctrl.deleteSkill();
                  },
                  child: Container(
                    width: 80,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        skill.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),

        SizedBox(height: 24),

        /// Bouton pour ajouter une compétence
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddSkillPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguagesPage(BuildContext context) {
    var state = ref.watch(cvCtrlProvider);

    return ListView(
      //padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Langues',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        /// Voici le bloc de compétences en 2 par ligne avec largeur fixe
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              state.languages.map((language) {
                return Container(
                  width: 80,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      language.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
        ),

        SizedBox(height: 24),

        /// Bouton pour ajouter une compétence
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddLanguagePage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestsPage(BuildContext context) {
    var state = ref.watch(cvCtrlProvider);

    return ListView(
      //padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Interet',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        /// Voici le bloc de compétences en 2 par ligne avec largeur fixe
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              state.logiciels.map((interet) {
                return Container(
                  width: 80,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      interet.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
        ),

        SizedBox(height: 24),

        /// Bouton pour ajouter une compétence
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () async {
                if (kDebugMode) {
                  print('object');
                }

                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddInterestPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReferencePage() {
    var state = ref.watch(cvCtrlProvider);

    return ListView(
      //padding: const EdgeInsets.all(16),
      children: [
        // Titre + bouton de fermeture
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'References',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),

        SizedBox(height: 24),

        // Liste des expériences
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              state
                  .references
                  .length, // à remplacer par la longueur réelle d'une liste
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.references[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            state.references[index].phoneNumber,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        var ctrl = ref.read(cvCtrlProvider.notifier);
                        ctrl.deleteReference(index);
                      },
                      child: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: 16),

        // Bouton ajouter
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () async {
                final newExperience = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddReferencePage()),
                );

                if (newExperience != null) {
                  // Ajouter à ta liste d'expériences ici
                  if (kDebugMode) {
                    print(newExperience);
                  }
                }
                // Ajouter une nouvelle expérience
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choisissez la couleur du CV",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Option Noir et Blanc
          ListTile(
            leading: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF5F2879),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            title: const Text("#5F2879"),
            trailing:
                selectedMode == '#5F2879'
                    ? const Icon(Icons.check_circle)
                    : null,
            onTap: () => setState(() => selectedMode = '#5F2879'),
          ),

          // Option Couleur
          ListTile(
            leading: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF00418D),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            title: const Text("#00418D"),
            trailing:
                selectedMode == '#00418D'
                    ? const Icon(Icons.check_circle)
                    : null,
            onTap: () => setState(() => selectedMode = '#00418D'),
          ),

          // Option Couleur
          ListTile(
            leading: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF00C2DE),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            title: const Text("#00C2DE"),
            trailing:
                selectedMode == '#00C2DE'
                    ? const Icon(Icons.check_circle)
                    : null,
            onTap: () => setState(() => selectedMode = '#00C2DE'),
          ),

          // Option Couleur
          ListTile(
            leading: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF00BA71),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            title: const Text("#00BA71"),
            trailing:
                selectedMode == '#00BA71'
                    ? const Icon(Icons.check_circle)
                    : null,
            onTap: () => setState(() => selectedMode = '#00BA71'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
