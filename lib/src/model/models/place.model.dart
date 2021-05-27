import 'package:cuchi/src/dto/dto.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

class PlaceModel {
  final int id;
  final String name;
  final Point point;
  final String type;
  final int marker;

  PlaceModel({this.marker, this.id, this.name, this.point, this.type});

  PlaceModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] == null ? null : json["id"],
        name = json["name"] == null ? null : json["name"],
        marker = json["marker"] == null ? null : json["marker"],
        type = json["type"] == null ? null : json["type"],
        point = json["point"] == null ? null : Point.fromJson(json["point"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "point": point.toJson(),
      };
}

class PlaceShareModel {
  final int id;
  final String name;
  final Point point;
  final String type;

  PlaceShareModel({this.id, this.name, this.point, this.type});

  PlaceShareModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] == null ? null : json["id"],
        name = json["name"] == null ? null : json["name"],
        type = json["type"] == null ? null : json["type"],
        point = json["point"] == null ? null : Point.fromJson(json["point"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "point": point.toJson(),
      };
}

class PlaceAttachmentModel {
  final int id;
  final String name;
  final Point point;
  final String type;
  List<AttachmentDto> attachments;

  List get getAttachments => attachments;

  set setAttachments(List attachments) => this.attachments = attachments;
  PlaceAttachmentModel(
      {this.id, this.name, this.point, this.type, this.attachments});

  PlaceAttachmentModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] == null ? null : json["id"],
        name = json["name"] == null ? "Đang cập nhật" : json["name"],
        type = json["type"] == null ? null : json["type"],
        point = json["point"] == null ? null : Point.fromJson(json["point"]),
        attachments = List<AttachmentDto>.from(
            json['attachments'].map((model) => AttachmentDto.fromJson(model)));
}

class PlaceListPoinModel {
  final int id;
  final String name;
  List<Point> points;
  final String type;
  final bool share;
  final int marker;

  List get getPoint => points;

  set setPoint(List points) => this.points = points;
  PlaceListPoinModel(
      {this.marker, this.id, this.name, this.points, this.type, this.share});

  PlaceListPoinModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] == null ? null : json["id"],
        name = json["name"] == null ? "Đang cập nhật" : json["name"],
        marker = json["marker"] == null ? 0 : json["marker"],
        type = json["type"] == null ? "Đang cập nhật" : json["type"],
        share = json["share"] == null ? false : json["share"],
        points = json["points"] == null
            ? null
            : List<Point>.from(
                json['points'].map((model) => Point.fromJson(model)));
}

class Result {
  List<PlaceListPoinModel> result;
  int offset;
  String type;
  Result({this.result, this.offset, this.type});
}

class PlaceDetailModel {
  final int id;
  final String name;
  final String description;
  final Point point;
  final double area;
  final String type;
  final int marker;

  List<AttachmentDto> attachments;
  List get getAttachments => attachments;

  set setAttachments(List attachments) => this.attachments = attachments;
  PlaceDetailModel(
      {this.id,
      this.name,
      this.marker,
      this.description,
      this.area,
      this.type,
      this.point,
      this.attachments});

  PlaceDetailModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] == null ? null : json["id"],
        name = json["name"] == null ? null : json["name"],
        marker = json["marker"] == null ? 0 : json["marker"],
        description =
            json["description"] == null ? "Đang cập nhật" : json["description"],
        point = json["point"] == null ? null : Point.fromJson(json["point"]),
        type = json["type"] == null ? null : json["type"],
        area = json["area"] == null ? 0 : json["area"],
        attachments = List<AttachmentDto>.from(
            json['attachments'].map((model) => AttachmentDto.fromJson(model)));
}

class PlaceListDetailModel {
  final int id;
  final String name;
  final String description;
  List<Point> points;
  final double area;
  final String type;
  final int marker;
  List<AttachmentDto> attachments;
  List get getAttachments => attachments;

  set setAttachments(List attachments) => this.attachments = attachments;
  List get getPoint => points;

  set setPoint(List points) => this.points = points;
  PlaceListDetailModel(
      {this.id,
      this.name,
      this.description,
      this.points,
      this.area,
      this.type,
      this.marker,
      this.attachments});

  PlaceListDetailModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] == null ? null : json["id"],
        name = json["name"] == null ? null : json["name"],
        description =
            json["description"] == null ? "Đang cập nhật" : json["description"],
        type = json["type"] == null ? null : json["type"],
        marker = json["marker"] == null ? 0 : json["marker"],
        points = List<Point>.from(
            json['points'].map((model) => Point.fromJson(model))),
        area = json["area"] == null ? null : json["area"],
        attachments = List<AttachmentDto>.from(
            json['attachments'].map((model) => AttachmentDto.fromJson(model)));
}

class StreetListDetailModel {
  final int id;
  final String name;
  final String description;
  List<Point> points;
  final double streetLength;
  List<AttachmentDto> attachments;
  List get getAttachments => attachments;

  set setAttachments(List attachments) => this.attachments = attachments;
  List get getPoint => points;

