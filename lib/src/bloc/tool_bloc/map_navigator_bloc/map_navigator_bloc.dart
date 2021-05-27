import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'map_navigator_event.dart';
part 'map_navigator_state.dart';

class MapNavigatorBloc extends Bloc<MapNavigatorEvent, MapNavigatorState> {
  MapNavigatorBloc() : super(MapNavigatorInitial(0.0, 0.0, 15.0, false));

  @override
  Stream<MapNavigatorState> mapEventToState(MapNavigatorEvent event) async* {
    if (event is ShowMapNavigationEvent) {
      yield await eventShowMapNavigator(event.show);
    } else {
      yield MapNavigatorInitial(0.0, 0.0, 15.0, false);
    }
  }

  Future<MapNavigatorState> eventShowMapNavigator(bool show) async {
    final currentState = state;
    if (state is MapNavigationShowSuccess) {
      if (state.show == true) {
        return MapNavigationShowSuccess(
            currentState.lat, currentState.lng, currentState.zoom, false);
      } else {
        return MapNavigationShowSuccess(
            currentState.lat, currentState.lng, currentState.zoom, true);
      }
    } else {
      return MapNavigationShowSuccess(
          currentState.lat, currentState.lng, currentState.zoom, true);
    }
  }
}
