import 'package:flutter/material.dart';
import 'package:mais_locacoes/View/Forms/form_locacoes.dart';
import 'package:mais_locacoes/View/BottomAppBar/home_page.dart';

import '../View/cliente_page.dart';
import '../View/produtos_page.dart';

class Locacao extends StatefulWidget {
  const Locacao({Key? key}) : super(key: key);

  @override
  _LocacaoState createState() => _LocacaoState();
}

class _LocacaoState extends State<Locacao> {
  var _indiceAtual = 2;
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
        body: Container(),
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
