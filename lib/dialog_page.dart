import 'package:flutter/material.dart';

enum ETipoAcao { SIM, NAO }

class DialogPage extends StatefulWidget {
  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  void _simpleDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text(
            'Simple dialog',
          ),
          children: <Widget>[
            Text(
              'Aqui a informação!',
            ),
          ],
        );
      },
    );
  }

  void _alertDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Alert dialog',
          ),
          content: Text(
            'Aqui mais um exemplo de uso do dialog, neste caso um alert dialog sem retorno.',
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Entendi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _alertDialogComRetorno() async {
    var escolha = await showDialog<ETipoAcao>(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Exclusão de registro',
          ),
          content: Text(
            'Deseja realmente excluir o registro?',
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('SIM'),
              onPressed: () {
                Navigator.of(context).pop(ETipoAcao.SIM);
              },
            ),
            FlatButton(
              child: Text('NÃO'),
              onPressed: () {
                Navigator.of(context).pop(ETipoAcao.NAO);
              },
            ),
          ],
        );
      },
    );

    if (escolha == ETipoAcao.SIM) {
      print('excluiu');
    } else {
      print('nao excluiu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Dialog page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: _simpleDialog,
              child: Text('Simple Dialog'),
            ),
            RaisedButton(
              onPressed: _alertDialog,
              child: Text('Alert Dialog (sem retorno)'),
            ),
            RaisedButton(
              onPressed: _alertDialogComRetorno,
              child: Text('Alert Dialog (com retorno)'),
            ),
          ],
        ),
      ),
    );
  }
}
