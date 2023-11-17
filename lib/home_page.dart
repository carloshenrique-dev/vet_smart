import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'results_model.dart';
import 'widgets/default_button.dart';
import 'widgets/veterinary_examinations_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ResultsModel> results = [];
  List<ResultsModel> results1 = [];
  List<ResultsModel> comparatedList = [];
  bool isLoadingResult = false;
  bool isLoadingResult1 = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  Future<List<ResultsModel>> _extractTextFromPdf(String exame) async {
    List<ResultsModel> resultsList = [];
    // Carrega o PDF do arquivo
    PdfDocument pdf = PdfDocument(inputBytes: await _readDocumentData(exame));

    PdfTextExtractor extractor = PdfTextExtractor(pdf);
    // Percorre as páginas do PDF
    for (int pageIndex = 0; pageIndex < pdf.pages.count; pageIndex++) {
      String text = extractor.extractText(startPageIndex: pageIndex);

      String textoLimpo = text.replaceAll(RegExp(r'[^\w\s,%]'), '');

      for (var i = 0; i < ResultsModel.getValues.length; i++) {
        Iterable<RegExpMatch> matches =
            ResultsModel.getValues[i].allMatches(textoLimpo);

        for (RegExpMatch match in matches) {
          if (match.groupCount >= 1) {
            String result = match.group(1)?.replaceAll(',', '.') ?? '';

            switch (i) {
              case 0:
                resultsList.add(ResultsModel('Hemácias', double.parse(result)));
                break;

              case 1:
                resultsList
                    .add(ResultsModel('Hemoglobina', double.parse(result)));
                break;

              case 2:
                resultsList
                    .add(ResultsModel('Hematócrito', double.parse(result)));
                break;

              case 3:
                resultsList.add(ResultsModel('VCM', double.parse(result)));
                break;

              case 4:
                resultsList.add(ResultsModel('C.H.C.M', double.parse(result)));
                break;

              case 5:
                resultsList.add(ResultsModel('R.D.W', double.parse(result)));
                break;

              case 6:
                resultsList.add(ResultsModel('P.P.T', double.parse(result)));
                break;

              case 7:
                resultsList
                    .add(ResultsModel('Mielócitos', double.parse(result)));
                break;

              case 8:
                resultsList
                    .add(ResultsModel('Metamielócitos', double.parse(result)));
                break;

              case 9:
                resultsList.add(ResultsModel(
                    'Neutrófilos bastonetes', double.parse(result)));
                break;

              case 10:
                resultsList.add(ResultsModel(
                    'Neutrófilos segmentados', double.parse(result)));
                break;

              case 11:
                resultsList
                    .add(ResultsModel('Linfócitos', double.parse(result)));
                break;

              case 12:
                resultsList
                    .add(ResultsModel('Monócitos', double.parse(result)));
                break;

              case 13:
                resultsList
                    .add(ResultsModel('Eosinófilos', double.parse(result)));
                break;

              case 14:
                resultsList
                    .add(ResultsModel('Basófilos', double.parse(result)));
                break;

              default:
                break;
            }
          }
        }
      }
    }
    return resultsList;
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
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
        actions: [
          if (comparatedList.isNotEmpty)
            ElevatedButton(
              onPressed: () => _key.currentState!.openDrawer(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.blueAccent,
              ),
              child: const Icon(
                Icons.notifications,
              ),
            )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 50,
              color: Colors.blueAccent,
              child: Center(
                child: Text(
                  'Alertas',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemBuilder: (_, index) => Row(
                    children: [
                      Text(
                        '${comparatedList[index].nomeExame}: ',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${comparatedList[index].valor}',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  itemCount: comparatedList.length,
                  separatorBuilder: (_, __) => const Divider(
                    thickness: .5,
                    height: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
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
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultButton(
                      label: 'Carregar exame 1',
                      onPressed: () async {
                        setState(() {
                          isLoadingResult = true;
                        });
                        final result = await _extractTextFromPdf(
                          'vet_smart_pdf.pdf',
                        );
                        if (result.isNotEmpty) {
                          results = result;
                          isLoadingResult = false;

                          setState(() {});
                        }
                      },
                      isLoading: isLoadingResult,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DefaultButton(
                      label: 'Carregar exame 2',
                      onPressed: () async {
                        setState(() {
                          isLoadingResult1 = true;
                        });
                        final result = await _extractTextFromPdf(
                          'vet_smart_pdf_novo.pdf',
                        );
                        if (result.isNotEmpty) {
                          results1 = result;
                          isLoadingResult1 = false;
                          setState(() {});
                        }
                      },
                      isLoading: isLoadingResult1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Visibility(
                    visible: results.isNotEmpty && results1.isNotEmpty,
                    child: DefaultButton(
                      label: 'Comparar exames',
                      onPressed: () async {
                        for (int i = 0; i < results.length; i++) {
                          double diferenca =
                              (results[i].valor - results1[i].valor).abs();
                          comparatedList.add(
                            ResultsModel(
                              results1[i].nomeExame,
                              double.parse(
                                diferenca.toStringAsFixed(2),
                              ),
                            ),
                          );
                        }
                        if (comparatedList.isNotEmpty) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            text: 'Você tem novos alertas!!!',
                            confirmBtnColor: Colors.blueAccent,
                            confirmBtnText: 'Ver alertas',
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              _key.currentState!.openDrawer();
                            },
                          );
                        }
                        setState(() {});
                      },
                      isLoading: false,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: comparatedList.isNotEmpty,
                  child: VeterinaryExaminationsList(
                    exams: comparatedList,
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
