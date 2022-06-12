// ignore_for_file: prefer_typing_uninitialized_variables

import 'cliente.dart';
import 'produto.dart';

class Locacao {
  late Cliente cliente;
  late List<Produto> produtos;
  var dataPrimeiraCobranca;
  var dataInicial;
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

  Locacao({
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
    this.statusAtiva,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "cliente": cliente.nome,
      "produtos": produtos,
      "dataInicial": dataInicial,
      "prazo": prazoLocacao,
      "dataPrimeiraCobranca": dataPrimeiraCobranca,
      "logradouroObra": logradouroObra,
      "cep": cep,
      "complemento": complemento,
      "bairro": bairro,
      "cidade": cidade,
      "estado": estado,
      "desconto": desconto,
      "frete": frete,
      "numero": numero,
      "statusAtiva": statusAtiva,
    };
    return map;
  }
}
