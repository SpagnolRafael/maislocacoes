import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_locacoes/View/BottomAppBar/cliente_page.dart';
import 'package:mais_locacoes/View/BottomAppBar/locacoes_page.dart';
import 'package:mais_locacoes/View/TabBar/contratosVencidos.dart';
import 'package:mais_locacoes/View/TabBar/graficos.dart';
import 'package:mais_locacoes/View/login.dart';
import 'package:mais_locacoes/View/TabBar/mesVencidos.dart';

import '../TabBar/perdidas.dart';
import 'produtos_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  _logOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();

    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  TabController? _tabController;
  var _indiceAtual = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          // leading: Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.menu),
          //   ),
          // ),
          backgroundColor: const Color.fromARGB(218, 1, 3, 112),
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 300,
              width: 100,
              child: Image.asset(
                "assets/images/logo_gml_appbar_branco.png",
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.logout_outlined),
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
                          title: const Text(
                            "Deseja desconectar sua conta?",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                _logOut();
                              },
                              child: const Text(
                                "SIM",
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
                                "NÃO",
                                style: TextStyle(
                                  color: Colors.red,
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
              ),
            ),
          ],
          bottom: TabBar(
            indicatorWeight: 8,
            indicatorColor: Colors.orange,
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(
                  Icons.info_outlined,
                ),
                text: "Resumos",
              ),
              Tab(
                icon: Icon(
                  Icons.local_atm,
                ),
                text: "Vencidos",
              ),
              Tab(
                icon: Icon(Icons.cached),
                text: "Encerrados",
              ),
              Tab(
                icon: Icon(Icons.account_balance_wallet_outlined),
                text: "Perdidas",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            GraficosHome(),
            VencimentosMensais(),
            ContratosVencidos(),
            LocacoesPerdidas(),
          ],
          controller: _tabController,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          foregroundColor: const Color.fromARGB(255, 1, 3, 112),
          onPressed: () {},
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
        ));
  }
}
