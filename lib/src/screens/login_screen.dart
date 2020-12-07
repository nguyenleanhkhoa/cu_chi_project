import 'package:cu_chi_project/src/screens/info_user_screen.dart';
import 'package:cu_chi_project/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:cu_chi_project/Styles/theme.dart' as Style;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
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
                      '/assets/image/download.jpg',
                      width: 150,
                    ),
                    Text(
                      "ĐỊA ĐẠO CỦ CHI",
                      style: TextStyle(
                        color: Style.Colors.mainColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Tabs(context),
                    Login(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget Login(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Stack(
              overflow: Overflow.visible,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15, bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Đăng nhập",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: Style.Colors.mainColor,
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.email,
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
                          TextField(
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                labelText: "Mật khẩu",
                                labelStyle: TextStyle(color: Colors.black87),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent))),
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoUserScreen()),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: colors,
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                              child: Text(
                            "Đăng nhập",
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
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: GestureDetector(
              child: Center(
                  child: Text(
                "Quên mật khẩu?",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 55,
                  height: 1,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "hoặc",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 55,
                  height: 1,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "ĐĂNG NHẬP BẰNG FACEBOOK",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                GestureDetector(
                  child: Container(
                    //width: MediaQuery.of(context).size.width,
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(color: Colors.white, width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Bạn chưa có tài khoản? Đăng ký",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
