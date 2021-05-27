import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/resources/auth_string.resource.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_infor_event.dart';
part 'user_infor_state.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------

class UserInforBloc extends Bloc<UserInforEvent, UserState> {
  UserInforBloc() : super(InitialState());

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Map<String, dynamic> getUserDetails(String accessToken) {
    final parts = accessToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  @override
  Stream<UserState> mapEventToState(UserInforEvent event) async* {
    if (event is ShowUserInforEvent) {
      yield await eventShowUserInfor(event.show);
    } else if (event is InitUserInfoEvent) {
      yield* eventInitLogin();
    } else if (event is LoggingEvent) {
      yield* eventLogginUser();
    } else if (event is LogoutEvent) {
      yield* eventLogoutUser();
    } else if (event is CheckingLoginEvent) {
      yield await eventCheckingLoggin();
    } else if (event is ShowCurrentUserInformationEvent) {
      yield await eventShowUserCurrentInformation(
          event.username, event.email, event.birthday);
    }
  }

  Future<UserState> eventCheckingLoggin() async {
    var prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(AppString.CURRENT_USER_EMAIL);
    final username = prefs.getString(AppString.CURRENT_USER_USERNAME);
    if (email != null && username != null) {
      final expiredTime = UtilsCommon.convertDateFromString(
          prefs.getString(AppString.CURRENT_USER_EXPIREDTIME));
      final timeNow = DateTime.now();
      if (expiredTime.isBefore(timeNow)) {
        return CheckLoggingState(false, email, username);
      } else {
        return CheckLoggingState(true, email, username);
      }
    } else {
      return CheckLoggingState(false, email, username);
    }
  }

  Future<UserState> eventShowUserInfor(bool show) async {
    var prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(AppString.CURRENT_USER_EMAIL);
    final username = prefs.getString(AppString.CURRENT_USER_USERNAME);
    var isLoggin = false;
    if (email != null && username != null) {
      isLoggin = true;
    }
    if (show) {
      if (state.show == show) {
        return ShowDialogUser(false, email, username, isLoggin);
      } else {
        return ShowDialogUser(show, email, username, isLoggin);
      }
    } else {
      return ShowDialogUser(false, email, username, isLoggin);
    }
  }

  Stream<UserState> eventInitLogin() async* {
    try {
      final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
      if (storedRefreshToken == null) return;

      yield IsLoggingState();
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));
      secureStorage.write(key: 'refresh_token', value: response.refreshToken);
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      yield IsLogginErrorState("Login erro : $e");
    }
  }

  Stream<UserState> eventLogginUser() async* {
    var prefs = await SharedPreferences.getInstance();

    yield IsLoggingState();
    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
          issuer: AUTH0_ISSUER,
          scopes: ['openid', 'read'],
          // promptValues: ['login']
        ),
      );

      //final idToken = parseIdToken(result.idToken);
      final profile = getUserDetails(result.accessToken);
      final expiredTime = result.accessTokenExpirationDateTime;
      final user = profile.entries.toList()[3].value;
      final email = (user as Map).entries.toList()[1].value;
      final username = (user as Map).entries.toList()[2].value;
      final birthday = (user as Map).entries.toList()[3].value;
      //store share preference

      prefs.setString(
          AppString.CURRENT_USER_EXPIREDTIME, expiredTime.toString());
      prefs.setString(AppString.CURRENT_USER_EMAIL, email);
      prefs.setString(AppString.CURRENT_USER_USERNAME, username);
      prefs.setString(AppString.CURRENT_USER_BIRTHDAY, birthday);
      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      yield IsLoggedState(email, username, false);
    } catch (e, s) {
      print('login error: $e - stack: $s');
      yield IsLogginErrorState("Loggin erro : $e");
    }
  }

  Future<UserState> eventShowUserCurrentInformation(
      username, email, birthday) async {
    return UserCurrentInformationState(username, email, birthday);
  }

  Stream<UserState> eventLogoutUser() async* {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(AppString.CURRENT_USER_EMAIL);
    prefs.remove(AppString.CURRENT_USER_USERNAME);
    prefs.remove(AppString.CURRENT_USER_EXPIREDTIME);
    prefs.remove(AppString.CURRENT_USER_BIRTHDAY);

    await secureStorage.delete(key: 'refresh_token');

    yield IsLoggoutState();
  }
}
