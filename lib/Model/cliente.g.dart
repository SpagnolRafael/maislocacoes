// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cliente _$ClienteFromJson(Map json) => Cliente(
      observacao: json['observacao'] as String?,
      rate: json['rate'] as bool?,
      excluido: json['excluido'] as bool?,
      dataCadastro: json['dataCadastro'],
      id: json['id'] as String?,
      urlImagem: json['urlImagem'] as String?,
      razaoSocial: json['razaoSocial'] as String?,
      cnpj: json['cnpj'] as String?,
      inscricaoEstadual: json['inscricaoEstadual'] as String?,
      nome: json['nome'] as String?,
      cpf: json['cpf'] as String?,
      rg: json['rg'] as String?,
      contato1: json['contato1'] as String?,
      contato2: json['contato2'] as String?,
      email: json['email'] as String?,
      logradouro: json['logradouro'] as String?,
      numero: json['numero'] as String?,
      bairro: json['bairro'] as String?,
      complemento: json['complemento'] as String?,
      cep: json['cep'] as String?,
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
    );

Map<String, dynamic> _$ClienteToJson(Cliente instance) => <String, dynamic>{
      'razaoSocial': instance.razaoSocial,
      'inscricaoEstadual': instance.inscricaoEstadual,
      'cnpj': instance.cnpj,
      'nome': instance.nome,
      'cpf': instance.cpf,
      'rg': instance.rg,
      'logradouro': instance.logradouro,
      'numero': instance.numero,
      'complemento': instance.complemento,
      'bairro': instance.bairro,
      'cep': instance.cep,
      'cidade': instance.cidade,
      'estado': instance.estado,
      'contato1': instance.contato1,
      'contato2': instance.contato2,
      'email': instance.email,
      'urlImagem': instance.urlImagem,
      'id': instance.id,
      'dataCadastro': instance.dataCadastro,
      'rate': instance.rate,
      'excluido': instance.excluido,
      'observacao': instance.observacao,
    };
