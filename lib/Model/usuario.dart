// ignore_for_file: unnecessary_this

class Usuario {
  String? _email;
  String? _senha;

  get email => _email;

  set email(value) => this._email = value;

  get senha => this._senha;

  set senha(value) => this._senha = value;
  String? razaoSocial;
  String? cnpj;
  String? inscricaoEstadual;
  String? logradouro;
  String? numero;
  String? cep;
  String? bairro;
  String? cidade;
  String? estado;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "razaoSocial": razaoSocial,
      "email": email,
      "cnpj": cnpj,
      "inscricaoEstadual": inscricaoEstadual,
      "logradouro": logradouro,
      "numero": numero,
      "cep": cep,
      "bairro": bairro,
      "cidade": cidade,
      "estado": estado,
    };
    return map;
  }
}
