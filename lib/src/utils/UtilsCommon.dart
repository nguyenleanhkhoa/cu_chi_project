import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:charcode/charcode.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cuchi/global_constant.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/datas/data_morkup.dart';
import 'package:cuchi/src/screens/view/map_overview.screen.dart';
import 'package:cuchi/src/widgets/dialog/dialog_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilsCommon {
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static String removeBracketFirstAndLastString(String str) {
    var strTmp = "";
    if (str.length != 0) {
      strTmp = str.replaceFirst("(", "");
      if (strTmp.endsWith(")")) {
        strTmp = strTmp.substring(0, strTmp.length - 1);
      }
    }
    return strTmp;
  }

  static String convertType(String value) {
    String res;
    switch (value) {
      case "places":
      case "streets":
      case "plants":
        res = "m";
        break;
      case "rivers":
      case "zones":
        res = "m" + String.fromCharCodes([$sup2]);
        break;
      default:
        res = "Không xác định";
        break;
    }
    return res;
  }

  static List<String> getTab() {
    List<String> type = [];
    Data.listTab.map((element) {
      if (element["checked"] == true) {
        type.add(convertTypeString(element["id"]));
      }
    }).toList();
    return type;
  }

  static String convertTypeString(int value) {
    String type = "";
    switch (value) {
      case 1:
        type = "places";
        break;
      case 2:
        type = "plants";
        break;
      case 3:
        type = "rivers";
        break;
      case 4:
        type = "streets";
        break;
      case 5:
        type = "zones";
        break;
    }
    return type;
  }

  static String urlSearchStreetRoute(int start, int end) {
    return urlApi + "/api/v1/routers/search?place_begin=$start&place_end=$end";
  }

  static String urlGetWithIdAttachment(int id, String type) {
    String url;
    switch (type) {
      case "places":
        url = urlApi +
            "api/v1/places/$id?include=point.attachments&fields=id,name,description,point_id,area";
        break;
      case "plants":
        url = urlApi +
            "/api/v1/plants/$id?include=points.attachments&fields=id,name,description,area";
        break;
      case "rivers":
        url = urlApi +
            "/api/v1/rivers/$id?include=points.attachments&fields=id,name,description,area";
        break;
      case "streets":
        url = urlApi +
            "/api/v1/streets/$id?include=points.attachments&fields=id,name,description,street_length";
        break;
      case "zones":
        url = urlApi +
            "/api/v1/zones/$id?include=points.attachments&fields=id,name,description,area";
        break;
    }
    return url;
  }

  static String urlGetWithIdInMap(String value, int id) {
    String url;
    switch (value) {
      case "places":
        url = urlApi +
            "api/v1/places/$id?include=point.attachments&fields=id,name,description,point_id,area,marker";
        break;
      case "plants":
        url = urlApi +
            "api/v1/plants/$id?include=points.attachments&fields=id,name,description,area";
        break;
      case "rivers":
        url = urlApi +
            "api/v1/rivers/$id?include=points.attachments&fields=id,name,description,area";
        break;
      case "streets":
        url = urlApi +
            "api/v1/streets/$id?include=points.attachments&fields=id,name,description,street_length";
        break;
      case "zones":
        url = urlApi +
            "api/v1/zones/$id?include=points.attachments&fields=id,name,description,area";
        break;
    }
    return url;
  }

  static Future<String> getValueFromSharePreference(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setValueToSharePreference(
      String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static DateTime convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    return todayDate;
  }

  static Future<String> getJsonFile(String part) async {
    return await rootBundle.loadString(part);
  }

  static void setMapStype(
      String mapstyle, GoogleMapsController _googleMapcontroller) {
    _googleMapcontroller.setMapStyle(mapstyle);
  }

  static changeMapMode(GoogleMapsController _googleMapcontroller) {
    getJsonFile('assets/map_style.json')
        .then((value) => setMapStype(value, _googleMapcontroller));
  }

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<bool> checkConnection() async {
    bool isConnected = false;
    await check().then((intenet) {
      print("call check...");

      if (intenet != null && intenet) {
        isConnected = true;
      } else {
        isConnected = false;
      }
    });
    return isConnected;
  }

  static final bloc = BaseObserver();
  static Future<bool> checkConnectionNetWork() async {
    bool isNetWorkConnection = await UtilsCommon.checkConnection();
    if (!isNetWorkConnection) {
      bloc.loading();
      await Future.delayed(new Duration(milliseconds: 2000));
      bloc.success();
      bloc.warning(message: "Error network!");
      return false;
    } else {
      return true;
    }
  }

  static Future<void> showErrorNetwork({BuildContext context}) async {
    bool isNetWorkConnection = await UtilsCommon.checkConnection();
    if (isNetWorkConnection) {
      Navigator.of(context).pushReplacementNamed(MapOverviewScreen.routeName);
    }
  }

  static void showSnackBarAlert({BuildContext context, String message}) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> setDataFromInput(bool isDataFromInput) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDataFromInput", isDataFromInput);
  }

  static Future<bool> checkDataFromInput() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isData = prefs.getBool("isDataFromInput");
    return isData;
  }
}

final bloc = BaseObserver();
void checkConnection({BuildContext context}) {
  UtilsCommon.check().then((intenet) {
    if (intenet != null && !intenet) {
      bloc.error(message: "NetWork Error");
    }
  });
}

void showProcess(GlobalKey context) {
  baseStream.listen((event) {
    if (event.isShowLoading) {
      if (event.status == BaseStatus.onProgress) {
        showDialog(
            barrierDismissible: false,
            context: context.currentContext,
            builder: (context) => AlertDialogMessage(
                  isLoading: true,
                ));
      } else if (event.status == BaseStatus.onSuccess) {
        if (event.isShowLoading && Navigator.canPop(context.currentContext)) {
          Navigator.of(context.currentContext).pop();
        }
        if (event.isShowDialogMessage) {}
      } else if (event.status == BaseStatus.onError) {
        showDialog(
            context: context.currentContext,
            builder: (context) => AlertDialogMessage(
                  subscription: event.errorMess,
                  isError: true,
                  isShowButtonAction: true,
                ));
      } else if (event.status == BaseStatus.onWarning) {
        showDialog(
            barrierDismissible: false,
            context: context.currentContext,
            builder: (context) => AlertDialogMessage(
                  subscription: event.errorMess,
                  isError: true,
                  isShowButtonAction: true,
                  okButton: true,
                  btnTitle: "Thử lại",
                  onOkPressed: () async {
                    bloc.success();
                    await UtilsCommon.checkConnectionNetWork();
                  },
                ));
      }
    }
  });
}

abstract class ConvertVietNamese {
  static const _vietnamese = 'aAeEoOuUiIdDyY';
  static final _vietnameseRegex = <RegExp>[
    RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
    RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
    RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
    RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
    RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
    RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
    RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
    RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
    RegExp(r'ì|í|ị|ỉ|ĩ'),
    RegExp(r'Ì|Í|Ị|Ỉ|Ĩ'),
    RegExp(r'đ'),
    RegExp(r'Đ'),
    RegExp(r'ỳ|ý|ỵ|ỷ|ỹ'),
    RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ')
  ];

  static String unsign(final String text) {
    var result = text;
    if (result is String) {
      for (var i = 0; i < _vietnamese.length; ++i) {
        result = result.replaceAll(_vietnameseRegex[i], _vietnamese[i]);
      }
    }
    return result;
  }
}
