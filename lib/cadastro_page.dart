import 'package:cadastro_usuario_growdev/entidades/endereco.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cnpj_cpf_helper/cnpj_cpf_helper.dart';

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
        backgroundColor: Color.fromRGBO(102, 102, 153, 1),
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
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(102, 102, 153, 1)),
                    ),
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(102, 102, 153, 1)),
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
                          BorderSide(color: Color.fromRGBO(102, 102, 153, 1)),
                    ),
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(102, 102, 153, 1)),
                    labelText: 'Email',
                  ),
                  controller: emailController,
                  validator: (valor) {
                    if (!EmailValidator.validate(valor))
                      return 'Email invalido';
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
                          BorderSide(color: Color.fromRGBO(102, 102, 153, 1)),
                    ),
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(102, 102, 153, 1)),
                    labelText: 'CPF',
                  ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(102, 102, 153, 1)),
                            ),
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(102, 102, 153, 1)),
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
                            onPressed: () {
                              Navigator.of(context).pop();
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(102, 102, 153, 1)),
                            ),
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(102, 102, 153, 1)),
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
                                    color: Color.fromRGBO(102, 102, 153, 1)),
                              ),
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(102, 102, 153, 1)),
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
                                  color: Color.fromRGBO(102, 102, 153, 1)),
                            ),
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(102, 102, 153, 1)),
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
                                    color: Color.fromRGBO(102, 102, 153, 1)),
                              ),
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(102, 102, 153, 1)),
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
                                  color: Color.fromRGBO(102, 102, 153, 1)),
                            ),
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(102, 102, 153, 1)),
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
                                    color: Color.fromRGBO(102, 102, 153, 1)),
                              ),
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(102, 102, 153, 1)),
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
                  width: double.maxFinite,
                  child: TesteButtom(
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
                              content: Text('Dados Salvos Com Sucesso!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color.fromRGBO(102, 102, 153, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text(
                                'Dados: ${usuario.nome}',
                              ),
                              content: Text(usuario.dados(endereco.dados())),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
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

class TesteButtom extends StatelessWidget {
  final void Function() onPressed;

  TesteButtom(this.onPressed);

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
      textColor: Color.fromRGBO(102, 102, 153, 1),
      borderSide: BorderSide(
        color: Color.fromRGBO(102, 102, 153, 1),
      ),
    );
  }
}
