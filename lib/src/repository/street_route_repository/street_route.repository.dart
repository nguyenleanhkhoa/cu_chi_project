import 'dart:convert';

import 'package:cuchi/src/dto/dtos/street_route.dto.dart';
import 'package:cuchi/src/dto/dtos/response.dto.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/api/http_common.g.dart';

class StreetRouteRepository {
  List<StreetRouteDto> listStreetModel = [];
  Future<ResponseDto> getRoute(int startId, int endId) async {
    String url = UtilsCommon.urlSearchStreetRoute(startId, endId);

    try {
      var response = await HttpCommonRequest.getData(url);

      List<RouteLatLngDto> listRoutes = [];
      var streetRoutes = json.decode(response.body);
      if (streetRoutes != null && (streetRoutes as List).length != 0) {
        for (var i in (streetRoutes as List)) {
          listRoutes.add(RouteLatLngDto.fromJson(i));
        }
      }

      return ResponseDto(
          statusCode: response.statusCode, message: "", result: listRoutes);
    } catch (err) {
      return ResponseDto(statusCode: 500, message: "ERROR ", result: null);
    }
  }
}
