import 'package:flutter/material.dart';
import 'package:pfsmonitor/appurl.dart';
import 'dart:math';

import 'package:pfsmonitor/statscounter.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Item> items = new List();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  var rng = new Random();

  _addItem() {
    setState(() {
      listKey.currentState
          .insertItem(items.length, duration: const Duration(seconds: 1));
      int id = rng.nextInt(5000);
      items.add(new Item(name: "App $id", url: "www.pdpoint.com.br"));
    });
  }

  _removeItem() {
    setState(() {
      int id = rng.nextInt(items.length);
      listKey.currentState.removeItem(
        id,
        (context, animation) => buildItem(context, 0, animation),
        duration: const Duration(milliseconds: 250),
      );
      items.removeAt(id);
    });
  }

  Widget buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return SizeTransition(
      key: ValueKey<int>(index),
      axis: Axis.vertical,
      sizeFactor: animation,
      child: SizedBox(
        child: ListTile(
          title: Text('${items[index].name}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, Animation<double>> animations = <int, Animation<double>>{};
    return Scaffold(
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
        body: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: <Widget>[
                Divider(),
                StatsCounter(
                  size: 150,
                  count: 4,
                  title: 'App Monitoradas',
                  titleColor: Colors.white,
                ),
                AnimatedList(
                  key: listKey,
                  initialItemCount: items.length,
                  itemBuilder: (context, index, animation) {
                    return buildItem(context, index, animation);
                  },
                ),
              ],
            )));
  }
}
