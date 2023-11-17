class ResultsModel {
  String nomeExame;
  double valor;

  ResultsModel(this.nomeExame, this.valor);

  static final List<RegExp> getValues = [
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
  String toString() {
    return '$nomeExame: $valor';
  }
}
