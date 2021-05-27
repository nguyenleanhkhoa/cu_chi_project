class RouteDto {
  int startId;
  int endId;
  RouteDto({this.startId, this.endId});
  RouteDto.fromJson(Map<String, dynamic> json)
      : startId = json['startId'],
        endId = json['endId'];
}

class RouteLatlng {
  RouteLatlng({this.name, this.lat, this.lng, this.isDestination});

  String name;
  double lat;
  double lng;
  bool isDestination;

  factory RouteLatlng.fromJson(Map<String, dynamic> json) => RouteLatlng(
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
