import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'results_model.dart';
import 'widgets/default_button.dart';
import 'widgets/drawer_widget.dart';
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

  Future<List<ResultsModel>> _extractTextFromPdf() async {
    List<ResultsModel> resultsList = [];

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    Uint8List? fileBytes;

    if (result != null) {
      fileBytes = result.files.single.bytes;
    }

    // Verifica se a lista de bytes não é nula
    if (fileBytes != null) {
      // Carrega o PDF do Uint8List
      PdfDocument pdf = PdfDocument(inputBytes: fileBytes);

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
                  resultsList.add(ResultsModel(
                    'Hemácias',
                    double.parse(result),
                  ));
                  break;

                case 1:
                  resultsList.add(ResultsModel(
                    'Hemoglobina',
                    double.parse(result),
                  ));
                  break;

                case 2:
                  resultsList.add(ResultsModel(
                    'Hematócrito',
                    double.parse(result),
                  ));
                  break;

                case 3:
                  resultsList.add(ResultsModel(
                    'VCM',
                    double.parse(result),
                  ));
                  break;

                case 4:
                  resultsList.add(ResultsModel(
                    'C.H.C.M',
                    double.parse(result),
                  ));
                  break;

                case 5:
                  resultsList.add(ResultsModel(
                    'R.D.W',
                    double.parse(result),
                  ));
                  break;

                case 6:
                  resultsList.add(ResultsModel(
                    'P.P.T',
                    double.parse(result),
                  ));
                  break;

                case 7:
                  resultsList.add(ResultsModel(
                    'Mielócitos',
                    double.parse(result),
                  ));
                  break;

                case 8:
                  resultsList.add(ResultsModel(
                    'Metamielócitos',
                    double.parse(result),
                  ));
                  break;

                case 9:
                  resultsList.add(ResultsModel(
                    'Neutrófilos bastonetes',
                    double.parse(result),
                  ));
                  break;

                case 10:
                  resultsList.add(ResultsModel(
                    'Neutrófilos segmentados',
                    double.parse(result),
                  ));
                  break;

                case 11:
                  resultsList.add(ResultsModel(
                    'Linfócitos',
                    double.parse(result),
                  ));
                  break;

                case 12:
                  resultsList.add(ResultsModel(
                    'Monócitos',
                    double.parse(result),
                  ));
                  break;

                case 13:
                  resultsList.add(ResultsModel(
                    'Eosinófilos',
                    double.parse(result),
                  ));
                  break;

                case 14:
                  resultsList.add(ResultsModel(
                    'Basófilos',
                    double.parse(result),
                  ));
                  break;

                default:
                  break;
              }
            }
          }
        }
      }
    } else {
      // Lógica de tratamento caso a lista de bytes seja nula
    }

    return resultsList;
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
            color: Colors.white,
          ),
        ),
        leading: const Icon(
          Icons.pets,
          color: Colors.white,
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
                color: Colors.white,
              ),
            )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: DrawerWidget(list: comparatedList),
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
                        final result = await _extractTextFromPdf();
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
                        final result = await _extractTextFromPdf();
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
                              results[i].valor - results1[i].valor;
                          double diferencaAbs = diferenca.abs();

                          if (diferenca > 0) {
                            comparatedList.add(
                              ResultsModel(
                                results1[i].nomeExame,
                                double.parse(
                                  diferencaAbs.toStringAsFixed(2),
                                ),
                                iconData: Icons.arrow_upward,
                              ),
                            );
                          } else if (diferenca < 0) {
                            comparatedList.add(
                              ResultsModel(
                                results1[i].nomeExame,
                                double.parse(
                                  diferencaAbs.toStringAsFixed(2),
                                ),
                                iconData: Icons.arrow_downward,
                              ),
                            );
                          }
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
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Exames sem alterações',
                            confirmBtnColor: Colors.blueAccent,
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
