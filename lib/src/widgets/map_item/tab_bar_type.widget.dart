import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';

class TabBarTypeWidget extends StatelessWidget {
  String text;
  Color color;
  String iconPath;
  bool checked = false;

  TabBarTypeWidget(
      {Key key, this.text, this.color, this.iconPath, this.checked})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
            border: Border.all(
                width: checked ? 2.0 : 0.5,
                color: checked ? LightTheme.colorMain : Colors.grey),
            borderRadius: BorderRadius.circular(20),
            color: color),
        child: Row(
          children: [
            Container(
              width: 25 * MediaQuery.of(context).textScaleFactor,
              height: 20 * MediaQuery.of(context).textScaleFactor,
              child: Image.asset(iconPath),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }
}
