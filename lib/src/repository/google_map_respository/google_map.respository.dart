import 'dart:async';
import 'dart:convert';

import 'package:cuchi/global_constant.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/api/http_common.g.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:http/http.dart';

class GoogleMapRepository {
  Future<ResponseDto> getPolygonId(int id, String q) async {
    int offset;
    String type = UtilsCommon.convertTypeString(id);
    List<PlaceListPoinModel> data = [];
    Response response;
    do {
      if (offset == null) {
        offset = 0;
      }
      String url = urlApi +
          "api/v1/$type?include=points&fields=id,name&offset=$offset&search=$q";

      response = await HttpCommonRequest.getData(url);
      if (response.statusCode == 200) {
        if (json.decode(response.body) != []) {
          json
              .decode(response.body)
              .map((i) => {
                    PlaceListPoinModel.fromJson(i) != null
                        ? data.add(PlaceListPoinModel(
                            points: PlaceListPoinModel.fromJson(i).points,
                            id: PlaceListPoinModel.fromJson(i).id,
                            name: PlaceListPoinModel.fromJson(i).name,
                            type: type,
                          ))
                        : null
                  })
              .toList();
          offset = List<PlaceListPoinModel>.from(json
                  .decode(response.body)
                  .map((x) => PlaceListPoinModel.fromJson(x))).length +
              offset;
        }
      }
    } while (List<PlaceListPoinModel>.from(json
            .decode(response.body)
            .map((x) => PlaceListPoinModel.fromJson(x))).length >
        0);

    var resp = ResponseDto(
        statusCode: response.statusCode,
        message: "Get detail success !",
        result: data);
    return resp;
  }

