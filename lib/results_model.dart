class ResultsModel {
  String nomeExame;
  double valor;

  ResultsModel(this.nomeExame, this.valor);

  @override
  String toString() {
    return '$nomeExame: $valor';
  }
}
