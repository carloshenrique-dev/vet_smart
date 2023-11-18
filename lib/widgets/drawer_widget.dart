import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vet_smart/results_model.dart';
import 'package:vet_smart/widgets/veterinary_examinations_list.dart';

class DrawerWidget extends StatelessWidget {
  final List<ResultsModel> list;
  const DrawerWidget({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              child: VeterinaryExaminationsList(exams: list),
            ),
          ),
        ],
      ),
    );
  }
}
