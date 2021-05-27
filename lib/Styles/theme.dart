import 'package:flutter/material.dart';

abstract class Themes {
  Themes();
}

class LightTheme extends Themes {
  static var contextTmp;

  LightTheme(BuildContext context) {
    contextTmp = context;
  }

  static const List<Color> gradienColors = [
    Color.fromRGBO(247, 129, 4, 1),
    Color.fromRGBO(255, 88, 71, 1),
  ];

  static const Color colorMain = Color.fromRGBO(241, 93, 40, 1);

  static const Gradient gradient = LinearGradient(
      colors: gradienColors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  static const Color colorTitleHeader = Color.fromRGBO(241, 93, 40, 100);
  static var curScaleFactor =
      contextTmp != null ? MediaQuery.of(contextTmp).textScaleFactor : 1.0;

  static var themeCustom = ThemeData(
    textTheme: TextTheme(
      button: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      subtitle2:
          TextStyle(color: colorTitleHeader, fontSize: 14 * curScaleFactor),
      headline3: TextStyle(
          color: colorTitleHeader,
          fontWeight: FontWeight.w400,
          fontSize: 14 * curScaleFactor),
      headline4: TextStyle(color: Colors.black, fontSize: 14 * curScaleFactor),
      headline5:
          TextStyle(color: colorTitleHeader, fontSize: 18 * curScaleFactor),
      headline6: TextStyle(
          fontSize: 25 * curScaleFactor,
          color: Colors.white,
          fontWeight: FontWeight.bold),
    ),
  );
}
