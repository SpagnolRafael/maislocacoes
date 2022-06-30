// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locacoes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Locacao _$LocacaoFromJson(Map json) => Locacao(
      cliente:
          Cliente.fromJson(Map<String, dynamic>.from(json['cliente'] as Map)),
      produtos: (json['produtos'] as List<dynamic>)
          .map((e) =>
              SelectedProduct.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      obraDeclarada: json['obraDeclarada'],
      valorTotal: json['valorTotal'],
      id: json['id'],
      dataInicial: json['dataInicial'],
      dataDevolucao: json['dataDevolucao'],
      prazoLocacao: json['prazoLocacao'],
      dataPrimeiraCobranca: json['dataPrimeiraCobranca'],
      logradouroObra: json['logradouroObra'] as String?,
      cep: json['cep'] as String?,
      complemento: json['complemento'] as String?,
      numero: json['numero'] as String?,
      bairro: json['bairro'] as String?,
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
      frete: (json['frete'] as num?)?.toDouble(),
      desconto: (json['desconto'] as num?)?.toDouble(),
      statusAtiva: json['statusAtiva'] as bool?,
      cobrancas: (json['cobrancas'] as List<dynamic>)
          .map((e) => Cobranca.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      numeroContrato: json['numeroContrato'] as int,
    );

Map<String, dynamic> _$LocacaoToJson(Locacao instance) => <String, dynamic>{
      'obraDeclarada': instance.obraDeclarada,
      'valorTotal': instance.valorTotal,
      'numeroContrato': instance.numeroContrato,
      'cliente': instance.cliente.toJson(),
      'produtos': instance.produtos.map((e) => e.toJson()).toList(),
      'cobrancas': instance.cobrancas.map((e) => e.toJson()).toList(),
      'dataPrimeiraCobranca': instance.dataPrimeiraCobranca,
      'dataInicial': instance.dataInicial,
      'prazoLocacao': instance.prazoLocacao,
      'logradouroObra': instance.logradouroObra,
      'cep': instance.cep,
      'complemento': instance.complemento,
      'bairro': instance.bairro,
      'cidade': instance.cidade,
      'estado': instance.estado,
      'numero': instance.numero,
      'frete': instance.frete,
      'desconto': instance.desconto,
      'statusAtiva': instance.statusAtiva,
      'dataDevolucao': instance.dataDevolucao,
    };
