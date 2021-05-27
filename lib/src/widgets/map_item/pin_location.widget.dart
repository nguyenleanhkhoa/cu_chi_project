import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';

class PinLocationWidget extends StatefulWidget {
  @override
  _PinLocationWidgetState createState() => _PinLocationWidgetState();
}

class _PinLocationWidgetState extends State<PinLocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Center(
      child: Icon(
        Icons.place,
        color: LightTheme.colorMain,
        size: 30,
      ),
    ));
  }
}
