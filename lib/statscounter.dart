import 'package:flutter/material.dart';

class StatsCounter extends StatelessWidget {
  final double size;
  final int count;
  final String title;
  final Color titleColor;
  final Color bgColor;
  StatsCounter(
      {@required this.size, @required this.count, @required this.title, this.titleColor = Colors.white, this.bgColor = Colors.green});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: bgColor),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(count.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: titleColor,fontSize: size  *0.6, fontWeight: FontWeight.w800)),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: titleColor,
                    fontSize: size * 0.1, fontWeight: FontWeight.w400))
          ]),
    );
  }
}