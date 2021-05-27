part of 'map_navigator_bloc.dart';

@immutable
abstract class MapNavigatorState {
  bool show = false;
  final double lat;
  final double lng;
  final double zoom;

  MapNavigatorState(this.lat, this.lng, this.zoom, this.show);
}

class MapNavigatorInitial extends MapNavigatorState {
  MapNavigatorInitial(double lat, double lng, double zoom, bool show)
      : super(lat, lng, zoom, show);
}

class MapNavigationShowState extends MapNavigatorState {
  MapNavigationShowState(double lat, double lng, double zoom, bool show)
      : super(lat, lng, zoom, show);
}

class MapNavigationShowSuccess extends MapNavigatorState {
  MapNavigationShowSuccess(double lat, double lng, double zoom, bool show)
      : super(lat, lng, zoom, show);
}
