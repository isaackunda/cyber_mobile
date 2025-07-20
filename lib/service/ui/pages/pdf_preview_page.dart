import 'dart:typed_data';
import 'package:cyber_mobile/service/ui/templates/classic_template.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatefulWidget {
  const PdfPreviewPage({super.key});

  @override
  PdfPreviewPageState createState() => PdfPreviewPageState();
}

class PdfPreviewPageState extends State<PdfPreviewPage> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _generatePdfFromWidget() async {
    // Capture widget en image
    final Uint8List? capturedImage = await _screenshotController.capture();

    if (capturedImage == null) return;

    // Créer PDF
    final pdf = pw.Document();
    final image = pw.MemoryImage(capturedImage);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        },
      ),
    );

    // Afficher ou imprimer
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CV PDF Generator")),
      floatingActionButton: FloatingActionButton(
        onPressed: _generatePdfFromWidget,
        child: Icon(Icons.picture_as_pdf),
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: ClassicTemplate(), // ← Remplace par ton widget CV réel
      ),
    );
  }
}
