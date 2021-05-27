class PolygonDto {
  int id;
  String cateName;
  String color;
  List<Coordinate> coordinate;

  List get getAttachments => coordinate;
  set setAttachments(List coordinate) => this.coordinate = coordinate;
  PolygonDto({this.id, this.cateName, this.color, this.coordinate});

  PolygonDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cateName = json['cateName'],
        color = json['color'],
        coordinate = List<Coordinate>.from(
            json['coordinate'].map((model) => Coordinate.fromJson(model)));
}

class Coordinate {
  int id;
  double lat;
  double long;

  Coordinate({this.id, this.lat, this.long});

  Coordinate.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lat = json['lat'],
        long = json['long'];
}
