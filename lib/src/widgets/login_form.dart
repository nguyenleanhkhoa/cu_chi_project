import 'package:cuchi_tunnel_gis/src/bloc/login_bloc/login_bloc.dart';
import 'package:cuchi_tunnel_gis/src/screens/info_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:cuchi_tunnel_gis/Styles/theme.dart' as Style;
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailEditController = TextEditingController();
  TextEditingController _passwordEditController = TextEditingController();
  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailEditController.addListener(onChangeEmail);
    _passwordEditController.addListener(onChangeEmail);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailEditController.removeListener(onChangeEmail);
    _passwordEditController.removeListener(onChangePassword);
    super.dispose();
  }

  void onChangeEmail() {
    _loginBloc.add(LoginEmailChange(email: _emailEditController.text));
  }

  void onChangePassword() {
    _loginBloc.add(LoginPasswordChange(password: _emailEditController.text));
  }

  void onSubmit() {
    _loginBloc.add(LoginPressed(
        email: _emailEditController.text,
        password: _passwordEditController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Card(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                    controller: _emailEditController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black87),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent))),
                  ),
                  Divider(color: Colors.grey, height: 8),
                  TextField(
                    obscureText: true,
                    controller: _passwordEditController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        labelText: "Mật khẩu",
                        labelStyle: TextStyle(color: Colors.black87),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent))),
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
                // Navigator.of(context).pushNamed(InfoUserScreen.routeName);
                onSubmit();
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: Style.Colors.colors,
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
