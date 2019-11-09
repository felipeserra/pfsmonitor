import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pfsmonitor/appurl.dart';
import 'package:pfsmonitor/bloc/Repository.dart';
import 'package:pfsmonitor/componets/ListViewEffect.dart';
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  final dbHelper = DatabaseHelper.instance;
  List<StatItem> _list = List<StatItem>();
  List<String> _protocolos = <String>['http', 'https'];
  String _protocolo = 'http';
  void _inserir(Item item) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnNome: item.name,
      DatabaseHelper.columnUrl: item.url,
      DatabaseHelper.columnProtocolo: item.protocolo,
    };
    final id = await dbHelper.insert(row);
    print('linha inserida id: $id');
  }

  Future _popularItens() async {
    var listaItem = List<Item>();
    var item = new Item(listaItem.length + 1,
        name: "PDPoint - HTTP",
        url: "http://www.pdpoint.com.br",
        protocolo: "http");
    listaItem.add(item);
    item = new Item(listaItem.length + 1,
        name: "PDPoint - HTTPS",
        url: "https://www.pdpoint.com.br",
        protocolo: "https");
    listaItem.add(item);
    item = new Item(listaItem.length + 1,
        name: "Enzimais - HTTPS",
        url: "https://www.enzimais.com.br",
        protocolo: "https");
    listaItem.add(item);
    item = new Item(listaItem.length + 1,
        name: "Enzimais - HTTP",
        url: "http://www.enzimais.com.br",
        protocolo: "http");
    listaItem.add(item);
    item = new Item(listaItem.length + 1,
        name: "PSPReports - HTTPS",
        url: "https://www.pspreports.com.br",
        protocolo: "https");
    listaItem.add(item);
    item = new Item(listaItem.length + 1,
        name: "PSPReports - HTTP",
        url: "http://www.pspreports.com.br",
        protocolo: "http");
    listaItem.add(item);
    item = new Item(listaItem.length + 1,
        name: "Gestão Externos - HTTP",
        url: "http://essencial.integramedical.com.br",
        protocolo: "http");
    listaItem.add(item);
    item = new Item(listaItem.length + 1,
        name: "Programa Entre Nós - HTTP",
        url: "http://programaentrenos.suporteaopaciente.com.br/",
        protocolo: "http");
    listaItem.add(item);
    listaItem.forEach((value) async => _inserir(value));
  }

  Future _consultar() async {
    _list.clear();
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) async => {
          await getStatus(row['url']).then((retorno) {
            setState(() {
              var item = new Item(row['id'],
                  name: row['nome'],
                  url: row['url'],
                  status: retorno,
                  statuscolor: retorno ? Colors.green : Colors.red);
              _list.add(StatItem(item: item));
            });
          })
        });
    BotToast.closeAllLoading();
  }

  void _deletar(Item item) async {
    final id = await dbHelper.queryRowCount();
    if (id > 0) {
      final linhaDeletada = await dbHelper.delete(item.id);
      print('Deletada(s) $linhaDeletada linha(s): linha $id');
    }
  }

  Future<bool> getStatus(String url) async {
    try {
      final response = await http.get(url);
      return (response.statusCode == 200);
    } catch (e) {
      return false;
    }
  }

  Future inicio() async {
    BotToast.showLoading();
    final id = await dbHelper.queryRowCount();
    if (id <= 0) {
      await _popularItens().then((onValue) => _consultar());
    } else {
      await _consultar();
    }
  }

  @override
  void initState() {
    inicio();
    super.initState();
    Timer.periodic(Duration(minutes: 15), (timer) {
      inicio();
    });
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerUrl = TextEditingController();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Duration _duration = Duration(milliseconds: 300);
  _addItem() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        isFocused: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.insert_link),
                          labelText: 'Protocolo',
                        ),
                        isEmpty: _protocolo == 'http',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            value: _protocolo,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _protocolo = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _protocolos.map((String value) {
                              return new DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  TextFormField(
                    controller: controllerNome,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.web_asset),
                        hasFloatingPlaceholder: true,
                        labelText: 'Nome do APP',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: Colors.red)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Informe o nome do APP';
                      }
                    },
                  ),
                  TextFormField(
                    controller: controllerUrl,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.link),
                        hasFloatingPlaceholder: true,
                        labelText: 'Url do APP',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, color: Colors.red)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Informe a url do APP';
                      }
                      var url = '${_protocolo}://' +
                          value
                              .replaceAll("http://", "")
                              .replaceAll("https://", "");
                      print(url);
                      if (!isURL(url, requireProtocol: true)) {
                        return 'Informe url corretamente';
                      }
                    },
                  ),
                  RaisedButton(
                    color: Colors.blueGrey,
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        var name = controllerNome.text;
                        var url = '${_protocolo}://' +
                            controllerUrl.text
                                .replaceAll("http://", "")
                                .replaceAll("https://", "");
                        print(
                            'A Url: ${controllerUrl.text} isUrl: ${isURL(url, requireProtocol: true)}');
                        var texto = 'Validando à Url: ${url}';
                        BotToast.showLoading();
                        getStatus(url).then((retorno) {
                          setState(() {
                            var itemList = new Item(_list.length + 1,
                                name: name + " - " + _protocolo.toUpperCase(),
                                url: url,
                                status: retorno,
                                statuscolor:
                                    retorno ? Colors.green : Colors.red);
                            _inserir(itemList);
                            _list.add(StatItem(item: itemList));
                            texto =
                                'Url: ${url} ${retorno ? "on-line" : "off-line"}';
                            BotToast.closeAllLoading();
                            BotToast.showText(text: texto);
                          });
                        });
                        Navigator.of(context).pop();
                        controllerNome.text = "";
                        controllerUrl.text = "";
                        _formKey.currentState.save();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _removeItem() {
    setState(() {
      var idx = _list.length - 1;
      if (idx >= 0) {
        print(idx);
        _deletar(_list[idx].item);
        _list.removeAt(idx);
      }
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Image.asset("images/logo.png"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _removeItem,
          )
        ],
      ),
      body: new Container(
          child: new Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              child: new ListViewEffect(
                  duration: _duration,
                  children:
                      _list.map((s) => _buildWidgetExample(s)).toList()))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _consultar();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildWidgetExample(StatItem statitem) {
    setState(() {
      getStatus(statitem.item.url).then((retorno) {
        statitem.item.status = retorno;
        statitem.item.statuscolor = retorno ? Colors.green : Colors.red;
      });
    });
    return statitem;
  }
}
