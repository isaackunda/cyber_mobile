import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdfx/pdfx.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFPrintScreen extends StatefulWidget {
  const PDFPrintScreen({super.key});

  @override
  State<PDFPrintScreen> createState() => _PDFPrintScreenState();
}

class _PDFPrintScreenState extends State<PDFPrintScreen> {
  File? _pdfFile;
  PdfDocument? _pdfDoc;
  String _selectedPagesInput = '';
  List<int> _selectedPages = [];
  int _pageCount = 0;
  final Map<int, PdfControllerPinch> _pageControllers = {};
  Uint8List? _generatedPdf;

  @override
  void dispose() {
    //_pdfDoc?.close();
    for (final controller in _pageControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      final doc = await PdfDocument.openFile(file.path);
      _pageControllers.clear();
      for (int i = 1; i <= doc.pagesCount; i++) {
        _pageControllers[i] = PdfControllerPinch(
          document: PdfDocument.openFile(file.path),
          initialPage: i,
        );
      }
      setState(() {
        _pdfFile = file;
        _pdfDoc = doc;
        _pageCount = doc.pagesCount;
        _selectedPages = [];
        _selectedPagesInput = '';
        _generatedPdf = null;
      });
    }
  }

  List<int> parsePageRanges(String input, int maxPage) {
    final Set<int> pages = {};
    final regex = RegExp(r'(\d+)(?:-(\d+))?');

    for (final match in regex.allMatches(input)) {
      int start = int.parse(match.group(1)!);
      int end = match.group(2) != null ? int.parse(match.group(2)!) : start;

      if (start > end) {
        final temp = start;
        start = end;
        end = temp;
      }

      for (int i = start; i <= end && i <= maxPage; i++) {
        pages.add(i);
      }
    }

    return pages.where((p) => p >= 1 && p <= maxPage).toList()..sort();
  }

  void _updateSelectedPages(String value) {
    setState(() {
      _selectedPagesInput = value;
      _selectedPages = parsePageRanges(value, _pageCount);
    });
  }

  void _selectQuick(String type) {
    switch (type) {
      case 'all':
        setState(
          () => _selectedPages = List.generate(_pageCount, (i) => i + 1),
        );
        break;
      case 'even':
        setState(
          () =>
              _selectedPages =
                  List.generate(
                    _pageCount,
                    (i) => i + 1,
                  ).where((p) => p % 2 == 0).toList(),
        );
        break;
      case 'odd':
        setState(
          () =>
              _selectedPages =
                  List.generate(
                    _pageCount,
                    (i) => i + 1,
                  ).where((p) => p % 2 != 0).toList(),
        );
        break;
      case 'reverse':
        setState(() => _selectedPages = _selectedPages.reversed.toList());
        break;
    }
  }

  Future<void> _createPdfFromSelectedPages({bool withCoverPage = false}) async {
    if (_pdfFile == null || _selectedPages.isEmpty) return;

    final doc = pw.Document();
    final originalPdf = await PdfDocument.openFile(_pdfFile!.path);

    // 🔹 Ajout d'une page de garde si activée
    if (withCoverPage) {
      doc.addPage(
        pw.Page(
          build:
              (context) => pw.Center(
                child: pw.Text(
                  'PAGE DE GARDE',
                  style: pw.TextStyle(
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
        ),
      );
    }

    // 🔹 Pages sélectionnées
    for (final pageNumber in _selectedPages) {
      final page = await originalPdf.getPage(pageNumber);
      final image = await page.render(width: page.width, height: page.height);
      final imageProvider = pw.MemoryImage(image!.bytes);

      doc.addPage(
        pw.Page(build: (context) => pw.Center(child: pw.Image(imageProvider))),
      );

      await page.close();
    }

    final bytes = await doc.save();
    setState(() => _generatedPdf = bytes);
  }

  @override
  Widget build(BuildContext context) {
    final isLoaded = _pdfFile != null && _pdfDoc != null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Impression PDF"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text("Importer un PDF depuis le téléphone"),
              onPressed: _pickPDF,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            if (isLoaded) ...[
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.picture_as_pdf, size: 40),
                title: Text(_pdfFile!.path.split('/').last),
                subtitle: Text(
                  "Pages : $_pageCount - Taille : ${(_pdfFile!.lengthSync() / 1024).toStringAsFixed(2)} Ko",
                ),
              ),
              Divider(height: 32),
              TextField(
                decoration: InputDecoration(
                  hintText: "1, 3-5, 7",
                  labelText: "Entrer les pages à imprimer",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _updateSelectedPages,
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: Text("Tout sélectionner"),
                    selected: false,
                    onSelected: (_) => _selectQuick('all'),
                  ),
                  ChoiceChip(
                    label: Text("Pages paires"),
                    selected: false,
                    onSelected: (_) => _selectQuick('even'),
                  ),
                  ChoiceChip(
                    label: Text("Pages impaires"),
                    selected: false,
                    onSelected: (_) => _selectQuick('odd'),
                  ),
                  ChoiceChip(
                    label: Text("Inverser la sélection"),
                    selected: false,
                    onSelected: (_) => _selectQuick('reverse'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text("Pages sélectionnées : ${_selectedPages.join(", ")}"),
              SizedBox(height: 24),
              Text(
                "Aperçu des pages à imprimer",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                height: 200,
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      _selectedPages
                          .where((page) => _pageControllers.containsKey(page))
                          .map((page) {
                            return Container(
                              width: 120,
                              margin: EdgeInsets.all(8),
                              child: PdfViewPinch(
                                controller: _pageControllers[page]!,
                              ),
                            );
                          })
                          .toList(),
                ),
              ),
              if (_generatedPdf != null) ...[
                SizedBox(height: 24),
                Text(
                  "Aperçu du nouveau PDF généré",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  height: 300,
                  margin: EdgeInsets.only(top: 8),
                  child: PdfPreview(build: (format) async => _generatedPdf!),
                ),
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar:
          isLoaded
              ? Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.picture_as_pdf),
                        label: Text("Créer le PDF"),
                        onPressed: _createPdfFromSelectedPages,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.print),
                        label: Text("Envoyer à l’imprimante"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          if (_pdfFile != null) {
                            await Printing.layoutPdf(
                              onLayout:
                                  (pdf.PdfPageFormat format) async =>
                                      _pdfFile!.readAsBytesSync(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
