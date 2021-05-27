part of 'map.bloc.dart';

@immutable
abstract class MapEvent {}

class LoadingGoogleMapEvent extends MapEvent {}

class LoadedGoogleMapEvent extends MapEvent {}

class LoadingPolygonIdEvent extends MapEvent {
  final String q;
  final int typeId;
  LoadingPolygonIdEvent(this.typeId, this.q);
}

class LoadingInitMapEvent extends MapEvent {}

class DeletePolygonIdEvent extends MapEvent {
  final int typeId;
  DeletePolygonIdEvent(this.typeId);
}

class LoadingMarkerEvent extends MapEvent {
  final String q;
  LoadingMarkerEvent(this.q);
}

class DeleteMarkerEvent extends MapEvent {
  DeleteMarkerEvent();
}

class LoadingPolylineIdEvent extends MapEvent {
  final String q;
  LoadingPolylineIdEvent(this.q);
}

class DeletePolylineEvent extends MapEvent {}

class BindingSearchEvent extends MapEvent {
  final List<PlaceListPoinModel> data;
  BindingSearchEvent(this.data);
}

class SearchStreetMapRouteEvent extends MapEvent {
  final List<PlaceLocationModel> listRoute;
  final int radius;
  SearchStreetMapRouteEvent(this.listRoute, this.radius);
}

class BindingDeleteHistoryEvent extends MapEvent {}

class GoogleMapFinishedEvent extends MapEvent {
  final GoogleMapsController googleMapController;
  GoogleMapFinishedEvent(this.googleMapController);
}

class LoaddingRadiusEvent extends MapEvent {
  final double lnglocal;
  final double latlocal;
  final int radius;
  final String q;
  final bool loadMore;
  final int offset;
  LoaddingRadiusEvent(this.latlocal, this.lnglocal, this.radius, this.q,
      this.offset, this.loadMore);
}

class LoaddingDefaultPolylineEvent extends MapEvent {
  final int show;
  LoaddingDefaultPolylineEvent(this.show);
}

class CheckingCurrentPositionIsRightPlace extends MapEvent {
  final double lat;
  final double lng;

  CheckingCurrentPositionIsRightPlace(this.lat, this.lng);
}

class ClosedTimeLineBarEvent extends MapEvent {
  final bool isBackHome;

  ClosedTimeLineBarEvent(this.isBackHome);
}
