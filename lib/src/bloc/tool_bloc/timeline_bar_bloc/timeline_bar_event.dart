part of 'timeline_bar_bloc.dart';

@immutable
abstract class TimelineBarEvent {}

class TimelineBarShowEvent extends TimelineBarEvent {
  final PlaceLocationModel placeLocationModel;
  final bool show;
  TimelineBarShowEvent(this.show, this.placeLocationModel);
}

class TimelineBarInitEvent extends TimelineBarEvent {
  TimelineBarInitEvent();
}

class TimelineBarSubmitEvent extends TimelineBarEvent {
  final List<int> list;
  TimelineBarSubmitEvent(this.list);
}

class TimelineBarRetreivedLatLngEvent extends TimelineBarEvent {
  final Point coordinate;
  TimelineBarRetreivedLatLngEvent(this.coordinate);
}

class CloseTimelineBarEvent extends TimelineBarEvent {
  final bool isSearchedRoute;

  CloseTimelineBarEvent(this.isSearchedRoute);
}

class SearchingRouteEvent extends TimelineBarEvent {}
