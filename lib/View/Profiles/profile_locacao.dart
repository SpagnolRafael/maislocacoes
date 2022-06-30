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
import 'package:mais_locacoes/Model/produto_selecionado.dart';
import 'package:mais_locacoes/View/BottomAppBar/locacoes_page.dart';
import 'package:mais_locacoes/recursos/widgets/custom_text_field.dart';
import '../../Model/cliente.dart';
import '../../Model/produto.dart';

class ProfileLocacao extends StatefulWidget {
  Locacao locacao;
  ProfileLocacao(this.locacao, {Key? key}) : super(key: key);

  @override
  State<ProfileLocacao> createState() => _ProfileLocacaoState();
}

class _ProfileLocacaoState extends State<ProfileLocacao> {
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

  List<Cliente> _listaClientes = [];
  List<Produto> _listaProdutos = [];

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

  Future<void> _initController() async {
    await _recuperarProdutos();
    await recuperarClientes();
    _changeDropList();
    _changeDropProductList();
    setState(() {});
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

  SingleValueDropDownController dropValueProduct =
      SingleValueDropDownController();
  SingleValueDropDownController dropValueCliente =
      SingleValueDropDownController();
  List<DropDownValueModel> dropList = [];
  List<DropDownValueModel> dropListProduct = [];

  List<SelectedProduct> produtosSelecionados = [];

  var widgetListProdutoAdicionado = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    final _dataInicial = TextEditingController(text: DateTime.now().toString());
    // final _dataFinal = TextEditingController(
    //     text: formatDate(DateTime.now(), [dd, "/", mm, "/", yyyy]));
    final _dataVencimento =
        TextEditingController(text: DateTime.now().toString());

    late DateTime _dataInicialCast;
    late DateTime _dataVencimentoCast;

    // final locationPeriod = _dataFinal.difference(_dataInicial);

    final _cepController = TextEditingController(text: widget.locacao.cep);
    final _complementoController =
        TextEditingController(text: widget.locacao.complemento);
    final _numeroController =
        TextEditingController(text: widget.locacao.numero);
    final _logradouroController =
        TextEditingController(text: widget.locacao.logradouroObra);
    final _bairroController =
        TextEditingController(text: widget.locacao.bairro);
    final _cidadeController =
        TextEditingController(text: widget.locacao.cidade);
    final _estadoController =
        TextEditingController(text: widget.locacao.estado);
    final _obraController =
        TextEditingController(text: widget.locacao.obraDeclarada);
    final _prazoController =
        TextEditingController(text: widget.locacao.prazoLocacao.toString());
    final _mensalidadeController = TextEditingController();
    final _freteController =
        TextEditingController(text: widget.locacao.frete.toString());
    final _valorTotalController =
        TextEditingController(text: widget.locacao.valorTotal.toString());
    final _descontoController =
        TextEditingController(text: widget.locacao.desconto.toString());

    final List<Cobranca> _listaCobrancas = [];
    late Locacao locacao;

    double _getTotalValor(List<SelectedProduct> listaProdutos) {
      double valorTotal = 0;

      for (var produto in produtosSelecionados) {
        valorTotal += produto.valor;
      }
      return valorTotal;
    }

    _criarListaCobrancas(int prazoLocacao) {
      Jiffy dataVencimento = Jiffy([
        _dataVencimentoCast.year,
        _dataVencimentoCast.month,
        _dataVencimentoCast.day,
      ]);
      for (int i = 0; i < prazoLocacao; i++) {
        Cobranca cobranca = Cobranca(
          vencimento: dataVencimento.dateTime,
          cliente: dropValueCliente.dropDownValue!.value as Cliente,
          produtos: produtosSelecionados,
          valor: _getTotalValor(produtosSelecionados),
        );
        dataVencimento.add(months: 1);
        _listaCobrancas.add(cobranca);
      }
    }

    DateTime _generateDevolutionDate(int prazoLocacao) {
      Jiffy dataDevolucao = Jiffy([
        _dataInicialCast.year,
        _dataInicialCast.month,
        _dataInicialCast.day,
      ]);
      dataDevolucao = dataDevolucao.add(months: (prazoLocacao + 1));
      return dataDevolucao.dateTime;
    }

    _getContractNumber() {}

    _cadastrarLocacao() async {
      //TODO CORRIGIR NAO TA ACUMULANDO O NUMERO DO CONTRATO
      FirebaseFirestore database = FirebaseFirestore.instance;
      int prazoLocacao = int.parse(_prazoController.text);

      _dataVencimentoCast = DateTime.parse(_dataVencimento.text.toString());
      _dataInicialCast = DateTime.parse(_dataInicial.text.toString());

      _criarListaCobrancas(prazoLocacao);

      Locacao locacao = Locacao(
        dataDevolucao: _generateDevolutionDate(prazoLocacao),
        numeroContrato: 1000, //TODO RECONSTRUIR ESSA LOGICA
        cliente: dropValueCliente.dropDownValue!.value,
        produtos: produtosSelecionados,
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
        cobrancas: _listaCobrancas,
      );

      //GERANDO O DOC ID E ADD A COLLECTION JA COM ID MAPEADO
      CollectionReference toolsCollectionRef =
          FirebaseFirestore.instance.collection("locacao");
      String newDocID = toolsCollectionRef.doc().id;

      await database.collection("locacao").doc(newDocID).set({
        ...locacao.toJson(),
        "id": newDocID,
      });

      for (var produtinho in produtosSelecionados) {
        await database
            .collection("produtos")
            .doc(produtinho.produto.id)
            .update({"locado": true});
      }

      _dataInicial.text = DateTime.now().toString();
      _prazoController.text = "";
      _dataVencimento.text = DateTime.now().toString();
      _logradouroController.text = "";
      _cepController.text = "";
      _complementoController.text = "";
      _numeroController.text = "";
      _cidadeController.text = "";
      _estadoController.text = "";
      _bairroController.text = "";
      _freteController.text = "";

      // for (var produto in produtosSelecionados) {
      //   final locadoStatus =
      //       await database.collection("produtos").doc();
      // }

      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LocacaoPage()));
    }

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
                  singleController: dropValueCliente,
                  searchAutofocus: true,
                  enableSearch: true,
                  dropDownList: dropList,
                  onChanged: (value) {
                    setState(() {
                      dropValueCliente.setDropDown(value);
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
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 8, 15),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(),
                        ],
                        controller: _descontoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Desconto",
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
                        enabled: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(),
                        ],
                        controller: _valorTotalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Valor Total",
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
                              const EdgeInsets.fromLTRB(22, 16, 20, 16),
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
                              const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                        autocorrect: true,
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
                  singleController: dropValueProduct,
                  searchAutofocus: true,
                  enableSearch: true,
                  dropDownList: dropListProduct
                      .where((element) =>
                          (element.value as Produto).locado == false)
                      .toList()
                      .where((element) => !produtosSelecionados.any(
                          (selected) =>
                              selected.produto.codigo ==
                              (element.value as Produto).codigo))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      dropValueProduct.setDropDown(value);
                    });
                  },
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 17, 8, 0),
                      child: TextFormField(
                        autocorrect: false,
                        controller: _mensalidadeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 8, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "R\$ mensalidade",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 17, 8, 0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          produtosSelecionados.add(SelectedProduct(
                            produto: dropValueProduct.dropDownValue!.value,
                            //TODO VALOR ACIMA DE 1K O REPLACE BUGA O CODIGO TODO
                            valor: double.parse(
                              _mensalidadeController.text.replaceAll(",", "."),
                            ),
                          ));
                          _mensalidadeController.text = "";
                          dropValueProduct = SingleValueDropDownController();
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
                  widgetListProdutoAdicionado == false ? Container() : Column(),
                ],
              ),
              SizedBox(height: 10),
              ...produtosSelecionados
                  .map<Widget>((produto) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: Row(
                            children: [
                              Text(
                                "${produto.produto.codigo} - ${produto.produto.nome} | ",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                " R\$${produto.valor.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    produtosSelecionados.remove(produto);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: CustomTextFormField(
              //       controller: _valorTotalController, label: "Valor Total"),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 40),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 4, 6, 107),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  onPressed: () async {
                    await _cadastrarLocacao();
                  },
                  label: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontSize: 30,
                      ),
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
