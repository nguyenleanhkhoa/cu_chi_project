import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/dto/dtos/response.dto.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';

class ApiException {
  int httpCode = 500;
  String message = "UnKnown";

  ApiException({this.httpCode, this.message});
}

class ApiGlobal {
  static final bloc = BaseObserver();
  static Future<ResponseDto> fetchData<T>(
      Future<ResponseDto> Function() func) async {
    try {
      ResponseDto result = await func();
      return Future.value(result);
    } catch (e) {
      print("API ERROR: $e");
      if (e != null && e.statusCode == 500) {
        bloc.error(message: AppString.ALERT_SYSTEM_ERROR);
      }
    }
  }
}
