import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global_constant.dart';

class UserInformationScreen extends StatefulWidget {
  static const routeName = '/user-information';

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen>
    with AutomaticKeepAliveClientMixin {
  String username = "";

  String email = "";

  String birthday = "";

  UserInforBloc userInforBloc;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final bloc = BaseObserver();
  Future<void> getInformationCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();

    email = prefs.getString(AppString.CURRENT_USER_EMAIL);
    username = prefs.getString(AppString.CURRENT_USER_USERNAME);
    birthday = prefs.getString(AppString.CURRENT_USER_BIRTHDAY);
    userInforBloc.add(ShowCurrentUserInformationEvent(
        email: email, username: username, birthday: birthday));
  }

  @override
  void initState() {
    userInforBloc = BlocProvider.of<UserInforBloc>(context);
    getInformationCurrentUser();
    super.initState();
  }

  void onChangePassword() async {
    final url = URL_EDIT_USER_INFORMATION;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      bloc.error(message: AppString.ERROR_BROWSER_LAUNCHER);
    }
  }

  void onChangeInformation() async {
    final url = URL_EDIT_USER_INFORMATION;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      bloc.error(message: AppString.ERROR_BROWSER_LAUNCHER);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: LightTheme.colorMain,
        title: Text("Thông tin"),
      ),
      body: BlocBuilder<UserInforBloc, UserState>(
        buildWhen: (oldState, curentState) {
          if (!(curentState is UserCurrentInformationState)) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is UserCurrentInformationState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
                child: Container(
                  height: 450.0,
                  child: Card(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Thông tin cá nhân",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: LightTheme.colorMain),
                            ),
                          ),
                          TextField(
                            controller: TextEditingController(text: username),
                            decoration: InputDecoration(
                                labelText: "Họ tên", enabled: false),
                          ),
                          TextField(
                            controller: TextEditingController(text: email),
                            decoration: InputDecoration(
                                labelText: "Email", enabled: false),
                          ),
                          TextField(
                            controller: TextEditingController(
                                text: birthday.substring(0, 10)),
                            decoration: InputDecoration(
                                labelText: "Ngày sinh", enabled: false),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                FlatButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  color: LightTheme.colorMain,
                                  onPressed: onChangePassword,
                                  child: Text(
                                    "Thay đổi mật khẩu",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                FlatButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  color: LightTheme.colorMain,
                                  onPressed: onChangeInformation,
                                  child: Text(
                                    "Chỉnh sửa thông tin cá nhân",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container(
            width: 0.0,
            height: 0.0,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
