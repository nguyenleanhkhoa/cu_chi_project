part of 'map_detail_bloc.dart';

@immutable
abstract class MapDetailState {}

class MapDetailInitial extends MapDetailState {}

class LoadSuccessDetailPlaceState extends MapDetailState {
  final PlaceListDetailModel detail;
  LoadSuccessDetailPlaceState(this.detail);
}

class LoadFailDetailsPlaceInMapState extends MapDetailState {
  final String errorMessage;
  LoadFailDetailsPlaceInMapState(this.errorMessage);
}

class SearchRouteDetailSuccessState extends MapDetailState {
  final ResponseDto listResponse;
  final Point currentPoint;
  SearchRouteDetailSuccessState(this.listResponse, this.currentPoint);
}

class SearchRouteDetailFailState extends MapDetailState {
  final String errorMessage;
  SearchRouteDetailFailState(this.errorMessage);
}

class StreetRouteSearchedDetailState extends MapDetailState {
  final ResponseDto listResponse;

  StreetRouteSearchedDetailState(this.listResponse);
}

class LoadSuccessInitMapDetailState extends MapDetailState {
  final List<PlaceListPoinModel> data;
  LoadSuccessInitMapDetailState(this.data);
}

class GoogleMapLoadDetailDefaultPolylineState extends MapDetailState {
  final List<PlaceListPoinModel> data;

  GoogleMapLoadDetailDefaultPolylineState(this.data);
}
