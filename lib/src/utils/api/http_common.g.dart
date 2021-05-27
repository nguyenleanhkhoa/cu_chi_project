import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'custom_exception.dart';

final bloc = BaseObserver();

class HttpCommonRequest {
  static Future<Response> getData(String url) async {
    var uri = Uri.parse(url);

    Response response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $Token',
    }).timeout(
      Duration(milliseconds: 10000),
      onTimeout: () {
        throw FetchDataException(
            'Error  while Communication with Server ', 500);
      },
    ).onError((error, stackTrace) {
      bloc.error(message: "Đường truyền mạng đang gặp sự cố!");
      return new http.Response(null, 500);
    });
    return _response(response);
  }

  static Response _response(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException("Bad Request !", 400);
      case 401:
      case 403:
        throw UnauthorisedException("Unauthorize !", 403);
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server ', 500);
    }
  }
}
