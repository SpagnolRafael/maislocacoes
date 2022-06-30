import 'package:json_annotation/json_annotation.dart';

part 'produto.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
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
  factory Produto.fromJson(Map<String, dynamic> json) =>
      _$ProdutoFromJson(json);
  Map<String, dynamic> toJson() => _$ProdutoToJson(this);
}
