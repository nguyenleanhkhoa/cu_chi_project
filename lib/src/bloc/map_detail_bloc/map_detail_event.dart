part of 'map_detail_bloc.dart';

@immutable
abstract class MapDetailEvent {}

class LoadingPlaceMapEvent extends MapDetailEvent {
  final int id;
  final String placeType;
  LoadingPlaceMapEvent(this.id, this.placeType);
}

// class SearchStreetRouteEvent extends MapDetailEvent {
//   final int idPlace;
//   final double lnglocal;
//   final double latlocal;
//   final RouteLatlng lastPoint;
//   SearchStreetRouteEvent(
//       {this.latlocal, this.lnglocal, this.idPlace, this.lastPoint});
// }
class SearchStreetMapDetailRouteEvent extends MapDetailEvent {
  final List<PlaceLocationModel> listRoute;
  final int radius;
  SearchStreetMapDetailRouteEvent(this.listRoute, this.radius);
}

class LoaddingDefaultPolylineMapDetailEvent extends MapDetailEvent {}

class LoadingInitZoneEvent extends MapDetailEvent {}
