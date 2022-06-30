// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_selecionado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedProduct _$SelectedProductFromJson(Map json) => SelectedProduct(
      produto:
          Produto.fromJson(Map<String, dynamic>.from(json['produto'] as Map)),
      valor: (json['valor'] as num).toDouble(),
    );

Map<String, dynamic> _$SelectedProductToJson(SelectedProduct instance) =>
    <String, dynamic>{
      'produto': instance.produto.toJson(),
      'valor': instance.valor,
    };
