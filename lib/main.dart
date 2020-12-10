import 'package:cuchi_tunnel_gis/src/bloc/login_bloc/login_bloc.dart';
import 'package:cuchi_tunnel_gis/src/screens/change_passwork_screen.dart';
import 'package:cuchi_tunnel_gis/src/screens/info_user_screen.dart';
import 'package:cuchi_tunnel_gis/src/screens/login_screen.dart';
import 'package:cuchi_tunnel_gis/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/screens/forgot_passwork_screen.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => LoginBloc(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {
        ForgotPassWorkScreen.routeName: (ctx) => ForgotPassWorkScreen(),
        ChangePassWorkScreen.routeName: (ctx) => ChangePassWorkScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        InfoUserScreen.routeName: (ctx) => InfoUserScreen(),
      },
    );
  }
}
