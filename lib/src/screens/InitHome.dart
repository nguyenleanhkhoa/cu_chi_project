import 'package:cu_chi_project/Styles/theme.dart' as Style;
import 'package:flutter/material.dart';

class IntHomePage extends StatefulWidget {
  @override
  _IntHomePageState createState() => _IntHomePageState();
}

class _IntHomePageState extends State<IntHomePage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: Container(
          decoration: BoxDecoration(gradient: Style.Colors.primaryGradient
              // gradient: LinearGradient(
              //   colors: Style.Colors.colors,
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
              ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/download.jpg',
                    width: 100.0,
                  ),
                  Tabs(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget Tabs(context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 30,
        left: 15,
        right: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.12),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: _index == 0 ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Existing'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