  set setPoint(List points) => this.points = points;
  StreetListDetailModel(
      {this.id,
      this.name,
      this.description,
      this.points,
      this.streetLength,
      this.attachments});

  StreetListDetailModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] == null ? null : json["id"],
        name = json["name"] == null ? null : json["name"],
        description =
            json["description"] == null ? "Đang cập nhật" : json["description"],
        points = List<Point>.from(
            json['points'].map((model) => Point.fromJson(model))),
        streetLength =
            json["street_length"] == null ? null : json["street_length"],
        attachments = List<AttachmentDto>.from(
            json['attachments'].map((model) => AttachmentDto.fromJson(model)));
}

class Point {
  final double lat;
  final double lng;

  Point({this.lat, this.lng});

  Point.fromJson(Map<String, dynamic> json)
      : lat = json["lat"] == null
            ? null
            : ((json["lat"] is String)
                ? double.parse(json["lat"])
                : json["lat"]),
        lng = json["lng"] == null
            ? null
            : ((json["lng"] is String)
                ? double.parse(json["lng"])
                : json["lng"]);

  Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
      };
}

// class PointDto {
//   final String lat;
//   final String lng;

//   PointDto({this.lat, this.lng});

//   PointDto.fromJson(Map<String, dynamic> json)
//       : lat = json["lat"] == null ? null : json["lat"],
//         lng = json["lng"] == null ? null : json["lng"];

//   Map<String, dynamic> toJson() => {
//         "lat": lat == null ? null : lat,
//         "lng": lng == null ? null : lng,
//       };
// }

class DetailPlaceListModel {
  final int id;
  final String name;
  final String description;
  List<Point> points;
  List<AttachmentDto> attachments;
  final double area;
  final String type;

  List get getPoints => points;

  set setPoints(List points) => this.points = points;

  List get getAttachments => attachments;

  set setAttachments(List attachments) => this.attachments = attachments;

  DetailPlaceListModel({
    this.id,
    this.name,
    this.type,
    this.points,
    this.description,
    this.attachments,
    this.area,
  });

  DetailPlaceListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] == null ? null : json['id'],
        name = json['name'] == null ? null : json['name'],
        type = json['type'] == null ? null : json['type'],
        description =
            json['description'] == null ? "Đang cập nhật" : json['description'],
        area = json['area'] == null ? null : json['area'],
        points = List<Point>.from(
            json['points'].map((model) => Point.fromJson(model))),
        attachments = List<AttachmentDto>.from(
            json['attachments'].map((model) => AttachmentDto.fromJson(model)));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'attachments': attachments,
      };
}

class StreetDetailPlaceScreenListModel {
  int id;
  String name;
  String description;
  List<Point> points;
  double streetLength;
  List<AttachmentDto> attachments;

  List get getPoints => points;

  set setPoints(List points) => this.points = points;

  List get getAttachments => attachments;

  set setAttachments(List attachments) => this.attachments = attachments;

  StreetDetailPlaceScreenListModel({
    this.id,
    this.name,
    this.points,
    this.streetLength,
    this.description,
    this.attachments,
  });

  StreetDetailPlaceScreenListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] == null ? null : json['id'],
        name = json['name'] == null ? null : json['name'],
        streetLength =
            json['street_length'] == null ? null : json['street_length'],
        description =
            json['description'] == null ? "Đang cập nhật" : json['description'],
        points = List<Point>.from(
            json['points'].map((model) => Point.fromJson(model))),
        attachments = List<AttachmentDto>.from(
            json['attachments'].map((model) => AttachmentDto.fromJson(model)));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'attachments': attachments,
      };
}

class DetailPlaceScreenDto {
  int id;
  String name;
  String description;
  Point point;
  double area;
  String type;
  List<AttachmentDto> attachments;

  List get getAttachments => attachments;

  set setAttachments(List attachments) => this.attachments = attachments;

  DetailPlaceScreenDto(
      {this.id,
      this.name,
      this.point,
      this.area,
      this.description,
      this.attachments,
      this.type});

  DetailPlaceScreenDto.fromJson(Map<String, dynamic> json)
      : id = json['id'] == null ? null : json['id'],
        name = json['name'] == null ? null : json['name'],
        area = json['area'] == null ? null : json['area'],
        description =
            json['description'] == null ? "Đang cập nhật" : json['description'],
        point = json["point"] == null ? null : Point.fromJson(json["point"]),
        attachments = List<AttachmentDto>.from(
            json['attachments'].map((model) => AttachmentDto.fromJson(model)));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'attachments': attachments,
      };
}

class ListParam {
  int radius;
  List<String> dataHistory;
  ListParam({this.radius, this.dataHistory});
}

class ParamMapDetail {
  int type;
  ParamRequest paramRequest;
  ParamMapDetail({this.paramRequest, this.type});
}

class ParamRequest {
  int idPlace;
  String type;

  RouteLatlng pointEnd;
  int id;
  ParamRequest({
    this.id,
    this.idPlace,
    this.type,
    this.pointEnd,
  });
}

class ListMarker {
  final BitmapDescriptor bitmapDescriptor;
  final int marker;

  ListMarker({this.bitmapDescriptor, this.marker});
}
