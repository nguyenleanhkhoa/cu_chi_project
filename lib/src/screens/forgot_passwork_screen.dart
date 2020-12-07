import 'package:flutter/material.dart';
import 'package:cu_chi_project/Styles/theme.dart' as Style;

class ForgotPassWorkScreen extends StatefulWidget {
  @override
  _ForgotPassWorkScreenState createState() => _ForgotPassWorkScreenState();
}

class _ForgotPassWorkScreenState extends State<ForgotPassWorkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Color> colors = [Color(0xFFFB9245), Color(0xFFF54E6B)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: Container(
        decoration: BoxDecoration(gradient: Style.Colors.primaryGradient),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(color: Colors.white),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/image/download.jpg',
                      width: 100,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "ĐỊA ĐẠO CỦ CHI",
                      style: TextStyle(
                        color: Style.Colors.mainColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Tabs(context),
                    SignUp(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget SignUp(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 15, right: 15, bottom: 20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Quên mật khẩu",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Style.Colors.mainColor,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.black87),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                        ),
                        Divider(color: Colors.grey, height: 8),
                        Divider(
                          color: Colors.transparent,
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 125,
                  child: Center(
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 250,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: colors,
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(
                              child: Text(
                            "Gửi",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ],
      ),
    );
  }
}
