// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Produto _$ProdutoFromJson(Map json) => Produto(
      locado: json['locado'] as bool?,
      fornecedor: json['fornecedor'] as String?,
      excluido: json['excluido'] as bool?,
      id: json['id'] as String?,
      dataCompra: json['dataCompra'],
      nome: json['nome'] as String?,
      codigo: json['codigo'] as String?,
      valorCompra: (json['valorCompra'] as num).toDouble(),
      mensalidade: (json['mensalidade'] as num).toDouble(),
      custoManutencao: json['custoManutencao'] as String?,
      manutencao: json['manutencao'] as String?,
    );

Map<String, dynamic> _$ProdutoToJson(Produto instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'codigo': instance.codigo,
      'valorCompra': instance.valorCompra,
      'mensalidade': instance.mensalidade,
      'custoManutencao': instance.custoManutencao,
      'manutencao': instance.manutencao,
      'dataCompra': instance.dataCompra,
      'excluido': instance.excluido,
      'fornecedor': instance.fornecedor,
      'locado': instance.locado,
    };
