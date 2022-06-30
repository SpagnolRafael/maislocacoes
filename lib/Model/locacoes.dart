// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:json_annotation/json_annotation.dart';
import 'package:mais_locacoes/Model/cobranca.dart';
import 'package:mais_locacoes/Model/produto_selecionado.dart';
import 'cliente.dart';

part 'locacoes.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Locacao {
  String? obraDeclarada;
  String? id;
  int numeroContrato = 0;
  Cliente cliente;
  List<SelectedProduct> produtos;
  List<Cobranca> cobrancas;
  var dataPrimeiraCobranca;
  var dataInicial;
  var dataDevolucao;
  var prazoLocacao;
  String? logradouroObra;
  String? cep;
  String? complemento;
  String? bairro;
  String? cidade;
  String? estado;
  String? numero;
  double? frete;
  double? desconto;
  bool? statusAtiva;
  double? valorTotal;

  Locacao({
    this.obraDeclarada,
    this.valorTotal,
    this.id,
    this.dataDevolucao,
    required this.cliente,
    required this.produtos,
    required this.dataInicial,
    required this.prazoLocacao,
    required this.dataPrimeiraCobranca,
    required this.logradouroObra,
    required this.cep,
    this.complemento,
    this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.frete,
    this.desconto,
    this.statusAtiva = true,
    required this.cobrancas,
    required this.numeroContrato,
  });

  factory Locacao.fromJson(Map<String, dynamic> json) =>
      _$LocacaoFromJson(json);

  Map<String, dynamic> toJson() => _$LocacaoToJson(this);
}