  Future<ResponseDto> getDefaultZoneMap() async {
    Response response;
    List<PlaceListPoinModel> data;

    String url = urlApi + "api/v1/maps?fields=id,name&include=points";
    try {
      response = await HttpCommonRequest.getData(url);

      if (response.statusCode == 200) {
        if (json.decode(response.body) != []) {
          data = List<PlaceListPoinModel>.from(json
              .decode(response.body)
              .map((x) => PlaceListPoinModel.fromJson(x)));

          var resp = ResponseDto(
              statusCode: response.statusCode,
              message: "Get detail success !",
              result: data);
          return resp;
        }
      } else if (response.statusCode == 400) {
        var resp = ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: data);
        return resp;
      } else if (response.statusCode == 500) {
        var resp = ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail failed !",
            result: data);
        return resp;
      }
    } catch (err) {
      print(err);
    }
    var resp = ResponseDto(
        statusCode: 500, message: "Get detail failed !", result: data);
    return resp;
  }

  Future<ResponseDto> getNearByLocation(double lat, double lng) async {
    var listRadius = [0.05, 0.1, 1, 2];
    Response response;
    List<PlaceAttachmentModel> data = [];
    int index = 0;
    try {
      do {
        String url = urlApi +
            "api/v1/places/radius?lat=$lat&lng=$lng&radius=${listRadius[index]}&include=point.attachments&fields=id,name,point_id,marker";
        response = await HttpCommonRequest.getData(url);

        if (response != null && response.statusCode == 200) {
          if (json.decode(response.body) != []) {
            json
                .decode(response.body)
                .map((i) => {
                      if (data
                              .where((element) =>
                                  element.name ==
                                  PlaceAttachmentModel.fromJson(i).name)
                              .length ==
                          0)
                        {
                          PlaceModel.fromJson(i) != null
                              ? data.add(PlaceAttachmentModel(
                                  point: PlaceAttachmentModel.fromJson(i).point,
                                  id: PlaceAttachmentModel.fromJson(i).id,
                                  name: PlaceAttachmentModel.fromJson(i).name,
                                  type: "places",
                                  attachments: PlaceAttachmentModel.fromJson(i)
                                      .attachments))
                              : null
                        }
                    })
                .toList();
            if (response.statusCode == 500) {
              break;
            }
          }
        }
        index++;
      } while (data.length <= 10 && index < 4);
      if (data.length == 0) {
        return ResponseDto(
            statusCode: 401,
            message: AppString.ALERT_MESSAGE_CHECK_LOCATION,
            result: data);
      }
      return new ResponseDto(
          statusCode: 200, message: "GET Success!", result: data);
    } catch (err) {
      //
    }
  }

  Future<ResponseDto> getSearchRadius(double lat, double lng, int radius,
      String q, bool loadMore, int offsets) async {
    int offset = 0;

    if (loadMore) {
      offset = offsets;
    }
    Response response;
    List<PlaceListPoinModel> data = [];
    Result result = Result();
    do {
      String url = urlApi +
          "api/v1/places/radius?lat=$lat&lng=$lng&radius=${radius / 1000}&include=point.attachments&fields=id,name,point_id,marker&search=$q&offset=$offset";
      response = await HttpCommonRequest.getData(url);

      if (response.statusCode == 200) {
        if (json.decode(response.body) != []) {
          json
              .decode(response.body)
              .map((i) => {
                    PlaceModel.fromJson(i) != null
                        ? data.add(PlaceListPoinModel(
                            points: [PlaceModel.fromJson(i).point],
                            id: PlaceModel.fromJson(i).id,
                            name: PlaceModel.fromJson(i).name,
                            type: "places",
                            marker: PlaceModel.fromJson(i).marker,
                          ))
                        : null
                  })
              .toList();
        }
        offset = data.length + offset;
      }
      if (response.statusCode == 404) {
        var resp = ResponseDto(
            statusCode: 404,
            message: AppString.ALERT_SYSTEM_UPDATING,
            result: result);
        return resp;
      }
    } while (response.statusCode == 200 &&
        List<PlaceListPoinModel>.from(json
                .decode(response.body)
                .map((x) => PlaceListPoinModel.fromJson(x))).length >
            0);

    result.offset = data.length;
    result.result = data;
    var resp = ResponseDto(
        statusCode: 200, message: "Get detail success !", result: result);
    return resp;
  }

  Future<ResponseDto> getPolylineId(String q) async {
    int offset;
    String type = UtilsCommon.convertTypeString(4);
    List<PlaceListPoinModel> data = [];
    Response response;
    try {
      do {
        if (offset == null) {
          offset = 0;
        }
        String url = urlApi +
            "/api/v1/$type?include=points&fields=id,name&offset=$offset&search=$q";

        response = await HttpCommonRequest.getData(url);

        if (response.statusCode == 200) {
          if (json.decode(response.body) != []) {
            json
                .decode(response.body)
                .map((i) => {
                      PlaceListPoinModel.fromJson(i) != null
                          ? data.add(PlaceListPoinModel(
                              points: PlaceListPoinModel.fromJson(i).points,
                              id: PlaceListPoinModel.fromJson(i).id,
                              name: PlaceListPoinModel.fromJson(i).name,
                              type: type,
                            ))
                          : null
                    })
                .toList();
            offset = json
                    .decode(response.body)
                    .map((x) => PlaceListPoinModel.fromJson(x))
                    .length +
                offset;
          }
        }
      } while (List<PlaceListPoinModel>.from(json
              .decode(response.body)
              .map((x) => PlaceListPoinModel.fromJson(x))).length >
          0);

      var resp = ResponseDto(
          statusCode: 200, message: "Get detail success !", result: data);
      return resp;
    } catch (err) {
      var resp = ResponseDto(
          statusCode: 500, message: "Get detail failed !", result: null);
      return resp;
    }
  }

  Future<ResponseDto> getMarker(String q) async {
    int offset;
    String type = UtilsCommon.convertTypeString(1);
    List<PlaceListPoinModel> data = [];
    Response response;
    do {
      if (offset == null) {
        offset = 0;
      }
      String url = urlApi +
          "/api/v1/$type?include=point&fields=id,name,point_id,description,marker&search=$q&offset=$offset";

      response = await HttpCommonRequest.getData(url);

      if (response.statusCode == 200) {
        if (json.decode(response.body) != []) {
          json
              .decode(response.body)
              .map((i) => {
                    PlaceModel.fromJson(i) != null
                        ? data.add(PlaceListPoinModel(
                            points: [PlaceModel.fromJson(i).point],
                            id: PlaceModel.fromJson(i).id,
                            name: PlaceModel.fromJson(i).name,
                            type: type,
                            marker: PlaceModel.fromJson(i).marker))
                        : null
                  })
              .toList();
          offset = json
                  .decode(response.body)
                  .map((x) => PlaceModel.fromJson(x))
                  .length +
              offset;
        }
      }
    } while (List<PlaceModel>.from(
                json.decode(response.body).map((x) => PlaceModel.fromJson(x)))
            .length >
        0);

    var resp = ResponseDto(
        statusCode: 200, message: "Get detail success !", result: data);
    return resp;
  }

  Future<ResponseDto> getSearchAddess(
      String q, List<String> list, bool loadMore, int offsets) async {
    int limit = 10;
    // if (list.length == 0) {
    //   limit = 10;
    // } else {
    //   limit = 10 ~/ list.length;
    // }
    int offset = 0;
    List<PlaceListPoinModel> data = [];
    Result result = Result();
    if (loadMore) {
      offsets = offsets + limit;
    } else {
      offset = 0;
    }

    for (var item in list.length == 0 ? ["places"] : list) {
      String url = urlApi +
          "/api/v1/$item?include=points.attachments&search=$q&limit=$limit&offset=${loadMore ? offsets : offset}";
      if (item == "places") {
        url = "";
        url = urlApi +
            "/api/v1/$item?include=point.attachments&search=$q&limit=$limit&offset=${loadMore ? offsets : offset}";
      }
      var response = await HttpCommonRequest.getData(url);

      if (response.statusCode == 200) {
        if (json.decode(response.body) != []) {
          if (item == "places") {
            json
                .decode(response.body)
                .map((i) => {
                      data.add(PlaceListPoinModel(
                          id: PlaceModel.fromJson(i).id,
                          name: PlaceModel.fromJson(i).name,
                          marker: PlaceModel.fromJson(i).marker,
                          type: item,
                          points: [PlaceModel.fromJson(i).point]))
                    })
                .toList();
          } else {
            json
                .decode(response.body)
                .map((i) => {
                      PlaceListPoinModel.fromJson(i) != null
                          ? data.add(PlaceListPoinModel(
                              points: PlaceListPoinModel.fromJson(i).points,
                              id: PlaceListPoinModel.fromJson(i).id,
                              name: PlaceListPoinModel.fromJson(i).name,
                              marker: PlaceListPoinModel.fromJson(i).marker,
                              type: item))
                          : null
                    })
                .toList();
          }
        }
      } else if (response.statusCode == 502) {
        var resp = ResponseDto(
            statusCode: response.statusCode,
            message: "Server Error !",
            result: null);
        return resp;
      } else if (response.statusCode == 404) {
        var resp = ResponseDto(
            statusCode: response.statusCode,
            message: AppString.ALERT_SYSTEM_UPDATING,
            result: result);
        return resp;
      }
    }
    result.result = data;
    result.offset = loadMore ? offsets : limit;
    var resp = ResponseDto(
        statusCode: 200, message: "Get detail success !", result: result);
    return resp;
  }
}
