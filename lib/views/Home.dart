import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pfsmonitor/appurl.dart';
import 'package:pfsmonitor/componets/ListViewEffect.dart';
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  List<StatItem> _list = List<StatItem>();
  List<String> _protocolos = <String>['http', 'https'];
  String _protocolo = 'http';
  Future<bool> getStatus(String url) async {
    try {
      final response = await http.get(url);
      return (response.statusCode == 200);
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    getStatus("https://www.pdpoint.com.br/Account/Login").then((retorno) {
      setState(() {
        _list.add(StatItem(
            item: new Item(
                name: "PDPoint",
                url: "https://www.pdpoint.com.br/Account/Login",
                status: retorno,
                statuscolor: retorno ? Colors.green : Colors.red)));
      });
    });
    getStatus("https://www.enzimais.com.br").then((retorno) {
      setState(() {
        _list.add(StatItem(
            item: new Item(
                name: "Enzimais",
                url: "https://www.enzimais.com.br",
                status: retorno,
                statuscolor: retorno ? Colors.green : Colors.red)));
      });
    });
    getStatus("https://www.pspreports.com.br").then((retorno) {
      setState(() {
        _list.add(StatItem(
            item: new Item(
                name: "PSPReports",
                url: "https://www.pspreports.com.br",
                status: retorno,
                statuscolor: retorno ? Colors.green : Colors.red)));
      });
    });
    getStatus("http://essencial.integramedical.com.br").then((retorno) {
      setState(() {
        _list.add(StatItem(
            item: new Item(
                name: "Gestão Externos",
                url: "http://essencial.integramedical.com.br",
                status: retorno,
                statuscolor: retorno ? Colors.green : Colors.red)));
      });
    });

    super.initState();
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
                            _list.add(StatItem(
                                item: new Item(
                                    name: name,
                                    url: url,
                                    status: retorno,
                                    statuscolor:
                                        retorno ? Colors.green : Colors.red)));
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
                        _list.map((s) => _buildWidgetExample(s)).toList()))));
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
