import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mais_locacoes/cadastros/produtos/produto.dart';
import 'package:mais_locacoes/pages/home_page.dart';
import '../cadastros/produtos/form_produto.dart';
import 'cliente_page.dart';
import 'locacoes_page.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({Key? key}) : super(key: key);

  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  var _indiceAtual = 3;

  Future<List> _recuperarProdutos() async {
    FirebaseFirestore database = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await database
        .collection("produtos")
        .where("excluido", isEqualTo: false)
        .orderBy("codigo")
        .get();

    List listaProdutos = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data() as Map<String, dynamic>;
      var dadoID = item.id;

      Produto produto = Produto(
        dataCompra: dados["dataCompra"],
        nome: dados["nome"],
        codigo: dados["codigo"],
        valorCompra: dados["valorCompra"],
        mensalidade: dados["mensalidade"],
        id: dadoID,
        fornecedor: dados["fornecedor"],
        locado: dados["locado"],
      );
      listaProdutos.add(produto);
    }
    return listaProdutos;
  }

  List _listaItens = [];

  @override
  void initState() {
    super.initState();
    _recuperarProdutos();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 1, 3, 112),
          title: const Text(
            "Produtos",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.filter_alt),
                  ),
                ],
              ),
            )
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _recuperarProdutos(),
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
                      _listaItens = snapshot.data!;
                      Produto produto = _listaItens[index];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: SingleChildScrollView(
                            child: ListTile(
                              onTap: () {},
                              leading: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    produto.codigo!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Color.fromARGB(255, 1, 3, 112)),
                                  )),
                              title: Wrap(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(Icons.apps_sharp),
                                      ),
                                      Text(
                                        produto.nome!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              subtitle: Wrap(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(Icons.apartment_sharp),
                                          ),
                                          Text(
                                            produto.fornecedor!,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 6),
                                            child: produto.locado == true
                                                ? const Icon(
                                                    Icons
                                                        .power_settings_new_outlined,
                                                    color: Colors.green,
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .power_settings_new_outlined,
                                                  ),
                                          ),
                                          produto.locado == true
                                              ? const Text("Alugado")
                                              : const Text("Desalugado")
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
                    });
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          foregroundColor: const Color.fromARGB(255, 1, 3, 112),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FormProduto()));
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
                } else if (_indiceAtual == 2) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Locacao()));
                } else if (_indiceAtual == 0) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
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
