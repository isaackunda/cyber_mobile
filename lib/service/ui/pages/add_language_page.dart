import 'package:cyber_mobile/service/business/models/language.dart';
import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddLanguagePage extends ConsumerStatefulWidget {
  const AddLanguagePage({super.key});

  @override
  AddLanguagePageState createState() => AddLanguagePageState();
}

class AddLanguagePageState extends ConsumerState<AddLanguagePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController languageNameCtrl = TextEditingController();

  @override
  void dispose() {
    languageNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvelle Langue"),
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
                'Ajouter une nouvelle langue',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
              ),
              SizedBox(height: 16.0),

              // Poste
              TextFormField(
                controller: languageNameCtrl,
                decoration: InputDecoration(
                  labelText: 'Langue',
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
                    return 'Veuillez entrer la langue';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Enregistrer
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final lang = Language(name: languageNameCtrl.text);

                      var ctrl = ref.read(cvCtrlProvider.notifier);
                      ctrl.saveLanguage(lang);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'nouvelle langue ajouter avec succées',
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
