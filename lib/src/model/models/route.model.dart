
import '../models.dart';

class RouteModel {
  PlaceLocationModel startId;
  PlaceLocationModel endId;
  RouteModel({this.startId, this.endId});
  RouteModel.fromJson(Map<String, dynamic> json)
      : startId = json['startId'],
        endId = json['endId'];
}

// class RouteLatlng {
//   RouteLatlng({this.name, this.lat, this.lng, this.isDestination = false});
//
//   String name;
//   double lat;
//   double lng;
//   bool isDestination;
//
//   factory RouteLatlng.fromJson(Map<String, dynamic> json) => RouteLatlng(
//         name: json["name"],
//         lat: json["lat"],
//         lng: json["lng"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "lat": lat,
//         "lng": lng,
//       };
// }
