import 'package:json_annotation/json_annotation.dart';

part "cliente.g.dart";

@JsonSerializable(anyMap: true, explicitToJson: true)
class Cliente {
  String? razaoSocial;
  String? inscricaoEstadual;
  String? cnpj;
  String? nome;
  String? cpf;
  String? rg;
  String? logradouro;
  String? numero;
  String? complemento;
  String? bairro;
  String? cep;
  String? cidade;
  String? estado;
  String? contato1;
  String? contato2;
  String? email;
  String? urlImagem;
  String? id;
  // ignore: prefer_typing_uninitialized_variables
  var dataCadastro;
  bool? rate; //false para bom, true para ruim
  bool? excluido;
  String? observacao;
  Cliente({
    this.observacao,
    this.rate,
    this.excluido,
    this.dataCadastro,
    this.id,
    this.urlImagem,
    this.razaoSocial,
    this.cnpj,
    this.inscricaoEstadual,
    required this.nome,
    required this.cpf,
    required this.rg,
    required this.contato1,
    this.contato2,
    required this.email,
    required this.logradouro,
    this.numero,
    required this.bairro,
    required this.complemento,
    required this.cep,
    required this.cidade,
    required this.estado,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ClienteToJson(this);
}
