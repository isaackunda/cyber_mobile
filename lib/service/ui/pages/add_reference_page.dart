import 'package:cyber_mobile/service/business/models/experience.dart';
import 'package:cyber_mobile/service/business/models/reference.dart';
import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddReferencePage extends ConsumerStatefulWidget {
  const AddReferencePage({super.key});

  @override
  AddReferencePageState createState() => AddReferencePageState();
}

class AddReferencePageState extends ConsumerState<AddReferencePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController titreCtrl = TextEditingController();
  final TextEditingController phoneNumberCtrl = TextEditingController();
  final TextEditingController linkCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    titreCtrl.dispose();
    phoneNumberCtrl.dispose();
    linkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvelle Ref"),
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
                'Ajouter une nouvelle reference',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
              ),
              SizedBox(height: 16.0),

              // Poste
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nom du referend',
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
                controller: titreCtrl,
                decoration: InputDecoration(
                  labelText: 'Poste ocuppé (falcutatif)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(
                    Icons.home_work_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // Téléphone
              IntlPhoneField(
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
              SizedBox(height: 16.0),

              TextFormField(
                controller: linkCtrl,
                decoration: InputDecoration(
                  labelText: 'Lien (falcutatif)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(
                    Icons.home_work_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                      final refe = Reference(
                        name: nameCtrl.text,
                        titre: titreCtrl.text ?? '',
                        phoneNumber: phoneNumberCtrl.text
                      );

                      var ctrl = ref.read(cvCtrlProvider.notifier);
                      ctrl.saveReference(refe);

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
