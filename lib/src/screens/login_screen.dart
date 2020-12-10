import 'package:cuchi_tunnel_gis/src/bloc/login_bloc/login_bloc.dart';
import 'package:cuchi_tunnel_gis/src/screens/forgot_passwork_screen.dart';
import 'package:cuchi_tunnel_gis/src/screens/register_screen.dart';
import 'package:cuchi_tunnel_gis/src/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:cuchi_tunnel_gis/Styles/theme.dart' as Style;
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isLoginSuccess) {
          print("asd");
        } else if (state.isLoginFailure) {
          print("Asdas");
        }
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          left: false,
          right: false,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: Style.Colors.colors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: Style.Colors.colors,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/image/download.jpg',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget Login(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
    child: Column(
      children: <Widget>[
        LoginForm(),
        Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child: GestureDetector(
            child: Center(
                child: Text(
              "Quên mật khẩu?",
              style: TextStyle(color: Colors.white, fontSize: 16),
            )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotPassWorkScreen(),
                ),
              );
            },
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
