import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_locacoes/pages/home_page.dart';
import 'package:mais_locacoes/usuario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _msgErro = "";
  var _iconType = const Icon(Icons.remove_red_eye_outlined);
  var _secureText = true;
  final TextEditingController _emailController =
      TextEditingController(text: "rafa_spagnol@hotmail.com");
  final TextEditingController _senhaController =
      TextEditingController(text: "881039");

  _validarDados() {
    String email = _emailController.text;
    String senha = _senhaController.text;

    if (email.isNotEmpty) {
      if (senha.isNotEmpty) {
        setState(() {
          _msgErro = "";
          Usuario usuario = Usuario();
          usuario.email = email;
          usuario.senha = senha;
          _loginUsuario(usuario);
        });
      } else {
        setState(() {
          _msgErro = "Digite sua Senha";
        });
      }
    } else {
      setState(() {
        _msgErro = "Por Favor digite o seu email de forma válida";
      });
    }
  }

  _loginUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
      email: usuario.email,
      password: usuario.senha,
    )
        .then((firebaseUser) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    }).catchError((error) {
      setState(() {
        _msgErro = "Erro ao autenticar usuário, verifique e-mail e senha.";
      });
    });
  }

  var carregando = false;
  Future _autoLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = auth.currentUser!;
    // ignore: unnecessary_null_comparison
    if (usuarioLogado != null) {}
    setState(() async {
      carregando = true;
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    });
  }

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(3, 7, 247, 0.747),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child:
                      Image.asset("assets/images/logo_gml_appbar_branco.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _emailController,
                    autofocus: true,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "e-mail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _senhaController,
                    keyboardType: TextInputType.number,
                    obscureText: _secureText,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _secureText = !_secureText;
                          if (_secureText == false) {
                            setState(() {
                              _iconType =
                                  const Icon(Icons.remove_red_eye_sharp);
                            });
                          } else {
                            setState(() {
                              _iconType =
                                  const Icon(Icons.remove_red_eye_outlined);
                            });
                          }
                        },
                        icon: _iconType,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "senha",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: carregando == true
                      ? const CircularProgressIndicator()
                      : Container(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              carregando = true;
                            });
                            _validarDados();
                          },
                          child: const Text(
                            "Entrar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            primary: const Color.fromARGB(255, 255, 0, 0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _msgErro,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
