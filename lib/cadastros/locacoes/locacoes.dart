// ignore_for_file: prefer_typing_uninitialized_variables

import '../clientes/cliente.dart';
import '../produtos/produto.dart';

class Locacao {
  late Cliente cliente;
  late List<Produto> produto;
  var dataPrimeiraCobranca;
  var dataInicial;
  var dataFinal;
  String? logradouroObra;
  String? cep;
  String? complemento;
  String? bairro;
  String? cidade;
  String? estado;
  double? frete;
  double? desconto;
  bool? statusAtiva;

  Locacao({
    required this.cliente,
    required this.produto,
    required this.dataInicial,
    required this.dataFinal,
    required this.dataPrimeiraCobranca,
    required this.logradouroObra,
    this.cep,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.frete,
    this.desconto,
    this.statusAtiva,
  });
}
