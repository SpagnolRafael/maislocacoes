class Cliente {
  String? razaoSocial;
  String? inscricaoEstadual;
  String? cnpj;
  String? nome;
  String? cpf;
  String? rg;
  String? logradouro;
  String? numero;
  String? complemento;
  String? bairro;
  String? cep;
  String? cidade;
  String? estado;
  String? contato1;
  String? contato2;
  String? email;
  String? urlImagem;
  String? id;
  // ignore: prefer_typing_uninitialized_variables
  var dataCadastro;
  bool? rate; //false para bom, true para ruim
  bool? excluido;
  String? observacao;
  Cliente({
    this.observacao,
    this.rate,
    this.excluido,
    this.dataCadastro,
    this.id,
    this.urlImagem,
    this.razaoSocial,
    this.cnpj,
    this.inscricaoEstadual,
    required this.nome,
    required this.cpf,
    required this.rg,
    required this.contato1,
    this.contato2,
    required this.email,
    required this.logradouro,
    this.numero,
    required this.bairro,
    required this.complemento,
    required this.cep,
    required this.cidade,
    required this.estado,
  });
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "urlImagem": urlImagem,
      "nome": nome,
      "cpf": cpf,
      "rg": rg,
      "razaoSocial": razaoSocial,
      "contato1": contato1,
      "contato2": contato2,
      "email": email,
      "cnpj": cnpj,
      "inscricaoEstadual": inscricaoEstadual,
      "logradouro": logradouro,
      "numero": numero,
      "complemento": complemento,
      "cep": cep,
      "bairro": bairro,
      "cidade": cidade,
      "estado": estado,
      "dataCadastro": dataCadastro,
      "excluido": false,
      "rate": false,
      "observacao": observacao,
    };
    return map;
  }
}
