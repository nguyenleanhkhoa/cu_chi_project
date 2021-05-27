import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:cuchi/src/screens/view/map_overview.screen.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/resources/dialog.resource.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckingScreen extends StatefulWidget {
  static final String routeName = "/checking_route";
  @override
  _CheckingScreenState createState() => _CheckingScreenState();
}

class _CheckingScreenState extends State<CheckingScreen> {
  bool checkNetworkConnection = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    checkConnectionNetWork();
    super.didChangeDependencies();
  }

  void checkConnectionNetWork() async {
    bool isNetWorkConnection = await UtilsCommon.checkConnection();
    if (!isNetWorkConnection) {
      setState(() {
        checkNetworkConnection = false;
      });
    } else {
      Navigator.of(context).pushReplacementNamed(MapOverviewScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_connectionStatus);
    return Scaffold(
      key: scaffoldKey,
      body: checkNetworkConnection
          ? Container(
              child: Center(
                child: AppLoad.spinLoading,
              ),
            )
          : Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 70,
                      color: LightTheme.colorMain,
                    ),
                    Text(
                      "Không có kết nối internet!",
                      style: TextStyle(color: LightTheme.colorMain),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            checkNetworkConnection = true;
                          });
                          checkConnectionNetWork();
                        },
                        child: Text(
                          "Thử lại",
                          style: TextStyle(color: LightTheme.colorMain),
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}
