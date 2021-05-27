import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:meta/meta.dart';
import 'dart:math' as Math;
part 'scale_bar_event.dart';
part 'scale_bar_state.dart';

class ScaleBarBloc extends Bloc<ScaleBarEvent, ScaleBarState> {
  ScaleBarBloc() : super(ScaleBarInitial());

  @override
  Stream<ScaleBarState> mapEventToState(ScaleBarEvent event) async* {
    if (event is ChangeScaleBarValueEvent) {
      yield await eventChangeScaleBarValue(event.currentPos, event.zoomTmp);
    }
  }

  Future<ScaleBarState> eventChangeScaleBarValue(
    CameraPosition currentPinPosition,
    double zoomTmp,
  ) async {
    var kilometerScale = 156543.03392 *
        Math.cos(currentPinPosition.target.latitude * Math.pi / 180) /
        Math.pow(2, zoomTmp);
    var logLatLocation = currentPinPosition.target.latitude.toStringAsFixed(6) +
        "," +
        currentPinPosition.target.longitude.toStringAsFixed(6) +
        "," +
        (currentPinPosition.zoom)
            .toString()
            .substring(0, currentPinPosition.zoom.toString().indexOf('.'))
            .toString() +
        "z ," +
        (zoomTmp >= 17
            ? (kilometerScale * 1000)
                    .toString()
                    .substring(
                        0, (kilometerScale * 1000).toString().indexOf('.'))
                    .toString() +
                " m"
            : kilometerScale
                    .toString()
                    .substring(0, kilometerScale.toString().indexOf('.'))
                    .toString() +
                " km");

    return ScaleBarValueState(scale: logLatLocation);
  }
}
