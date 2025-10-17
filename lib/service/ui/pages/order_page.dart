import 'dart:io';

import 'package:cyber_mobile/account/ui/pages/login_ctrl.dart';
import 'package:cyber_mobile/routers.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';

import 'order_ctrl.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<OrderPage> {
  PdfController? _previewController;

  @override
  void initState() {
    super.initState();
    // Vous pouvez initialiser des valeurs par défaut si nécessaire

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreviewPdf();
    });
  }

  Future<void> _loadPreviewPdf() async {
    // Libère l'ancien controller s'il existe déjà
    var state = ref.watch(uploadWorkCtrlProvider);
    var orderState = ref.watch(orderCtrlProvider);
    if (kDebugMode) {
      print('object ${orderState.order.link}');
    }

    try {
      _previewController?.dispose();
    } catch (_) {}

    if (await File(orderState.order.link).exists()) {
      setState(() {
        _previewController = PdfController(
          document: PdfDocument.openFile(orderState.order.link),
        );
      });
      // ok
    } else {
      if (kDebugMode) {
        print('⚠️ Le fichier PDF n’existe pas à ${orderState.order.link}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(loginCtrlProvider);
    var orderState = ref.watch(orderCtrlProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Commande Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.03),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Commande #${orderState.order.ref}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      overflow:
                      TextOverflow.ellipsis, // si jamais ça déborde
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Text(
                        'Status',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Text(
                        orderState.order.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Text(
                        'Pages',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Text(
                        orderState.order.nbreDePages,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Text(
                        '\$ ${orderState.order.total}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    children: [
                      //
                      Text(
                        'Pages',
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
                  SizedBox(height: 32.0),
                  if (_previewController == null)
                    const Center(child: CircularProgressIndicator())
                  else
                    Container(
                      height: 300,
                      //width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[200],
                      ),
                      child: PdfView(
                        physics: BouncingScrollPhysics(),
                        controller: _previewController!,
                        builders: PdfViewBuilders<DefaultBuilderOptions>(
                          options: const DefaultBuilderOptions(),
                          pageLoaderBuilder:
                              (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                        ),
                        scrollDirection: Axis.vertical,
                      ),
                    ),

                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      _previewController == null
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                            height: 300,
                            //width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[200],
                            ),
                            child: PdfView(
                              physics: BouncingScrollPhysics(),
                              controller: _previewController!,
                              builders: PdfViewBuilders<DefaultBuilderOptions>(
                                options: const DefaultBuilderOptions(),
                                pageLoaderBuilder:
                                    (_) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              ),
                              scrollDirection: Axis.vertical,
                            ),
                          ),
                      /*Text(
                        'En attente',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),*/
                      Spacer(),
                    ],
                  ),*/
                  SizedBox(height: 16.0,),

                  if (orderState.order.status == 'Paiement en attente')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          //
                          context.pushNamed(Urls.printPaymentService.name);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Continuer vers le paiement',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
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
