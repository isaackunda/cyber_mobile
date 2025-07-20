import 'dart:io';

import 'package:cyber_mobile/service/business/models/cover_page_model.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_state.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as spdf;
import 'package:pdfx/pdfx.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'upload_work_ctrl.g.dart';

@Riverpod(keepAlive: true)
class UploadWorkCtrl extends _$UploadWorkCtrl {
  @override
  UploadWorkState build() {
    return UploadWorkState();
  }

  Future<void> setPdf(File file) async {
    state = state.copyWith(isLoading: true);
    if (kDebugMode) {
      print('setfile : $file');
    }
    final doc = await PdfDocument.openFile(file.path);
    state = state.copyWith(
      pdfDocument: doc,
      pdfFile: file,
      filepath: file.path,
    );

    if (kDebugMode) {
      print('after set ${state.pdfFile}');
      print('after set ${state.pdfDocument}');
    }
  }

  Future<void> updateSelectedPages(List<int> selectedPages) async {
    state = state.copyWith(selectedPages: selectedPages);
  }

  Future<Map<String, dynamic>> createPdfFromSelectedPages({
    bool withCoverPage = false,
    CoverPageModel? coverPageFile,
  }) async {
    if (kDebugMode) {
      print('start creating pdf ${state.pdfFile}');
      print('start creating via filepath ${state.filepath}');
      print('start creating pdf select pages ${state.selectedPages}');
    }
    //final coverPageFile = state.coverPageFile;
    if (state.pdfFile == null || state.selectedPages.isEmpty) {
      return {'status': 'KO', 'message': 'erreur pdfFile, pages selectioner'};
    }

    var pdfFile = state.pdfFile;
    final doc = pw.Document();

    if (withCoverPage) {
      final coverPdf = await PdfDocument.openFile(coverPageFile!.path);
      final coverPage = await coverPdf.getPage(1);

      final coverImage = await coverPage.render(
        width: coverPage.width,
        height: coverPage.height,
      );

      final coverImageProvider = pw.MemoryImage(coverImage!.bytes);
      doc.addPage(
        pw.Page(
          build: (context) => pw.Center(child: pw.Image(coverImageProvider)),
        ),
      );

      await coverPage.close();
      await coverPdf.close();
    }

    if (kDebugMode) {
      print('openFile : $pdfFile');
    }
    final originalPdf = await PdfDocument.openFile(state.filepath);
    if (kDebugMode) {
      print('File is open : $state.filepath');
    }

    for (final pageNumber in state.selectedPages) {
      final page = await originalPdf.getPage(pageNumber);
      final scale = 2.0;
      final image = await page.render(
        width: (page.width * scale),
        height: (page.height * scale),
        forPrint: true,
      );
      final imageProvider = pw.MemoryImage(image!.bytes);

      final width = imageProvider.width?.toDouble();
      final height = imageProvider.height?.toDouble();

      doc.addPage(
        pw.Page(
          pageFormat: spdf.PdfPageFormat(width!, height!),
          build: (context) => pw.Image(imageProvider),
        ),
      );

      await page.close();
    }

    final bytes = await doc.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/preview.pdf');

    await file.writeAsBytes(bytes);

    if (kDebugMode) {
      print('filepath : ${file.path}');
    }
    if (kDebugMode) {
      print('generatedPdf : $bytes');
    }

    state = state.copyWith(generatedPdf: bytes, filepath: file.path);

    if (await File(state.filepath).exists()) {
      //final document = await PdfDocument.openFile(state.filepath);
      if (kDebugMode) {
        print(' requete success pdf created');
      }
      return {'status': 'OK'};
    } else {
      if (kDebugMode) {
        print('⚠ Le fichier PDF n’existe pas à ${state.filepath}');
      }
      return {'status': 'KO'};
    }
  }
}
