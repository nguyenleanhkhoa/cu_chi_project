part of 'map.bloc.dart';

class BaseState {}

@immutable
abstract class MapState extends BaseState {}

class MapLoadingState extends MapState {}

class MapLoadedState extends MapState {}

class MapInitial extends MapState {}

class LoadSuccessPolygonState extends MapState {
  final List<PlaceListPoinModel> data;
  LoadSuccessPolygonState(this.data);
}

class LoadSuccessPolylineState extends MapState {
  final List<PlaceListPoinModel> data;

  LoadSuccessPolylineState(this.data);
}

class PlacesLoadState extends MapState {}

class LoadSuccessMarkerState extends MapState {
  final List<PlaceListPoinModel> place;
  LoadSuccessMarkerState(this.place);
}

class LoadSuccessInitMapState extends MapState {
  final List<PlaceListPoinModel> data;
  LoadSuccessInitMapState(this.data);
}

class LoadFailMarkerState extends MapState {
  final String error;
  LoadFailMarkerState(this.error);
}

class BindingDataSearchState extends MapState {
  final List<PlaceListPoinModel> data;
  BindingDataSearchState(this.data);
}

class DeleteSuccessPolylineState extends MapState {
  DeleteSuccessPolylineState();
}

class DeleteSuccessPolygonState extends MapState {
  final int typeId;
  DeleteSuccessPolygonState(this.typeId);
}

class DeleteSuccessMarkerState extends MapState {
  DeleteSuccessMarkerState();
}

class StreetRouteSearchedState extends MapState {
  final ResponseDto listResponse;

  StreetRouteSearchedState(this.listResponse);
}

class BindingDeleteSearchState extends MapState {}

class GoogleMapfinishedState extends MapState {
  final GoogleMapsController googleMapController;
  GoogleMapfinishedState(this.googleMapController);
}

class GoogleMapLoadErrorState extends MapState {
  final ResponseDto responseDto;
  GoogleMapLoadErrorState(this.responseDto);
}

class GoogleMapLoadDefaultPolylineState extends MapState {
  final List<PlaceListPoinModel> data;
  final int show;

  GoogleMapLoadDefaultPolylineState(this.data, this.show);
}

class CleanDefautPolylineState extends MapState {}

class LoadErrorRadiusState extends MapState {
  final String message;
  LoadErrorRadiusState(this.message);
}

class LoadSuccessRadiusState extends MapState {
  final List<PlaceListPoinModel> place;
  LoadSuccessRadiusState(this.place);
}

class ClosedTimeLineBarState extends MapState {
  bool isSearchedRoute = false;
  ClosedTimeLineBarState(this.isSearchedRoute);
}
