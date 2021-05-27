import 'dart:async';

import 'package:cuchi/global_constant.dart';
import 'package:cuchi/src/bloc/tool_bloc/user_infor_bloc/user_infor_bloc.dart';
import 'package:cuchi/src/screens/view/user_information.screen.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/src/widgets/dialog/dialog_custom.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDialogWidget extends StatefulWidget {
  @override
  _UserDialogWidgetState createState() => _UserDialogWidgetState();
}

class _UserDialogWidgetState extends State<UserDialogWidget>
    with TickerProviderStateMixin {
  bool selectedLoginButton = false;
  bool selectedEditUserButton = false;
  bool selectedLogoutButton = false;
  bool selectedButtonForgot = false;

  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;

  String name;
  String picture;

  String username = "";
  String email = "";

  double height = 250.0;

  UserInforBloc userInforBloc;
  Animation<double> dialogUserAnimation;
  AnimationController dialogUserAnimationController;

  void onForgotPassword() async {
    if (await canLaunch(RESET_PASSWORD_URL)) {
      await launch(RESET_PASSWORD_URL);
    } else {
      throw 'Could not launch $RESET_PASSWORD_URL';
    }
  }

  @override
  void initState() {
    userInforBloc = BlocProvider.of<UserInforBloc>(context);
    userInforBloc.add(CheckingLoginEvent(false));
    initAnimation();

    autoLoggout();
    super.initState();
  }

  void initAnimation() {
    dialogUserAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    dialogUserAnimation = Tween(begin: -400.0, end: 5.0).animate(
        CurvedAnimation(
            parent: dialogUserAnimationController, curve: Curves.ease));
    // end init animation
  }

  void showDialogUser() {
    dialogUserAnimation = Tween(begin: -400.0, end: 5.0).animate(
        CurvedAnimation(
            parent: dialogUserAnimationController, curve: Curves.ease));
    dialogUserAnimationController.forward();
  }

  void closeDialogUser() {
    dialogUserAnimation = Tween(begin: -400.0, end: 5.0).animate(
        CurvedAnimation(
            parent: dialogUserAnimationController, curve: Curves.ease));
    dialogUserAnimationController.reverse();
  }

  void autoLoggout() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString(AppString.CURRENT_USER_EXPIREDTIME) != null) {
      final expiredTime = UtilsCommon.convertDateFromString(
          prefs.getString(AppString.CURRENT_USER_EXPIREDTIME));

      final timeNow = DateTime.now();
      if (expiredTime.isBefore(timeNow)) {
        userInforBloc.add(LogoutEvent(false));
      } else {
        Timer(Duration(hours: 3), () {
          userInforBloc.add(LogoutEvent(false));
        });
      }
    }
  }

  void onRegisterUser() async {
    final url = URL_REGISTER_USER;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> showCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString(AppString.CURRENT_USER_USERNAME);
    email = prefs.getString(AppString.CURRENT_USER_EMAIL);
  }

  @override
  void didChangeDependencies() {
    showCurrentUser();
    // userInforBloc.add(InitUserInfoEvent(false));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserInforBloc, UserState>(
      listener: (context, state) {
        if (state is IsLoggedState) {
          showDialog(
              context: context,
              builder: (_) => AlertDialogMessage(
                  isSuccess: true,
                  subscription: AppString.ALERT_SYSTEM_LOGIN_SUCCESS));
          autoLoggout();
        } else if (state is IsLoggoutState) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => AlertDialogMessage(
                  isSuccess: true,
                  subscription: AppString.ALERT_SYSTEM_LOGOUT_SUCCESS));
        }
      },
      buildWhen: (oldState, currentState) {
        if (currentState is ShowDialogUser) {
          if (!currentState.show) {
            closeDialogUser();
          } else {
            showDialogUser();
          }
        }

        return true;
      },
      builder: (context, state) {
        if (state is ShowDialogUser) {
          // if (state.show) {
          showCurrentUser();
          if (state.isLoggedIn) {
            height = 300.0;
          } else if (!state.isLoggedIn) {
            height = 250.0;
          }

          return AnimatedBuilder(
            animation: dialogUserAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  state.show
                      ? GestureDetector(
                          onTap: () {
                            userInforBloc.add(ShowUserInforEvent(false));
                          },
                          child: Container(
                            color: Colors.black38,
                            width: MediaQuery.of(context).size.height,
                            height: MediaQuery.of(context).size.height,
                          ),
                        )
                      : null,
                  Positioned(
                    top: dialogUserAnimation.value,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 95.0),
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.only(top: 30.0),
                              height: height,
                              width: 300,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                              gradient: LightTheme.gradient,
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.transparent)),
                                          child: state.isLoggedIn
                                              ? Center(
                                                  child: Text(
                                                    state.username
                                                        .substring(0, 1)
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 40.0,
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 50.0,
                                                ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        (state.username != null &&
                                                state.username != "")
                                            ? Container(
                                                child: Text(state.username),
                                              )
                                            : null,
                                        (state.email != null &&
                                                state.email != "")
                                            ? Container(
                                                child: Text(
                                                  state.email,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : null,
                                      ]
                                          .where((element) => element != null)
                                          .toList(),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      (state.isLoggedIn
                                          ? const SizedBox(
                                              width: 0.0,
                                              height: 0.0,
                                            )
                                          : renderButton(
                                              Text(
                                                "Đăng nhập",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedLoginButton
                                                        ? Colors.white
                                                        : LightTheme
                                                            .colorTitleHeader),
                                              ),
                                              Icon(
                                                Icons.login,
                                                size: 20.0,
                                                color: selectedLoginButton
                                                    ? Colors.white
                                                    : LightTheme
                                                        .colorTitleHeader,
                                              ),
                                              selectedLoginButton
                                                  ? LightTheme.colorMain
                                                  : Colors.white,
                                              (TapDownDetails tapDownDetails) {
                                                userInforBloc
                                                    .add(LoggingEvent(true));
                                              },
                                              (TapUpDetails tapUpDetails) {},
                                            )),
                                      // (state.isLoggedIn
                                      //     ? const SizedBox(
                                      //         width: 0.0,
                                      //         height: 0.0,
                                      //       )
                                      //     : renderButton(
                                      //         Text(
                                      //           "Đăng ký",
                                      //           style: TextStyle(
                                      //               fontWeight: FontWeight.bold,
                                      //               color: selectedLoginButton
                                      //                   ? Colors.white
                                      //                   : LightTheme
                                      //                       .colorTitleHeader),
                                      //         ),
                                      //         Icon(
                                      //           Icons.person_add_alt,
                                      //           size: 20.0,
                                      //           color: selectedLoginButton
                                      //               ? Colors.white
                                      //               : LightTheme
                                      //                   .colorTitleHeader,
                                      //         ),
                                      //         selectedLoginButton
                                      //             ? LightTheme.colorMain
                                      //             : Colors.white,
                                      //         (TapDownDetails tapDownDetails) {
                                      //           onRegisterUser();
                                      //         },
                                      //         (TapUpDetails tapUpDetails) {},
                                      //       )),
                                      (state.isLoggedIn
                                          ? Container(
                                              width: 0.0,
                                              height: 0.0,
                                            )
                                          : renderButton(
                                              Text(
                                                "Quên mật khẩu",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedLoginButton
                                                        ? Colors.white
                                                        : LightTheme
                                                            .colorTitleHeader),
                                              ),
                                              Icon(
                                                Icons.refresh,
                                                size: 20.0,
                                                color: selectedLoginButton
                                                    ? Colors.white
                                                    : LightTheme
                                                        .colorTitleHeader,
                                              ),
                                              selectedLoginButton
                                                  ? LightTheme.colorMain
                                                  : Colors.white,
                                              (TapDownDetails tapDownDetails) {
                                                onForgotPassword();
                                              },
                                              (TapUpDetails tapUpDetails) {},
                                            )),
                                      (!state.isLoggedIn
                                          ? Container(
                                              width: 0.0,
                                              height: 0.0,
                                            )
                                          : renderButton(
                                              Text(
                                                "Thông tin cá nhân",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedEditUserButton
                                                        ? Colors.white
                                                        : LightTheme
                                                            .colorTitleHeader),
                                              ),
                                              Icon(
                                                Icons.person,
                                                size: 20.0,
                                                color: selectedEditUserButton
                                                    ? Colors.white
                                                    : LightTheme
                                                        .colorTitleHeader,
                                              ),
                                              selectedEditUserButton
                                                  ? LightTheme.colorMain
                                                  : Colors.white,
                                              (TapDownDetails tapDownDetails) {
                                                Navigator.of(context).pushNamed(
                                                    UserInformationScreen
                                                        .routeName);
                                              },
                                              (TapUpDetails tapUpDetails) {},
                                            )),
                                      (!state.isLoggedIn
                                          ? const SizedBox()
                                          : renderButton(
                                              Text(
                                                "Đăng xuất",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: selectedLogoutButton
                                                        ? Colors.white
                                                        : LightTheme
                                                            .colorTitleHeader),
                                              ),
                                              Icon(
                                                Icons.logout,
                                                size: 20.0,
                                                color: selectedLogoutButton
                                                    ? Colors.white
                                                    : LightTheme
                                                        .colorTitleHeader,
                                              ),
                                              selectedLogoutButton
                                                  ? LightTheme.colorMain
                                                  : Colors.white,
                                              (TapDownDetails tapDownDetails) {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        AlertDialogMessage(
                                                            isError: true,
                                                            isShowButtonAction:
                                                                true,
                                                            okButton: true,
                                                            onOkPressed: () {
                                                              userInforBloc.add(
                                                                  LogoutEvent(
                                                                      true));
                                                            },
                                                            subscription: AppString
                                                                .ALERT_SYSTEM_LOGOUT));
                                              },
                                              (TapUpDetails tapUpDetails) {},
                                            )),
                                    ]
                                        .where((element) => element != null)
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ].where((element) => element != null).toList(),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget renderButton(Text text, Icon icon, Color backgroundColor,
      GestureTapDownCallback onTapDown, GestureTapUpCallback onTapUp) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              top: BorderSide(width: 1, color: Colors.grey),
            )),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 80.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  icon,
                  SizedBox(
                    width: 10.0,
                  ),
                  text,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
