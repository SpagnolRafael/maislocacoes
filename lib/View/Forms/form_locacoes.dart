// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, avoid_print
import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mais_locacoes/Model/cobranca.dart';
import 'package:mais_locacoes/Model/locacoes.dart';
import 'package:mais_locacoes/recursos/widgets/custom_text_field.dart';
import '../../Model/cliente.dart';
import '../../Model/produto.dart';

class FormLocacoes extends StatefulWidget {
  const FormLocacoes({Key? key}) : super(key: key);

  @override
  _FormLocacoesState createState() => _FormLocacoesState();
}

class _FormLocacoesState extends State<FormLocacoes> {
  List<Cliente> _listaClientes = [];
  List<Produto> _listaProdutos = [];

  FocusNode? myFocusNode;
  //final _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initController();
    myFocusNode = FocusNode();
  }

  Future<void> _initController() async {
    await _recuperarProdutos();
    await recuperarClientes();
    _changeDropList();
    _changeDropProductList();
    setState(() {});
  }

  // num getNumberOfMonthsBetweenPeriod({
  //   required DateTime beginPeriod,
  //   required DateTime endPeriod,
  // }) {
  //   return Jiffy([endPeriod.year, endPeriod.month, endPeriod.day]).diff(
  //     Jiffy([beginPeriod.year, beginPeriod.month, beginPeriod.day]),
  //     Units.MONTH,
  //   );
  // }

  Future<List> _recuperarProdutos() async {
    _listaProdutos = [];

    FirebaseFirestore database = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await database
        .collection("produtos")
        .where("excluido", isEqualTo: false)
        .where("locado", isEqualTo: false)
        .orderBy("nome")
        .orderBy("codigo")
        .get();
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data() as Map<String, dynamic>;
      var dadoID = item.id;

      Produto produto = Produto(
        id: dadoID,
        dataCompra: dados["dataCompra"],
        nome: dados["nome"],
        codigo: dados["codigo"],
        valorCompra: dados["valorCompra"],
        mensalidade: dados["mensalidade"],
        locado: dados["locado"],
      );

      _listaProdutos.add(produto);
    }
    return _listaProdutos;
  }

  Future<List> recuperarClientes() async {
    _listaClientes = [];
    FirebaseFirestore database = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await database
        .collection("clientes")
        .where("excluido", isEqualTo: false)
        .orderBy("nome")
        .get();
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data() as Map<String, dynamic>;
      var dadoID = item.id;

      Cliente cliente = Cliente(
        id: dadoID,
        razaoSocial: dados["razaoSocial"],
        cnpj: dados["cnpj"],
        inscricaoEstadual: dados["inscricaoEstadual"],
        nome: dados["nome"],
        cpf: dados["cpf"],
        rg: dados["rg"],
        contato1: dados["contato1"],
        contato2: dados["contato2"],
        email: dados["email"],
        logradouro: dados["logradouro"],
        numero: dados["numero"],
        bairro: dados["bairro"],
        complemento: dados["complemento"],
        cep: dados["cep"],
        cidade: dados["cidade"],
        estado: dados["estado"],
        dataCadastro: dados["dataCadastro"],
        rate: dados["rate"],
        excluido: dados["excluido"],
        observacao: dados["observacao"],
      );

      _listaClientes.add(cliente);
    }
    await _recuperarProdutos();
    return _listaClientes;
  }

  final _dataInicial = TextEditingController(text: DateTime.now().toString());
  // final _dataFinal = TextEditingController(
  //     text: formatDate(DateTime.now(), [dd, "/", mm, "/", yyyy]));
  final _dataVencimento =
      TextEditingController(text: DateTime.now().toString());

  late DateTime _dataInicialCast;
  late DateTime _dataVencimentoCast;

  // final locationPeriod = _dataFinal.difference(_dataInicial);

  final _cepController = TextEditingController();
  final _complementoController = TextEditingController();
  final _numeroController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _obraController = TextEditingController();
  final _prazoController = TextEditingController();
  final _mensalidadeController = TextEditingController();
  final _freteController = TextEditingController();

  _cadastrarLocacao() async {
    Locacao locacao = Locacao(
      cliente: dropValueCliente,
      produtos: dropValueProduct,
      dataInicial: _dataInicialCast,
      prazoLocacao: prazoLocacao,
      dataPrimeiraCobranca: _dataVencimentoCast,
      logradouroObra: _logradouroController.text,
      cep: _cepController.text,
      complemento: _complementoController.text,
      numero: _numeroController.text,
      cidade: _cidadeController.text,
      estado: _estadoController.text,
      bairro: _bairroController.text,
      frete: double.tryParse(_freteController.text),
    );
  }

  _changeDropList() async {
    dropList = [];
    for (Cliente cliente in _listaClientes) {
      // ignore: iterable_contains_unrelated_type
      if (cliente.cnpj == null && !dropList.contains((cliente.nome))) {
        dropList.add(DropDownValueModel(name: cliente.nome!, value: cliente));
      } else {
        dropList.add(
            DropDownValueModel(name: cliente.razaoSocial!, value: cliente));
      }
    }
    setState(() {});
    return dropList;
  }

  _changeDropProductList() async {
    for (Produto produto in _listaProdutos) {
      // ignore: iterable_contains_unrelated_type

      dropListProduct.add(DropDownValueModel(
        name: "${produto.codigo!} - ${produto.nome!}",
        value: produto,
      ));
    }
    return dropListProduct;
  }

  // ignore: prefer_const_constructors
  dynamic dropValueCliente;
  dynamic dropValueProduct;
  List<DropDownValueModel> dropList = [];
  List<DropDownValueModel> dropListProduct = [];

  int? prazoLocacao;
  List<Produto> produtosSelecionados = [];
  List<double> valorDaMensalidadeDoProdutoSelecionado = [];
  Jiffy vencimentos = Jiffy();

  // Map<dynamic, double?> mapProdutoMensalidade= {
  //   dropValueProduct : mensalidadeProduto,
  // };
  _getTotalValueLocacao() {
    for (var produto in produtosSelecionados) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 3, 112),
        title: const Text(
          "Nova Locação",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          // key: _globalKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 30, 8, 15),
                child: DropDownTextField(
                  textFieldDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Selecione o Cliente",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  initialValue: dropValueCliente,
                  searchAutofocus: true,
                  enableSearch: true,
                  dropDownList: dropList,
                  onChanged: (value) {
                    setState(() {
                      dropValueCliente = value;
                    });
                  },
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 8, 15),
                      child: DateTimePicker(
                        controller: _dataInicial,
                        dateMask: "dd/MM/yyyy",
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2300),
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.date_range_outlined),
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 8, 20, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Data Inicial",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 8, 15),
                      child: DateTimePicker(
                        controller: _dataVencimento,
                        dateMask: "dd/MM/yyyy",
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2300),
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.date_range_outlined),
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 8, 20, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Data 1º Vencimento",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 5, 15),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          RealInputFormatter(),
                        ],
                        controller: _prazoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 8, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Prazo em meses",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 8, 15),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(),
                        ],
                        controller: _freteController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Frete",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 5, 10),
                child: Text(
                  "==== Dados da Obra ====",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 5, 15),
                      child: TextFormField(
                        onChanged: (String value) {
                          if (value.length == 10) {
                            print("request");
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CepInputFormatter(),
                        ],
                        controller: _cepController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 8, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "CEP *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 8, 15),
                      child: TextFormField(
                        controller: _complementoController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Complemento",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 15),
                child: TextFormField(
                  controller: _logradouroController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Logradouro *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 5, 15),
                      child: TextFormField(
                        controller: _numeroController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 8, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Número *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 8, 15),
                      child: TextFormField(
                        autocorrect: false,
                        controller: _bairroController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Bairro *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 5, 15),
                      child: TextFormField(
                        autocorrect: false,
                        controller: _cidadeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 8, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Cidade *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 8, 15),
                      child: CustomTextFormField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "é obrigatório";
                          }
                          return null;
                        },
                        controller: _estadoController,
                        label: "Estado *",
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 15),
                child: TextFormField(
                  controller: _obraController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Declarar Obra",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "==== Selecione os Produtos ====",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 17, 8, 0),
                child: DropDownTextField(
                  textFieldDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Selecione Produto",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  initialValue: dropValueProduct,
                  searchAutofocus: true,
                  enableSearch: true,
                  dropDownList: dropListProduct,
                  onChanged: (value) {
                    FocusScope.of(context).requestFocus(myFocusNode);
                    setState(() {
                      dropValueProduct = value;
                      produtosSelecionados.add(dropValueProduct);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 17, 70, 0),
                child: TextFormField(
                  autocorrect: false,
                  controller: _mensalidadeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "R\$ mensalidade",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 8, 10),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedProducts.add(dropValueProduct);
                          dropValueProduct = "";
                        });
                      },
                      child: const Text(
                        "Adicionar",
                        style: TextStyle(
                          color: Color.fromARGB(255, 1, 48, 87),
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 40),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 4, 6, 107),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  onPressed: () {
                    prazoLocacao = int.tryParse(_prazoController.text);
                    _dataInicialCast =
                        DateTime.parse(_dataInicial.text.toString());
                    for (int i = 0; i <= prazoLocacao!; i++) {
                      print(Jiffy([
                        _dataInicialCast.year,
                        _dataInicialCast.month,
                        _dataInicialCast.day
                      ]).add(months: i).dateTime);
                    }
                  },
                  label: const Text(
                    "Cadastrar",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
