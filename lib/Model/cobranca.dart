import 'package:json_annotation/json_annotation.dart';
import 'package:mais_locacoes/Model/cliente.dart';
import 'package:mais_locacoes/Model/produto_selecionado.dart';

part 'cobranca.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class Cobranca {
  DateTime? vencimento;
  Cliente? cliente;
  List<SelectedProduct>? produtos;
  final double valor;
  bool statusPagamento;

  Cobranca({
    this.vencimento,
    this.cliente,
    this.produtos,
    required this.valor,
    this.statusPagamento = false,
  });

  factory Cobranca.fromJson(Map<String, dynamic> json) =>
      _$CobrancaFromJson(json);

  Map<String, dynamic> toJson() => _$CobrancaToJson(this);
}
