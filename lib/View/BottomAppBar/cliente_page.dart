import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mais_locacoes/Model/cliente.dart';
import 'package:mais_locacoes/View/BottomAppBar/locacoes_page.dart';
import 'package:mais_locacoes/View/Forms/formPF.dart';
import 'package:mais_locacoes/View/Forms/formPJ.dart';
import 'package:mais_locacoes/View/BottomAppBar/home_page.dart';
import 'package:mais_locacoes/View/Profiles/profile_pf.dart';
import 'package:mais_locacoes/View/Profiles/profile_pj.dart';
import 'produtos_page.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({Key? key}) : super(key: key);

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  var _indiceAtual = 1;

  Future<List> recuperarClientes() async {
    FirebaseFirestore database = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await database
        .collection("clientes")
        .where("excluido", isEqualTo: false)
        .orderBy("nome")
        .get();
    List listaClientes = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data() as Map<String, dynamic>;

      Cliente cliente = Cliente(
        id: dados["id"],
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

      listaClientes.add(cliente);
    }
    return listaClientes;
  }

  List listaItens = [];

  @override
  void initState() {
    super.initState();
    recuperarClientes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 3, 112),
        title: const Text(
          "Clientes",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  10, //LEFT
                  10, //TOP
                  20, //RIGHT
                  10, //BOT
                ),
                child: Icon(Icons.filter_alt),
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: recuperarClientes(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  listaItens = snapshot.data!;
                  Cliente cliente = listaItens[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: cliente.rate == true
                          ? Colors.redAccent
                          : Colors.white,
                      borderOnForeground: true,
                      elevation: 3,
                      child: SingleChildScrollView(
                        child: ListTile(
                          onTap: () {
                            cliente.cnpj == null
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfilePF(cliente)))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfilePJ(cliente)));
                          },
                          title: Wrap(
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(Icons.account_circle_outlined),
                                  ),
                                  Text(cliente.nome!)
                                ],
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(Icons.phone),
                                  ),
                                  Text(cliente.contato1!),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Wrap(
                            children: [
                              Wrap(
                                children: [
                                  cliente.razaoSocial == null
                                      ? Wrap(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 6),
                                              child: Icon(Icons.mail_outline),
                                            ),
                                            Text(cliente.email!),
                                          ],
                                        )
                                      : Wrap(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 6),
                                              child: Icon(Icons
                                                  .business_center_outlined),
                                            ),
                                            Text(cliente.razaoSocial!),
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 6),
                                                  child:
                                                      Icon(Icons.mail_outline),
                                                ),
                                                Text(cliente.email!),
                                              ],
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 1, 3, 112),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  title: const Text("Selecione o Tipo de Cadastro"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FormularioPF()));
                      },
                      child: const Text(
                        "PESSOA FÍSICA",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Fechar",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        )),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FormularioPJ()));
                      },
                      child: const Text(
                        "PESSOA JURÍDICA",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: const Color.fromARGB(255, 1, 3, 112),
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: const TextStyle(color: Colors.yellow))),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.white,
          currentIndex: _indiceAtual,
          onTap: (indice) {
            setState(() {
              _indiceAtual = indice;
              if (_indiceAtual == 0) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              } else if (_indiceAtual == 2) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocacaoPage()));
              } else if (_indiceAtual == 3) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProdutosPage()));
              }
            });
          },
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.orange,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Cliente",
              icon: Icon(Icons.account_circle_outlined),
            ),
            BottomNavigationBarItem(
              label: "Locação",
              icon: Icon(Icons.social_distance_sharp),
            ),
            BottomNavigationBarItem(
              label: "Produtos",
              icon: Icon(Icons.folder),
            ),
          ],
        ),
      ),
    );
  }
}
