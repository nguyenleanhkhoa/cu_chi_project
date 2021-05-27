import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:meta/meta.dart';

part 'timeline_bar_event.dart';
part 'timeline_bar_state.dart';

class TimelineBarBloc extends Bloc<TimelineBarEvent, TimelineBarState> {
  TimelineBarBloc() : super(TimelineBarInitial(Point(lat: 0.0, lng: 0.0)));

  @override
  Stream<TimelineBarState> mapEventToState(TimelineBarEvent event) async* {
    if (event is TimelineBarShowEvent) {
      yield await eventShowTimelineBar(event.show, event.placeLocationModel);
    } else if (event is TimelineBarRetreivedLatLngEvent) {
      yield await eventRetreivedLatLng(event.coordinate);
    } else if (event is TimelineBarInitEvent) {
      yield await eventInitTimeLineBar();
    } else if (event is CloseTimelineBarEvent) {
      yield await eventCloseTimeLineBar(event.isSearchedRoute);
    } else if (event is SearchingRouteEvent) {
      yield await eventSearchingRoute();
    }
  }

  Future<TimelineBarState> eventInitTimeLineBar() async {
    return TimelineBarShowState(false, null);
  }

  Future<TimelineBarState> eventShowTimelineBar(
      bool show, PlaceLocationModel pointModel) async {
    final state = this.state;

    if (show && state is TimelineBarShowState) {
      if (state.show) {
        return TimelineBarClosedState(false);
      } else {
        return TimelineBarShowState(true, pointModel);
      }
    } else if (state is TimelineBarRetreivedLngLatState) {
      if ((state as TimelineBarRetreivedLngLatState).show != show) {
        return TimelineBarShowState(show, pointModel);
      } else {
        return TimelineBarShowState(true, pointModel);
      }
    } else {
      return TimelineBarShowState(true, pointModel);
    }
  }

  Future<TimelineBarState> eventRetreivedLatLng(Point point) async {
    return TimelineBarRetreivedLngLatState(true, point);
  }

  Future<TimelineBarState> eventCloseTimeLineBar(bool isSearchedRoute) async {
    return TimelineBarClosedState(isSearchedRoute);
  }

  Future<TimelineBarState> eventSearchingRoute() async {
    return SearchRouteSuccessfullState();
  }
}
