import 'package:cyber_mobile/service/business/models/experience.dart';
import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddExperiencePage extends ConsumerStatefulWidget {
  const AddExperiencePage({super.key});

  @override
  AddExperiencePageState createState() => AddExperiencePageState();
}

class AddExperiencePageState extends ConsumerState<AddExperiencePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController postCtrl = TextEditingController();
  final TextEditingController companyCtrl = TextEditingController();
  final TextEditingController dateDebutCtrl = TextEditingController();
  final TextEditingController dateFinCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  bool toujoursEnPoste = false;

  @override
  void dispose() {
    postCtrl.dispose();
    companyCtrl.dispose();
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
        title: Text("Nouvelle expérience"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 32.0),
              Text(
                'Ajouter une nouvelle expérience',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
              ),
              SizedBox(height: 16.0),

              // Poste
              TextFormField(
                controller: postCtrl,
                decoration: InputDecoration(
                  labelText: 'Poste occupé',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(
                    Icons.work_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le poste occupé';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: companyCtrl,
                decoration: InputDecoration(
                  labelText: 'Entreprise',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(
                    Icons.home_work_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'entreprise';
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
                        if (!toujoursEnPoste &&
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
                  "J'occupe toujours ce poste",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                value: toujoursEnPoste,
                onChanged: (bool? value) {
                  setState(() {
                    toujoursEnPoste = value ?? false;
                    if (toujoursEnPoste) {
                      dateFinCtrl
                          .clear(); // Efface la date s’il est toujours en poste
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Résumé de votre poste (facultatif)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(height: 16.0),

              //SizedBox(height: 24.0),

              // Enregistrer
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final exp = Experience(
                        titre: postCtrl.text,
                        entreprise: companyCtrl.text,
                        dateDebut: dateDebutCtrl.text,
                        dateFin:
                            toujoursEnPoste ? 'En cours' : dateFinCtrl.text,
                        description: descriptionCtrl.text,
                        enPoste: toujoursEnPoste,
                      );

                      var ctrl = ref.read(cvCtrlProvider.notifier);
                      ctrl.saveExperience(exp);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'nouvelle exp ajouter avec succées',
                            style: TextStyle(
                              //color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      );

                      //Navigator.pop(context);
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
