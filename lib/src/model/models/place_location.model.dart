
import '../models.dart';

class PlaceLocationModel {
  String name;
  Point point;
  int id;
  int index;
  bool isDestination;
  bool pinLocation;

  PlaceLocationModel(
      {this.name,
      this.point,
      this.id,
      this.index,
      this.isDestination,
      this.pinLocation});

  PlaceLocationModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        point = Point.fromJson(json["coordinate"]),
        id = json["id"],
        index = json["index"],
        isDestination = json["isDestination"],
        pinLocation = json["pinLocation"];
  Map<String, dynamic> toJson() => {
        "name": name,
        "coordinate": point,
        "id": id,
        "index": index,
        "pinLocation": pinLocation,
        "isDestination": isDestination,
      };
}

// class Coordinates {
//   final double lat;
//   final double lng;

//   Coordinates({this.lat, this.lng});

//   Coordinates.fromJson(Map<String, dynamic> json)
//       : lat = json["lat"] ?? json["lat"],
//         lng = json["lng"] ?? json["lng"];

//   Map<String, dynamic> toJson() => {
//         "lat": lat == null ? null : lat,
//         "lng": lng == null ? null : lng,
//       };
// }
