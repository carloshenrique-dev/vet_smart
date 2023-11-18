import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vet_smart/results_model.dart';

class VeterinaryExaminationsList extends StatelessWidget {
  final List<ResultsModel> exams;
  const VeterinaryExaminationsList({
    super.key,
    required this.exams,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parâmetros: ',
            style: GoogleFonts.roboto(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => Row(
              children: [
                Text(
                  '${exams[index].nomeExame}: ',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${exams[index].valor}',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
                if (exams[index].iconData != null)
                  Icon(
                    exams[index].iconData,
                    color: exams[index].iconData == Icons.arrow_upward
                        ? Colors.green
                        : Colors.red,
                  ),
              ],
            ),
            itemCount: exams.length,
            separatorBuilder: (_, __) => const Divider(
              thickness: .5,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}
