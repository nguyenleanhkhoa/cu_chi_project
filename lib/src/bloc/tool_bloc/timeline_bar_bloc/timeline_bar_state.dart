part of 'timeline_bar_bloc.dart';

@immutable
abstract class TimelineBarState {}

class TimelineBarInitial extends TimelineBarState {
  Point coordinate;
  TimelineBarInitial(this.coordinate);
}

class TimelineBarShowState extends TimelineBarState {
  bool show;
  PlaceLocationModel placeLocationModel;

  TimelineBarShowState(this.show, this.placeLocationModel);
}

class TimeLineBarSubmitedState extends TimelineBarState {
  Point coordinate;
  TimeLineBarSubmitedState(this.coordinate);
}

class TimelineBarRetreivedLngLatState extends TimelineBarState {
  bool show;
  Point coordinate;
  TimelineBarRetreivedLngLatState(this.show, this.coordinate);
}

class TimelineBarClosedState extends TimelineBarState {
  bool isSearchedRoute;
  TimelineBarClosedState(this.isSearchedRoute);
}

class SearchRouteSuccessfullState extends TimelineBarState {
  SearchRouteSuccessfullState();
}
