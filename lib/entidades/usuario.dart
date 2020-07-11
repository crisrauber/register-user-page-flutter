import 'package:cadastro_usuario_growdev/entidades/endereco.dart';

class Usuario {
  String nome;
  String email;
  String cpf;

  String dados(String enderecoDados) {
    return '''
  Nome:
  ${this.nome}

  Email:
  ${this.email}

  CPF:
  ${this.cpf}

  Endereço:
  $enderecoDados
  ''';
  }
}
