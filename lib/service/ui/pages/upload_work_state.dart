import 'dart:io';
import 'dart:typed_data';
import 'package:pdfx/pdfx.dart';

class UploadWorkState {
  final bool pageSelect;
  final File? pdfFile;
  final File? coverPageFile;
  final PdfDocument? pdfDocument;
  final String filepath;
  final Uint8List? generatedPdf;
  final List<int> selectedPages;
  final bool isLoading;

  const UploadWorkState({
    this.pageSelect = false,
    this.pdfFile,
    this.coverPageFile,
    this.pdfDocument,
    this.filepath = '',
    this.generatedPdf,
    this.selectedPages = const [],
    this.isLoading = false,
  });

  UploadWorkState copyWith({
    bool? pageSelect,
    File? pdfFile,
    File? coverPageFile,
    PdfDocument? pdfDocument,
    String? filepath,
    Uint8List? generatedPdf,
    List<int>? selectedPages,
    bool? isLoading,
  }) {
    return UploadWorkState(
      pageSelect: pageSelect ?? this.pageSelect,
      pdfFile: pdfFile ?? this.pdfFile,
      coverPageFile: coverPageFile ?? this.coverPageFile,
      pdfDocument: pdfDocument ?? this.pdfDocument,
      filepath: filepath ?? this.filepath,
      generatedPdf: generatedPdf ?? this.generatedPdf,
      selectedPages: selectedPages ?? this.selectedPages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
