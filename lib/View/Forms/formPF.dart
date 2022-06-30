// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:mais_locacoes/Model/cliente.dart';
import 'package:mais_locacoes/View/BottomAppBar/cliente_page.dart';

class FormularioPF extends StatefulWidget {
  const FormularioPF({Key? key}) : super(key: key);

  @override
  _FormularioPFState createState() => _FormularioPFState();
}

class _FormularioPFState extends State<FormularioPF> {
  var _msgErro = "";
  _cadastroClientePF() async {
    if (_nomeController.text != "") {
      String nome = _nomeController.text;
      String cpf = _cpfController.text;
      String rg = _rgController.text;
      String email = _emailController.text;
      String contato1 = _contato1Controller.text;
      String contato2 = _contato2Controller.text;
      String cep = _cepController.text;
      String logradouro = _logradouroController.text;
      String numero = _numeroController.text;
      String complemento = _complementoController.text;
      String bairro = _bairroController.text;
      String cidade = _cidadeController.text;
      String estado = _estadoController.text;

      Cliente cliente = Cliente(
        nome: nome,
        cpf: cpf,
        rg: rg,
        contato1: contato1,
        contato2: contato2,
        email: email,
        logradouro: logradouro,
        numero: numero,
        bairro: bairro,
        complemento: complemento,
        cep: cep,
        cidade: cidade,
        estado: estado,
        dataCadastro: Timestamp.now(),
        excluido: false,
        rate: false,
      );

      _nomeController.text = "";
      _cpfController.text = "";
      _rgController.text = "";
      _emailController.text = "";
      _contato1Controller.text = "";
      _contato2Controller.text = "";
      _cepController.text = "";
      _logradouroController.text = "";
      _numeroController.text = "";
      _complementoController.text = "";
      _bairroController.text = "";
      _cidadeController.text = "";
      _estadoController.text = "";

      FirebaseFirestore database = FirebaseFirestore.instance;

      CollectionReference toolsCollectionRef =
          FirebaseFirestore.instance.collection("clientes");
      String newDocID = toolsCollectionRef.doc().id;
      await database.collection("clientes").doc(newDocID).set({
        ...cliente.toJson(),
        "id": newDocID,
      });
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ClientePage()));
    } else {
      setState(() {
        _msgErro =
            "Não foi possível completar o cadastro, preencha todos os campos marcados com *";
      });
    }
  }

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _rgController = TextEditingController();
  final _cepController = TextEditingController();
  final _complementoController = TextEditingController();
  final _emailController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _contato2Controller = TextEditingController();
  final _contato1Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 3, 112),
        title: const Text(
          "Cadastro de Clientes PF",
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
                  contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
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
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                      controller: _cpfController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "CPF *",
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
                      controller: _rgController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "RG",
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
                        TelefoneInputFormatter(),
                      ],
                      controller: _contato1Controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Telefone 1 *",
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      controller: _contato2Controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(15, 16, 15, 16),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Telefone 2",
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
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                controller: _emailController,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "E-mail",
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
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
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
                    padding: const EdgeInsets.all(15),
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
              padding: const EdgeInsets.all(15),
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
                    padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
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
                    padding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
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
                    padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
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
                    padding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
                    child: TextFormField(
                      controller: _estadoController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Estado *",
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
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 40),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 4, 6, 107),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                onPressed: () {
                  _cadastroClientePF();
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
    );
  }
}
