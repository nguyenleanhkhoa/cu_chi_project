library global_constant;

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:flutter/services.dart';

// ignore: non_constant_identifier_names
const PLATFORM_ANDROID = const MethodChannel("com.triviet.platform/android");
// const URL_API = "https://cuchi.safeforweb.com";

String urlApi = DotEnv.env['API_URL'];

final URL_SHARE_API = urlApi + "map/places/";

final URL_EDIT_USER_INFORMATION = urlApi + "user/edit";

final URL_REGISTER_USER = urlApi + "user/sign_up";

final Token = "qUT17DipLFXwcb-28ZdQZ4WaCxGAljJ5hNmT9YLKMm8";

final IS_LOGIN = false;

final RESET_PASSWORD_URL = urlApi + "user/password/new";
