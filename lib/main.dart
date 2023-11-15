import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<RegExp> getValues = [
    RegExp(r'Hemoglobina\s+(\d+\s*[,\.]?\s*\d*)\s*gdL'),
    RegExp(r'Hemcias\s+(\d+\s*[,\.]?\s*\d*)\s*milhes'),
    RegExp(r'Hematcrito\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'VCM\s+(\d+\s*[,\.]?\s*\d*)\s*fL'),
    RegExp(r'CHCM\s+(\d+\s*[,\.]?\s*\d*)\s*gdL'),
    RegExp(r'RDW\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'PPT\s+(\d+\s*[,\.]?\s*\d*)\s*gdL'),
    RegExp(r'Mielcitos\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'Metamielcitos\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'Neutrfilos bastonetes\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'Neutrfilos segmentados\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'Linfcitos\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'Moncitos\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'Eosinfilos\s+(\d+\s*[,\.]?\s*\d*)\s*'),
    RegExp(r'Basfilos\s+(\d+\s*[,\.]?\s*\d*)\s*'),
  ];

  @override
  void initState() {
    super.initState();
    _extractTextFromPdf();
  }

  Future<List<String>> _extractTextFromPdf() async {
    // Carrega o PDF do arquivo
    PdfDocument pdf =
        PdfDocument(inputBytes: await _readDocumentData('vet_smart_pdf.pdf'));

    PdfTextExtractor extractor = PdfTextExtractor(pdf);

    // Cria uma lista para armazenar os resultados
    List<String> results = [];

    // Percorre as páginas do PDF
    for (int i = 0; i < pdf.pages.count; i++) {
      // Obtém o texto da página
      String text = extractor.extractText(startPageIndex: i);

      String textoLimpo = text.replaceAll(RegExp(r'[^\w\s,]'), '');

      for (var i = 0; i < getValues.length; i++) {
        Iterable<RegExpMatch> matches = getValues[i].allMatches(textoLimpo);

        for (RegExpMatch match in matches) {
          if (match.groupCount >= 1) {
            String valorHemoglobina =
                match.group(1)?.replaceAll(',', '.') ?? '';
            print('${getValues[i]}: $valorHemoglobina');
          }
        }
      }
    }

    // Retorna a lista de resultados
    return results;
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Extrair texto de PDF'),
        ),
      ),
    );
  }
}
