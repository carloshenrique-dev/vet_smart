import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vet_smart/results_model.dart';

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
    RegExp(r'Hemcias\s+(\d+\s*[,\.]?\s*\d*)\s*milhes'),
    RegExp(r'Hemoglobina\s+(\d+\s*[,\.]?\s*\d*)\s*gdL'),
    RegExp(r'Hematcrito\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
    RegExp(r'VCM\s+(\d+\s*[,\.]?\s*\d*)\s*fL'),
    RegExp(r'CHCM\s+(\d+\s*[,\.]?\s*\d*)\s*gdL'),
    RegExp(r'RDW\s+(\d+\s*[,\.]?\s*\d*)\s*%'), //n
    RegExp(r'PPT\s+(\d+\s*[,\.]?\s*\d*)\s*gdL'),
    RegExp(r'Mielcitos\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
    RegExp(r'Metamielcitos\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
    RegExp(r'Neutrfilos\s*bastonetes\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
    RegExp(r'Neutrfilos\s*segmentados\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
    RegExp(r'Linfcitos\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
    RegExp(r'Moncitos\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
    RegExp(r'Eosinfilos\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
    RegExp(r'Basfilos\s+(\d+\s*[,\.]?\s*\d*)\s*%'),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<List<ResultsModel>> _extractTextFromPdf() async {
    List<ResultsModel> results = [];

    // Carrega o PDF do arquivo
    PdfDocument pdf =
        PdfDocument(inputBytes: await _readDocumentData('vet_smart_pdf.pdf'));

    PdfTextExtractor extractor = PdfTextExtractor(pdf);

    // Cria uma lista para armazenar os resultados

    // Percorre as páginas do PDF
    for (int pageIndex = 0; pageIndex < pdf.pages.count; pageIndex++) {
      String text = extractor.extractText(startPageIndex: pageIndex);

      String textoLimpo = text.replaceAll(RegExp(r'[^\w\s,%]'), '');

      for (var i = 0; i < getValues.length; i++) {
        Iterable<RegExpMatch> matches = getValues[i].allMatches(textoLimpo);

        for (RegExpMatch match in matches) {
          if (match.groupCount >= 1) {
            String result = match.group(1)?.replaceAll(',', '.') ?? '';

            switch (i) {
              case 0:
                results.add(ResultsModel('Hemácias', double.parse(result)));
                break;

              case 1:
                results.add(ResultsModel('Hemoglobina', double.parse(result)));
                break;

              case 2:
                results.add(ResultsModel('Hematócrito', double.parse(result)));
                break;

              case 3:
                results.add(ResultsModel('VCM', double.parse(result)));
                break;

              case 4:
                results.add(ResultsModel('C.H.C.M', double.parse(result)));
                break;

              case 5:
                results.add(ResultsModel('R.D.W', double.parse(result)));
                break;

              case 6:
                results.add(ResultsModel('P.P.T', double.parse(result)));
                break;

              case 7:
                results.add(ResultsModel('Mielócitos', double.parse(result)));
                break;

              case 8:
                results
                    .add(ResultsModel('Metamielócitos', double.parse(result)));
                break;

              case 9:
                results.add(ResultsModel(
                    'Neutrófilos bastonetes', double.parse(result)));
                break;

              case 10:
                results.add(ResultsModel(
                    'Neutrófilos segmentados', double.parse(result)));
                break;

              case 11:
                results.add(ResultsModel('Linfócitos', double.parse(result)));
                break;

              case 12:
                results.add(ResultsModel('Monócitos', double.parse(result)));
                break;

              case 13:
                results.add(ResultsModel('Eosinófilos', double.parse(result)));
                break;

              case 14:
                results.add(ResultsModel('Basófilos', double.parse(result)));
                break;

              default:
                break;
            }
          }
        }
      }
    }
    return results;
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Vets Diagnóstico',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(
            Icons.pets,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 10,
                top: 20,
                right: 100,
              ),
              child: ListView(
                children: [
                  FutureBuilder(
                    future: _extractTextFromPdf(),
                    initialData: const [],
                    builder: (context, snapshot) => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) => Row(
                        children: [
                          Text(
                            '${snapshot.data?[index].nomeExame ?? ''}: ',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${snapshot.data?[index].valor}',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (_, __) => const Divider(
                        thickness: .5,
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        titlesData: const FlTitlesData(
                          rightTitles: AxisTitles(),
                          topTitles: AxisTitles(),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 4.5),
                              const FlSpot(1, 3),
                              const FlSpot(2, 3),
                              const FlSpot(3, 2),
                              const FlSpot(4, 1.3),
                              const FlSpot(5, 1.1),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.start,
                        titlesData: const FlTitlesData(
                          rightTitles: AxisTitles(),
                          topTitles: AxisTitles(),
                        ),
                        barGroups: [
                          BarChartGroupData(
                            x: 5,
                            barRods: [
                              BarChartRodData(toY: 4.5),
                              BarChartRodData(toY: 3),
                              BarChartRodData(toY: 3),
                              BarChartRodData(toY: 2),
                              BarChartRodData(toY: 1.3),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
