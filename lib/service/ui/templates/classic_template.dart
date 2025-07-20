import 'package:cyber_mobile/service/ui/pages/cv_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart' as spdf;
import 'package:pdfx/pdfx.dart';
import 'package:pdf/widgets.dart' as pw;

class ClassicTemplate extends ConsumerStatefulWidget {
  const ClassicTemplate({super.key});

  @override
  ConsumerState<ClassicTemplate> createState() => ClassicTemplateState();
}

class ClassicTemplateState extends ConsumerState<ClassicTemplate> {
  GlobalKey previewContainer = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(cvCtrlProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(color: Colors.red),
            width: 595.28,
            height: 841.89,
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: 250,
                      height: double.infinity,
                      decoration: BoxDecoration(color: Colors.black),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 300.0),
                            Text(
                              'COMPETENCES',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.skills.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 5,
                                      color: Colors.white,
                                    ),
                                    Text(' ${state.skills[index].name}'),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 32.0),

                            Text(
                              'LANGUES',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.languages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 5,
                                      color: Colors.white,
                                    ),
                                    Text(' ${state.languages[index].name}'),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 32.0),

                            Text(
                              'LOGICIELS',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.logiciels.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 5,
                                      color: Colors.white,
                                    ),
                                    Text(' ${state.logiciels[index].name} '),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 32.0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 345.27,
                      height: double.infinity,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 300.0),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(color: Colors.grey),
                              child: Text(
                                'PROFIL',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              state.userPersoInfos.profil,
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 32.0),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(color: Colors.grey),
                              child: Text(
                                'EXPERIENCES PROFESSIONNELLES',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.experiences.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.justify,
                                      maxLines: 3,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '• ${state.experiences[index].dateDebut} - ${state.experiences[index].dateFin} : ${state.experiences[index].titre}, ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                state
                                                    .experiences[index]
                                                    .entreprise,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12.0),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 32.0),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(color: Colors.grey),
                              child: Text(
                                'ETUDES FAITES',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.etudes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.justify,
                                      //maxLines: 3,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '• ${state.etudes[index].dateDebut} - ${state.etudes[index].dateFin} : ${state.etudes[index].titre}, ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (state.etudes[index].specialite !=
                                              'N/A')
                                            TextSpan(
                                              text:
                                                  '${state.etudes[index].specialite}, ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          TextSpan(
                                            text:
                                                state
                                                    .etudes[index]
                                                    .etablissement,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12.0),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      SizedBox(height: 24.0),
                      Container(
                        width: 550,
                        height: 240,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.white, width: 10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 24.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' ${state.userPersoInfos.name}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' Sexe : ${state.userPersoInfos.sexe}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' Date & Lieu de naissance : ${state.userPersoInfos.placeOfBirth}, le ${state.userPersoInfos.dateOfBirth}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' Nationalité : ${state.userPersoInfos.nationality}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' Etat Civil : ${state.userPersoInfos.maritalStatus}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' Mail : ${state.userPersoInfos.email}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' Télephone : ${state.userPersoInfos.phoneNumber}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        ' Adresse : ${state.userPersoInfos.address}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                              ),
                              //Image.asset(image: image),
                            ],
                          ),
                        ),
                      ),
                    ],
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
