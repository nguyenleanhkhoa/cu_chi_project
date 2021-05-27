import 'dart:convert';

StreetRouteDto fromJson(String str) =>
    StreetRouteDto.fromJson(json.decode(str));

String toJson(StreetRouteDto data) => json.encode(data.toJson());

class StreetRouteDto {
  StreetRouteDto({
    this.routeId,
    this.listRoute,
  });

  int routeId;
  List<RouteLatLngDto> listRoute;

  factory StreetRouteDto.fromJson(Map<String, dynamic> json) => StreetRouteDto(
        routeId: json["routeId"],
        listRoute: List<RouteLatLngDto>.from(
            json["listRoute"].map((x) => RouteLatLngDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "routeId": routeId,
        "listRoute": List<dynamic>.from(listRoute.map((x) => x.toJson())),
      };
}

class RouteLatLngDto {
  RouteLatLngDto({this.name, this.lat, this.lng, this.isDestination});

  String name;
  String lat;
  String lng;
  bool isDestination;

  factory RouteLatLngDto.fromJson(Map<String, dynamic> json) => RouteLatLngDto(
        name: json["name"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lat": lat,
        "lng": lng,
      };
}
