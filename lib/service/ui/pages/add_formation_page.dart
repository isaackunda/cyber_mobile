import 'package:cyber_mobile/service/business/models/etude.dart';
import 'package:cyber_mobile/service/business/models/formation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'cv_ctrl.dart';

class AddFormationPage extends ConsumerStatefulWidget {
  const AddFormationPage({super.key});

  @override
  AddExperiencePageState createState() => AddExperiencePageState();
}

class AddExperiencePageState extends ConsumerState<AddFormationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController certificatCtrl = TextEditingController(text: '');
  final TextEditingController etablissementCtrl = TextEditingController(
    text: '',
  );
  final TextEditingController specialiteCtrl = TextEditingController(text: '');
  final TextEditingController dateDebutCtrl = TextEditingController();
  final TextEditingController dateFinCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  bool toujoursEnFormation = false;
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    certificatCtrl.dispose();
    etablissementCtrl.dispose();
    dateDebutCtrl.dispose();
    dateFinCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context, TextEditingController controller) {
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
        containerHeight: 210.0,
      ),
      onConfirm: (date) {
        controller.text = DateFormat('dd/MM/yyyy').format(date);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formation"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 32.0),
              // Poste
              // Champ Prénom
              Text(
                'Ajouter des formations',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: certificatCtrl,
                decoration: InputDecoration(
                  labelText: 'Certification',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.work_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre certificat';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: etablissementCtrl,
                decoration: InputDecoration(
                  labelText: 'Etablissement',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.home_work_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'etablissement';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Entreprise + Date de début
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: dateDebutCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date de début',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer la date de début';
                        }
                        return null;
                      },
                      onTap: () => _selectDate(context, dateDebutCtrl),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: // Date de fin
                        TextFormField(
                      controller: dateFinCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date de fin',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (!toujoursEnFormation &&
                            (value == null || value.isEmpty)) {
                          return 'Veuillez entrer la date de fin';
                        }
                        return null;
                      },
                      onTap: () => _selectDate(context, dateFinCtrl),
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                title: Text(
                  "J'occupe suis toujours en formation",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                value: toujoursEnFormation,
                onChanged: (bool? value) {
                  setState(() {
                    toujoursEnFormation = value ?? false;
                    if (toujoursEnFormation) {
                      dateFinCtrl
                          .clear(); // Efface la date s’il est toujours en poste
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              // Enregistrer
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final formation = Formation(
                        certificat: certificatCtrl.text,
                        etablissement: etablissementCtrl.text,
                        dateDebut: dateDebutCtrl.text,
                        dateFin:
                            toujoursEnFormation ? 'En cours' : dateFinCtrl.text,
                        enFormation: toujoursEnFormation,
                      );

                      var ctrl = ref.read(cvCtrlProvider.notifier);
                      ctrl.saveFormation(formation);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'nouvelle formation ajouter avec succées',
                            style: TextStyle(
                              //color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    "Enregistrer",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
