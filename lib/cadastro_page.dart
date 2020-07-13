import 'dart:math';

import 'package:cadastro_usuario_growdev/entidades/endereco.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:cnpj_cpf_formatter/cnpj_cpf_formatter.dart';

import 'entidades/usuario.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final ufController = TextEditingController();
  final paisController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();

  final usuario = Usuario();
  final endereco = Endereco();

  String gravatar =
      'https://www.gravatar.com/avatar/${md5.convert(utf8.encode('${Random.secure().nextInt(10000).toString()}'))}?d=robohash';

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    cpfController.dispose();
    cepController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    ufController.dispose();
    paisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 66, 53, 1),
        title: Text('Cadastro de Usuário'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            autovalidate: true,
            key: _form,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(gravatar),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(244, 66, 53, 1)),
                    ),
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(244, 66, 53, 1)),
                    labelText: 'Nome completo',
                  ),
                  controller: nomeController,
                  validator: (valor) {
                    if (valor.length < 3) return 'Nome muito curto';
                    if (valor.length > 30) return 'Nome muito longo';
                    return null;
                  },
                  onSaved: (valor) {
                    usuario.nome = valor;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(244, 66, 53, 1)),
                    ),
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(244, 66, 53, 1)),
                    labelText: 'Email',
                  ),
                  controller: emailController,
                  validator: (valor) {
                    if (!EmailValidator.validate(valor)) {
                      return 'Email invalido';
                    } else {
                      gravatar =
                          'https://www.gravatar.com/avatar/${md5.convert(utf8.encode('$valor'))}';
                    }

                    return null;
                  },
                  onSaved: (valor) {
                    usuario.email = valor;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(244, 66, 53, 1)),
                    ),
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(244, 66, 53, 1)),
                    labelText: 'CPF',
                  ),
                  inputFormatters: [
                    CnpjCpfFormatter(
                      eDocumentType: EDocumentType.CPF,
                    )
                  ],
                  keyboardType: TextInputType.number,
                  controller: cpfController,
                  validator: (valor) {
                    if (!CnpjCpfBase.isCpfValid(valor)) return 'CPF invalido.';

                    return null;
                  },
                  onSaved: (valor) {
                    usuario.cpf = CnpjCpfBase.maskCpf(valor);
                  },
                ),
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(244, 66, 53, 1)),
                            ),
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(244, 66, 53, 1)),
                            labelText: 'CEP',
                          ),
                          keyboardType: TextInputType.number,
                          controller: cepController,
                          validator: (valor) {
                            if (valor.length != 8) {
                              return 'CEP invalido';
                            }

                            return null;
                          },
                          onSaved: (valor) {
                            endereco.cep = int.tryParse(valor);
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: RaisedButton(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.search),
                                Text('Buscar Cep'),
                              ],
                            ),
                            onPressed: () async {
                              try {
                                if (cepController.text.length != 8) {
                                  throw Error();
                                } else {
                                  Response<String> dados = await Dio().get(
                                      'https://viacep.com.br/ws/${cepController.text}/json/');

                                  Map<String, dynamic> procura =
                                      jsonDecode(dados.toString());

                                  ruaController.text = procura['logradouro'];
                                  bairroController.text = procura['bairro'];
                                  ufController.text = procura['uf'];
                                  cidadeController.text = procura['localidade'];
                                  paisController.text = 'Brasil';
                                }
                              } catch (e) {
                                _scaffoldKey.currentState
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      duration: Duration(
                                        seconds: 2,
                                      ),
                                      content: Text('CEP incorreto!'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          Color.fromRGBO(244, 66, 53, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  );
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(244, 66, 53, 1)),
                            ),
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(244, 66, 53, 1)),
                            labelText: 'Rua',
                          ),
                          controller: ruaController,
                          validator: (valor) {
                            if (valor.length < 3) return 'Rua muito curta';
                            if (valor.length > 30) return 'Rua muito longa';
                            return null;
                          },
                          onSaved: (valor) {
                            endereco.rua = valor;
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(244, 66, 53, 1)),
                              ),
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(244, 66, 53, 1)),
                              labelText: 'Numero',
                            ),
                            keyboardType: TextInputType.number,
                            controller: numeroController,
                            validator: (valor) {
                              if ((int.tryParse(valor) ?? 0) <= 0)
                                return 'Somente numeros';
                              return null;
                            },
                            onSaved: (valor) {
                              endereco.numero = int.tryParse(valor);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(244, 66, 53, 1)),
                            ),
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(244, 66, 53, 1)),
                            labelText: 'Bairro',
                          ),
                          controller: bairroController,
                          validator: (valor) {
                            if (valor.length < 3) return 'Bairro muito curto';
                            if (valor.length > 30) return 'Bairro muito longo';
                            return null;
                          },
                          onSaved: (valor) {
                            endereco.bairro = valor;
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(244, 66, 53, 1)),
                              ),
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(244, 66, 53, 1)),
                              labelText: 'Cidade',
                            ),
                            controller: cidadeController,
                            validator: (valor) {
                              if (valor.length < 3) return 'Cidade muito curta';
                              if (valor.length > 30)
                                return 'Cidade muito longa';
                              return null;
                            },
                            onSaved: (valor) {
                              endereco.cidade = valor;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(244, 66, 53, 1)),
                            ),
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(244, 66, 53, 1)),
                            labelText: 'UF',
                          ),
                          controller: ufController,
                          validator: (valor) {
                            if (valor.length != 2) return 'UF invalido';
                            return null;
                          },
                          onSaved: (valor) {
                            endereco.uf = valor;
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(244, 66, 53, 1)),
                              ),
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(244, 66, 53, 1)),
                              labelText: 'País',
                            ),
                            controller: paisController,
                            validator: (valor) {
                              if (valor.toLowerCase() != 'brasil')
                                return 'País invalido';
                              return null;
                            },
                            onSaved: (valor) {
                              endereco.pais = valor;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: CleanButtom(
                          () {
                            setState(() {
                              nomeController.clear();
                              emailController.clear();
                              cpfController.clear();
                              cepController.clear();
                              ruaController.clear();
                              numeroController.clear();
                              bairroController.clear();
                              cidadeController.clear();
                              ufController.clear();
                              paisController.clear();
                            });
                            _scaffoldKey.currentState
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                  content: Text('Dados Limpos!'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      Color.fromRGBO(244, 66, 53, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: SaveButton(
                            () {
                              if (_form.currentState.validate()) {
                                setState(() {
                                  _form.currentState.save();
                                });
                                _scaffoldKey.currentState
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      duration: Duration(
                                        seconds: 2,
                                      ),
                                      content:
                                          Text('Dados Salvos Com Sucesso!'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          Color.fromRGBO(244, 66, 53, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  );
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (ctx) {
                                    return Column(
                                      children: <Widget>[
                                        AlertDialog(
                                          title: Text(
                                            'Dados: ${usuario.nome}',
                                          ),
                                          content: Column(
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 50.0,
                                                backgroundColor: Colors.blue,
                                                backgroundImage:
                                                    NetworkImage(gravatar),
                                              ),
                                              Text(usuario
                                                  .dados(endereco.dados())),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Ok'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                _scaffoldKey.currentState
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      duration: Duration(
                                        seconds: 2,
                                      ),
                                      content: Text('Dados incorretos!'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          Color.fromRGBO(244, 66, 53, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final void Function() onPressed;

  SaveButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () {
        /* Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('usuário salvo'),
          ),
        ); */
        onPressed();
      },
      child: Text(
        'Salvar',
        style: TextStyle(fontSize: 18),
      ),
      textColor: Color.fromRGBO(244, 66, 53, 1),
      borderSide: BorderSide(
        color: Color.fromRGBO(244, 66, 53, 1),
      ),
    );
  }
}

class CleanButtom extends StatelessWidget {
  final void Function() onPressed;

  CleanButtom(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () {
        onPressed();
      },
      child: Text(
        'Limpar',
        style: TextStyle(fontSize: 18),
      ),
      textColor: Color.fromRGBO(244, 66, 53, 1),
      borderSide: BorderSide(
        color: Color.fromRGBO(244, 66, 53, 1),
      ),
    );
  }
}
