import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'zoom_in_out_event.dart';
part 'zoom_in_out_state.dart';

class ZoomInOutBloc extends Bloc<ZoomInOutEvent, ZoomInOutState> {
  ZoomInOutBloc() : super(ZoomInOutInitial());

  @override
  Stream<ZoomInOutState> mapEventToState(ZoomInOutEvent event) async* {
    if (event is GetCurrentLngLatEvent) {
      yield await eventGetCurrentLngLat(event.lng, event.lat);
    }
  }

  Future<ZoomInOutState> eventGetCurrentLngLat(double lng, double lat) async {
    return CurrentLngLatState(lng, lat);
  }
}
