import 'package:mais_locacoes/Model/cliente.dart';

import 'produto.dart';

class Cobranca {
  DateTime? primeiroVencimento;
  double? valorTotal;
  Cliente? cliente;
  List<Produto>? produtos;

  Cobranca(
      {this.primeiroVencimento, this.valorTotal, this.cliente, this.produtos});
}
