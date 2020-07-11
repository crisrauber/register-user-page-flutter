import 'package:dio/dio.dart';

class Endereco {
  int cep;
  String rua;
  int numero;
  String bairro;
  String cidade;
  String uf;
  String pais;

  String dados() {
    return '''Rua ${this.rua}, ${this.numero}, Bairro ${this.bairro}, ${this.cidade} - ${this.uf}, ${this.pais}''';
  }
}
