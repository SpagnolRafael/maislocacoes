// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names

import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mais_locacoes/cadastros/clientes/cliente.dart';
import 'package:mais_locacoes/pages/cliente_page.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ProfilePF extends StatefulWidget {
  Cliente cliente;
  ProfilePF(this.cliente);

  @override
  _ProfilePFState createState() => _ProfilePFState();
}

class _ProfilePFState extends State<ProfilePF> {
  late TextEditingController _nomeController;
  late TextEditingController _cpfController;
  late TextEditingController _rgController;
  late TextEditingController _cepController;
  late TextEditingController _complementoController;
  late TextEditingController _emailController;
  late TextEditingController _logradouroController;
  late TextEditingController _numeroController;
  late TextEditingController _bairroController;
  late TextEditingController _cidadeController;
  late TextEditingController _estadoController;
  late TextEditingController _contato1Controller;
  late TextEditingController _contato2Controller;
  late TextEditingController _obsController;

  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? _imagem;
  bool _subindoImagem = false;
  String _urlImagemRecuperada = "";

  _atualizarURLimagemFirestore(String url) async {
    FirebaseFirestore database = FirebaseFirestore.instance;
    await database
        .collection("clientes")
        .doc(widget.cliente.id)
        .update({"urlImagem": url});
  }

  Future _recuperarURLimagem(TaskSnapshot taskSnapshot) async {
    String url = await taskSnapshot.ref.getDownloadURL();
    _atualizarURLimagemFirestore(url);
    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  Future _uploadImagem() async {
    File file = File(_imagem!.path);
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("fotoCliente")
        .child(DateTime.now().toString() + ".jpg");

    UploadTask task = arquivo.putFile(file);

    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      if (storageEvent.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });
    task.then((TaskSnapshot taskSnapshot) => _recuperarURLimagem(taskSnapshot));
  }

  Future _recuperarImagem(String origemImagem) async {
    final ImagePicker _picker = ImagePicker();
    XFile? imagemSelecionada;
    if (origemImagem == "camera") {
      imagemSelecionada = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _imagem = imagemSelecionada;
        if (_imagem != null) {
          _uploadImagem();
          _subindoImagem = true;
        }
      });
    } else if (origemImagem == "galeria") {
      imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imagem = imagemSelecionada;
        if (_imagem != null) {
          _uploadImagem();
          _subindoImagem = true;
        }
      });
    }
  }

  Future _recuperarImagemFirestore() async {
    FirebaseFirestore database = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        (await database.collection("clientes").doc(widget.cliente.id).get());
    var urlImgRecuperada = snapshot.data();
    setState(() {
      _urlImagemRecuperada = "${(urlImgRecuperada as dynamic)["urlImagem"]}";
    });
  }

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.cliente.nome);
    _cpfController = TextEditingController(text: widget.cliente.cpf);
    _rgController = TextEditingController(text: widget.cliente.rg);
    _cepController = TextEditingController(text: widget.cliente.cep);
    _complementoController =
        TextEditingController(text: widget.cliente.complemento);
    _emailController = TextEditingController(text: widget.cliente.email);
    _logradouroController =
        TextEditingController(text: widget.cliente.logradouro);
    _numeroController = TextEditingController(text: widget.cliente.numero);
    _bairroController = TextEditingController(text: widget.cliente.bairro);
    _cidadeController = TextEditingController(text: widget.cliente.cidade);
    _estadoController = TextEditingController(text: widget.cliente.estado);
    _contato1Controller = TextEditingController(text: widget.cliente.contato1);
    _contato2Controller = TextEditingController(text: widget.cliente.contato2);
    _obsController = TextEditingController(text: widget.cliente.observacao);
    _recuperarImagemFirestore();
  }

  @override
  Widget build(BuildContext context) {
    bool clienteProblema = widget.cliente.rate!;

    Timestamp timeStamp = widget.cliente.dataCadastro;
    var date =
        DateTime.fromMicrosecondsSinceEpoch(timeStamp.microsecondsSinceEpoch);
    String dateFormat = DateFormat("dd/MM/yyyy").format(date);

    _alterarDados() {
      String nome = _nomeController.text;
      String cpf = _cpfController.text;
      String rg = _rgController.text;
      String logradouro = _logradouroController.text;
      String numero = _numeroController.text;
      String complemento = _complementoController.text;
      String bairro = _bairroController.text;
      String cep = _cepController.text;
      String cidade = _cidadeController.text;
      String estado = _estadoController.text;
      String contato1 = _contato1Controller.text;
      String contato2 = _contato2Controller.text;
      String email = _emailController.text;
      String observacao = _obsController.text;
      String? id = widget.cliente.id;
      FirebaseFirestore database = FirebaseFirestore.instance;
      database.collection("clientes").doc(widget.cliente.id).update({
        "id": id,
        "nome": nome,
        "cpf": cpf,
        "rg": rg,
        "contato1": contato1,
        "contato2": contato2,
        "email": email,
        "logradouro": logradouro,
        "numero": numero,
        "complemento": complemento,
        "cep": cep,
        "bairro": bairro,
        "cidade": cidade,
        "estado": estado,
        "observacao": observacao,
      }).then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ClientePage()));
      });
      setState(() {});
    }

    var FormPF = SingleChildScrollView(
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
              autocorrect: false,
              autofocus: false,
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
                      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
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
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
                    setState(() {
                      _alterarDados();
                    });
                  },
                  label: const Text(
                    "Atualizar",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 40),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.close),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 224, 0, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  onPressed: () {
                    setState(() {
                      FirebaseFirestore database = FirebaseFirestore.instance;
                      database
                          .collection("clientes")
                          .doc(widget.cliente.id)
                          .update({
                        "excluido": true,
                      }).then((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ClientePage())));
                      setState(() {});
                    });
                  },
                  label: const Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de ${widget.cliente.nome}"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 70,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(_urlImagemRecuperada),
                    ),
                    _subindoImagem == true
                        ? const CircularProgressIndicator()
                        : Container(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _recuperarImagem("camera"),
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _recuperarImagem("galeria"),
                          icon: const Icon(Icons.image),
                        ),
                      ],
                    ),
                    Row(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 3),
                child: TextFormField(
                  controller: _obsController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Observação Interna",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Data de Cadastro: $dateFormat",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Cliente Problematico",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Switch(
                      value: clienteProblema,
                      onChanged: (bool valor) {
                        setState(() {
                          clienteProblema = valor;
                        });
                        FirebaseFirestore database = FirebaseFirestore.instance;
                        database
                            .collection("clientes")
                            .doc(widget.cliente.id)
                            .update({"rate": clienteProblema}).then((value) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ClientePage()));
                        });
                      },
                    ),
                  ],
                ),
              ),
              FormPF,
            ],
          ),
        ),
      ),
    );
  }
}
