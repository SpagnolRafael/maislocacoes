// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cobranca.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cobranca _$CobrancaFromJson(Map json) => Cobranca(
      vencimento: json['vencimento'] == null
          ? null
          : DateTime.parse(json['vencimento'] as String),
      cliente: json['cliente'] == null
          ? null
          : Cliente.fromJson(Map<String, dynamic>.from(json['cliente'] as Map)),
      produtos: (json['produtos'] as List<dynamic>?)
          ?.map((e) =>
              SelectedProduct.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      valor: (json['valor'] as num).toDouble(),
      statusPagamento: json['statusPagamento'] as bool? ?? false,
    );

Map<String, dynamic> _$CobrancaToJson(Cobranca instance) => <String, dynamic>{
      'vencimento': instance.vencimento?.toIso8601String(),
      'cliente': instance.cliente?.toJson(),
      'produtos': instance.produtos?.map((e) => e.toJson()).toList(),
      'valor': instance.valor,
      'statusPagamento': instance.statusPagamento,
    };
