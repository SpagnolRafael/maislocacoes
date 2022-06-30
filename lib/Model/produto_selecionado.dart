import 'package:json_annotation/json_annotation.dart';

import 'produto.dart';

part 'produto_selecionado.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class SelectedProduct {
  late final Produto produto;
  late final double valor;

  SelectedProduct({
    required this.produto,
    required this.valor,
  });

  factory SelectedProduct.fromJson(Map<String, dynamic> json) =>
      _$SelectedProductFromJson(json);

  Map<String, dynamic> toJson() => _$SelectedProductToJson(this);
}
