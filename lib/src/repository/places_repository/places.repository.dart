import 'dart:async';
import 'dart:convert';

import 'package:cuchi/src/dto/dtos/response.dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/api/http_common.g.dart';

class PlacesRepository {
  Future<ResponseDto> getDetailPlace(int id, String type) async {
    String url = UtilsCommon.urlGetWithIdAttachment(id, type);

    var response = await HttpCommonRequest.getData(url);

    DetailPlaceScreenDto res;
    if (response.statusCode == 200) {
      if (type == "places") {
        var data = DetailPlaceScreenDto.fromJson(json.decode(response.body));
        res = DetailPlaceScreenDto(
            id: data.id,
            name: data.name,
            description: data.description,
            point: data.point,
            area: data.area,
            attachments: data.attachments,
            type: type);
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      } else if (type == "streets") {
        var data = StreetDetailPlaceScreenListModel.fromJson(
            json.decode(response.body));
        res = DetailPlaceScreenDto(
            id: data.id,
            name: data.name,
            description: data.description,
            point: data.points[0],
            area: data.streetLength,
            attachments: data.attachments,
            type: type);
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      } else {
        var data = DetailPlaceListModel.fromJson(json.decode(response.body));
        res = DetailPlaceScreenDto(
            id: data.id,
            name: data.name,
            description: data.description,
            point: data.points[0],
            area: data.area,
            attachments: data.attachments,
            type: type);
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      }
    } else if (response.statusCode == 500) {
      return ResponseDto(
          statusCode: response.statusCode,
          message: ErrorRequest.fromJson(json.decode(response.body)).exception,
          result: null);
    }
    return ResponseDto(
        statusCode: 401,
        message: ErrorRequest.fromJson(json.decode(response.body)).exception,
        result: null);
  }

  Future<ResponseDto> getDetailPlaceInMap(int id, String type) async {
    if (id == 0) {
      return ResponseDto(
          statusCode: 400, message: "Get detail success !", result: null);
    }
    String url = UtilsCommon.urlGetWithIdInMap(type, id);
    var response = await HttpCommonRequest.getData(url);
    DetailPlaceListModel res;
    if (response.statusCode == 200) {
      if (type == "places") {
        var data = PlaceDetailModel.fromJson(json.decode(response.body));
        res = DetailPlaceListModel(
          id: data.id,
          name: data.name,
          description: data.description,
          points: [data.point],
          attachments: data.attachments,
          area: data.area,
          type: type,
        );
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      } else if (type == "streets") {
        var data = StreetListDetailModel.fromJson(json.decode(response.body));
        res = DetailPlaceListModel(
          id: data.id,
          name: data.name,
          description: data.description,
          points: data.points,
          area: data.streetLength,
          attachments: data.attachments,
          type: type,
        );
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      } else {
        var data = PlaceListDetailModel.fromJson(json.decode(response.body));
        res = DetailPlaceListModel(
            id: data.id,
            name: data.name,
            description: data.description,
            points: data.points,
            area: data.area,
            type: type,
            attachments: data.attachments);
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      }
    } else if (response.statusCode == 500) {
      return ResponseDto(
          statusCode: response.statusCode,
          message: ErrorRequest.fromJson(json.decode(response.body)).exception,
          result: null);
    }
    return ResponseDto(
        statusCode: 401,
        message: ErrorRequest.fromJson(json.decode(response.body)).exception,
        result: null);
  }

  Future<ResponseDto> getDetailMap(int id, String type) async {
    String url = UtilsCommon.urlGetWithIdInMap(type, id);

    var response = await HttpCommonRequest.getData(url);

    PlaceListDetailModel res;
    if (response.statusCode == 200) {
      if (type == "places") {
        var data = PlaceDetailModel.fromJson(json.decode(response.body));
        res = PlaceListDetailModel(
            id: data.id,
            name: data.name,
            description: data.description,
            points: [data.point],
            area: data.area,
            type: type,
            marker: data.marker);
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      } else if (type == "streets") {
        var data = StreetListDetailModel.fromJson(json.decode(response.body));
        res = PlaceListDetailModel(
          id: data.id,
          name: data.name,
          description: data.description,
          points: data.points,
          area: data.streetLength,
          type: type,
        );
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      } else {
        var data = PlaceListDetailModel.fromJson(json.decode(response.body));
        res = res = PlaceListDetailModel(
          id: data.id,
          name: data.name,
          description: data.description,
          points: data.points,
          area: data.area,
          type: type,
        );
        return ResponseDto(
            statusCode: response.statusCode,
            message: "Get detail success !",
            result: res);
      }
    } else if (response.statusCode == 500) {
      return ResponseDto(
          statusCode: response.statusCode,
          message: ErrorRequest.fromJson(json.decode(response.body)).exception,
          result: null);
    }
    return ResponseDto(
        statusCode: 401,
        message: ErrorRequest.fromJson(json.decode(response.body)).exception,
        result: null);
  }
}
