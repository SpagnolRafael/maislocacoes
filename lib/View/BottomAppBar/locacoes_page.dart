import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mais_locacoes/Model/locacoes.dart';
import 'package:mais_locacoes/View/BottomAppBar/cliente_page.dart';
import 'package:mais_locacoes/View/BottomAppBar/produtos_page.dart';
import 'package:mais_locacoes/View/Forms/form_locacoes.dart';
import 'package:mais_locacoes/View/BottomAppBar/home_page.dart';
import 'package:intl/intl.dart';
import 'package:mais_locacoes/View/Profiles/profile_locacao.dart';

class LocacaoPage extends StatefulWidget {
  const LocacaoPage({Key? key}) : super(key: key);

  @override
  _LocacaoPageState createState() => _LocacaoPageState();
}

class _LocacaoPageState extends State<LocacaoPage> {
  var _indiceAtual = 2;

  Future<List> _getLocacao() async {
    FirebaseFirestore database = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await database
        .collection("locacao")
        .where("statusAtiva", isEqualTo: true)
        .orderBy("numeroContrato")
        .get();
    List listaLocacao = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      var json = item.data() as Map<String, dynamic>;
      Locacao locacao = Locacao.fromJson(json);

      listaLocacao.add(locacao);
    }
    return listaLocacao;
  }

  List listaItens = [];

  @override
  void initState() {
    super.initState();
    _getLocacao();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 1, 3, 112),
          title: const Text(
            "Lista de Locações",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.filter_alt),
                ),
              ],
            )
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _getLocacao(),
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
                    Locacao locacao = listaItens[index];

                    Timestamp timeStampInitial = locacao.dataInicial;
                    var date = DateTime.fromMicrosecondsSinceEpoch(
                        timeStampInitial.microsecondsSinceEpoch);
                    String dateInitialFormat =
                        DateFormat("dd/MM/yyyy").format(date);

                    Timestamp timeStampDevolution = locacao.dataDevolucao;
                    var date2 = DateTime.fromMicrosecondsSinceEpoch(
                        timeStampDevolution.microsecondsSinceEpoch);
                    String dateDevolutionFormat =
                        DateFormat("dd/MM/yyyy").format(date2);

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        borderOnForeground: true,
                        elevation: 3,
                        child: SingleChildScrollView(
                          child: ListTile(
                            leading: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 60.0, maxWidth: 70),
                              height: double.infinity,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  locacao.numeroContrato.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 1, 3, 112)),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileLocacao(locacao)));
                            },
                            title: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child:
                                            Icon(Icons.account_circle_outlined),
                                      ),
                                      Text(locacao.cliente.nome.toString())
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(Icons.calendar_month),
                                      ),
                                      Text("Inicio: " + dateInitialFormat),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(3, 3, 3, 0),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(Icons.calendar_month),
                                      ),
                                      Text("Fim: " + dateDevolutionFormat),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: SizedBox(
                              height: 38,
                              width: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Icon(Icons.apps_sharp),
                                      ),
                                      ...locacao.produtos
                                          .map(
                                            (e) => Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: GestureDetector(
                                                          onTap: () {},
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                e.produto.codigo
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ],
                                  ),
                                ],
                              ),
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
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          foregroundColor: const Color.fromARGB(255, 1, 3, 112),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FormLocacoes()));
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
                if (_indiceAtual == 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClientePage()));
                } else if (_indiceAtual == 0) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
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
        ));
  }
}
