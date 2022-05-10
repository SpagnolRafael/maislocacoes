class Produto {
  String? id;
  String? nome;
  String? codigo;
  double valorCompra;
  double mensalidade;
  String? custoManutencao;
  String? manutencao;
  // ignore: prefer_typing_uninitialized_variables
  var dataCompra;
  bool? excluido;
  String? fornecedor;
  bool? locado;

  Produto({
    this.locado,
    this.fornecedor,
    this.excluido,
    this.id,
    required this.dataCompra,
    required this.nome,
    required this.codigo,
    required this.valorCompra,
    required this.mensalidade,
    this.custoManutencao,
    this.manutencao,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "nome": nome,
      "codigo": codigo,
      "valorCompra": valorCompra,
      "mensalidade": mensalidade,
      "custoManutencao": custoManutencao,
      "manutencao": manutencao,
      "dataCompra": dataCompra,
      "excluido": excluido,
      "fornecedor": fornecedor,
      "locado": locado,
    };
    return map;
  }
}
