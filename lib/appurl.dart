import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;

class Item {
  String name;
  String url;
  bool status;
  Color statuscolor;
  Item(
      {@required this.name,
      @required this.url,
      this.status = true,
      this.statuscolor = Colors.grey});
}

class StatItem extends StatefulWidget {
  Item item;
  StatItem({@required this.item});

  @override
  _StatItemState createState() => _StatItemState();
}

class _StatItemState extends State<StatItem> {
  Future<bool> fetchget() async {
    try {
      final response = await http.get(widget.item.url);
      return (response.statusCode == 200);
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    setState(() {
      fetchget().then((retorno) {
        widget.item.status = retorno;
        widget.item.statuscolor = retorno ? Colors.green : Colors.red;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.web,
        size: 40,
      ),
      title: Text(widget.item.name),
      subtitle: Text(widget.item.url),
      trailing:
          Icon(Icons.offline_bolt, color: widget.item.statuscolor, size: 40),
      onTap: () {
        BotToast.showLoading();
        print(this.widget.item.url);
        setState(() {
          fetchget().then((retorno) {
            var texto =
                'Url: ${this.widget.item.url} ${retorno ? "on-line" : "off-line"}';
            BotToast.closeAllLoading();
            BotToast.showText(text: texto);
            widget.item.status = retorno;
            widget.item.statuscolor = retorno ? Colors.green : Colors.red;
          });
        });
      },
    );
  }
}
