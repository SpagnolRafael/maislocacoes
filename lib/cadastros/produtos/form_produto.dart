import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mais_locacoes/cadastros/produtos/produto.dart';

import '../../pages/produtos_page.dart';

class FormProduto extends StatefulWidget {
  const FormProduto({Key? key}) : super(key: key);

  @override
  _FormProdutoState createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  // ignore: prefer_typing_uninitialized_variables

  var _msgErro = "";

  Future _cadastroProduto() async {
    if (_nomeController.text != "" && _codigoController.text != "") {
      String nome = _nomeController.text;
      String codigo = _codigoController.text;
      String valorCompra1 = (_valorController.text).replaceAll(".", "");
      String valorCompra2 = valorCompra1.replaceAll(",", ".");
      double valorCompra = double.parse(valorCompra2);
      String mensalidade1 = (_mensalidadeController.text).replaceAll(".", "");
      String mensalidade2 = mensalidade1.replaceAll(",", ".");
      double mensalidade = double.parse(mensalidade2);
      String fornecedor = _fornecedorController.text;
      var dataSelecionada = _dataCompraController.text;
      bool excluido = false;
      bool locado = false;
      Produto produto = Produto(
        nome: nome,
        codigo: codigo,
        valorCompra: valorCompra,
        mensalidade: mensalidade,
        dataCompra: dataSelecionada,
        excluido: excluido,
        locado: locado,
        fornecedor: fornecedor,
      );

      _nomeController.text = "";
      _fornecedorController.text = "";
      _valorController.text = "";
      _mensalidadeController.text = "";
      _codigoController.text = "";

      FirebaseFirestore database = FirebaseFirestore.instance;

      await database.collection("produtos").doc().set(produto.toMap());

      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProdutosPage()));
    } else {
      setState(() {
        _msgErro =
            "Não foi possível completar o cadastro, preencha todos os campos marcados com *";
      });
    }
  }

  final _nomeController = TextEditingController();
  final _fornecedorController = TextEditingController();
  final _codigoController = TextEditingController();
  final _valorController = TextEditingController();
  final _mensalidadeController = TextEditingController();
  final _dataCompraController = TextEditingController(
      text: formatDate(DateTime.now(), [dd, "/", mm, "/", yyyy]));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 1, 3, 112),
          title: const Text(
            "Cadastro de Produto",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Dados com * são obrigatórios *",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  maxLength: 42,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: _nomeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Este campo não pode ser vazio";
                    }
                    return null;
                  },
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Nome *",
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
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _fornecedorController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Este campo não pode ser vazio";
                          }
                          return null;
                        },
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 16, 12, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Fornecedor *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _codigoController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Este campo não pode ser vazio";
                          }
                          return null;
                        },
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Código *",
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
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(),
                        ],
                        controller: _valorController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 8, 20, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Valor Compra *",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CentavosInputFormatter(),
                        ],
                        controller: _mensalidadeController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 8, 20, 16),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Valor Mensalidade *",
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
                padding: const EdgeInsets.fromLTRB(100, 15, 100, 10),
                child: DateTimePicker(
                  controller: _dataCompraController,
                  dateMask: "dd/MM/yyyy",
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2300),
                  onFieldSubmitted: (date) {
                    setState(() {
                      _dataCompraController.text = date;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.date_range_outlined),
                    contentPadding: const EdgeInsets.fromLTRB(32, 8, 20, 16),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Data da Compra",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: _msgErro == ""
                    ? Container()
                    : Text(
                        _msgErro,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 40),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 4, 6, 107),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  onPressed: () => _cadastroProduto(),
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
        ));
  }
}
