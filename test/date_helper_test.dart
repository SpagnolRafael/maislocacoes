import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mais_locacoes/Model/cliente.dart';
import 'package:mais_locacoes/Model/produto.dart';

List<Cobranca> getDueDates(
    {required double mensalValue,
    required DateTime inicialDate,
    required DateTime dueDate,
    required int numberMonths,
    required Cliente cliente,
    required List<Produto> produtos}) {
  List<Cobranca> tempList = [];
  for (int x = 0; x < numberMonths; x++) {
    tempList.add(
      Cobranca(
        fatura: Fatura(
          cliente: cliente,
          valor: mensalValue,
          produtos: produtos,
          dataInicio: Jiffy([dueDate.year, dueDate.month, dueDate.day])
              .add(months: x)
              .dateTime,
          dataFim: Jiffy([dueDate.year, dueDate.month, dueDate.day])
              .add(months: x + 1)
              .dateTime,
        ),
        pago: false,
        vencimento: Jiffy([dueDate.year, dueDate.month, dueDate.day])
            .add(months: x)
            .dateTime,
      ),
    );
  }
  return tempList;
}

class Cobranca extends Equatable {
  final DateTime vencimento;
  final bool pago;
  final Fatura fatura;

  Cobranca({
    required this.fatura,
    required this.pago,
    required this.vencimento,
  });

  @override
  List<Object> get props => [vencimento, pago, fatura];
}

class Fatura extends Equatable {
  final double valor;
  final Cliente cliente;
  final List<Produto> produtos;
  final DateTime dataInicio;
  final DateTime dataFim;

  Fatura({
    required this.valor,
    required this.cliente,
    required this.produtos,
    required this.dataInicio,
    required this.dataFim,
  });

  @override
  List<Object> get props => [valor, cliente, produtos, dataInicio, dataFim];
}

void main() {
  test(
      "deve retornar corretamente uma lista de datas de pagamento para uma fatura de 1 mês",
      () {
    //DATA INICIAL 08/06/2022
    //VALOR MENSAL 230
    //NUMERO DE MESES 3
    //1 PRODUTO
    //CLIENTE
    final cliente = Cliente(
      nome: "andriel",
      cpf: "12345678944",
      rg: "0000000",
      contato1: "1111111111",
      email: "test@email.com",
      logradouro: "teste",
      bairro: "bairro",
      complemento: "complemento",
      cep: "00000000",
      cidade: "macedonia",
      estado: "afega",
    );
    final produto = Produto(
      dataCompra: DateTime(2022, 10, 10),
      nome: "maracujá",
      codigo: "121",
      valorCompra: 10,
      mensalidade: 20,
    );
    final result = getDueDates(
        dueDate: DateTime(2022, 6, 18),
        mensalValue: 230,
        inicialDate: DateTime(2022, 6, 8),
        numberMonths: 1,
        cliente: cliente,
        produtos: [produto]);
    final expected = [
      Cobranca(
        fatura: Fatura(
          cliente: cliente,
          produtos: [produto],
          valor: 230,
          dataInicio: DateTime(2022, 6, 18),
          dataFim: DateTime(2022, 7, 18),
        ),
        pago: false,
        vencimento: DateTime(2022, 6, 18),
      )
    ];
    expect(result, equals(expected));
  });
}
