import 'package:cyber_mobile/service/business/models/experience.dart';
import 'package:cyber_mobile/service/business/models/skill.dart';
import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSkillPage extends ConsumerStatefulWidget {
  const AddSkillPage({super.key});

  @override
  AddExperiencePageState createState() => AddExperiencePageState();
}

class AddExperiencePageState extends ConsumerState<AddSkillPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController skillNameCtrl = TextEditingController();

  @override
  void dispose() {
    skillNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvelle Competences"),
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
                'Ajouter une nouvelle competence',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
              ),
              SizedBox(height: 16.0),

              // Poste
              TextFormField(
                controller: skillNameCtrl,
                decoration: InputDecoration(
                  labelText: 'Competence',
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
                    return 'Veuillez entrer la competence';
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
                      final skil = Skill(name: skillNameCtrl.text);

                      var ctrl = ref.read(cvCtrlProvider.notifier);
                      ctrl.saveSkill(skil);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'nouvelle competence ajouter avec succées',
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
