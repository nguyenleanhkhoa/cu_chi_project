import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/model/models.dart';

import 'package:cuchi/src/dto/dtos/response.dto.dart';
import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/utils/api/api.g.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:meta/meta.dart';

part 'pin_location_event.dart';
part 'pin_location_state.dart';

class PinLocationBloc extends Bloc<PinLocationEvent, PinLocationState> {
  GoogleMapRepository googleMapRepository;
  final bloc = BaseObserver();
  PinLocationBloc()
      : super(PinLocationInitial(PositionDto(lat: 0.0, lng: 0.0), "", -1));

  @override
  Stream<PinLocationState> mapEventToState(PinLocationEvent event) async* {
    if (event is PinLatLngLocationEvent) {
      yield await eventPinLocation(event.lat, event.lng);
    } else if (event is GetCurrentPinedLocationEvent) {
      yield* eventGetCurrentPinedLocation(event.lat, event.lng);
    }
  }

  Future<PinLocationState> eventPinLocation(double lat, double lng) async {
    return PinLocationInitial(PositionDto(lat: lat, lng: lng), "", -1);
  }

  Stream<PinLocationState> eventGetCurrentPinedLocation(
      double lat, double lng) async* {
    try {
      yield LoadingSearchingLocationState();
      googleMapRepository = GoogleMapRepository();
      PlaceAttachmentModel placeAttachmentDto;

      ResponseDto currentLocation;
      await bloc.callFunctionFuture(func: () async {
        currentLocation = await ApiGlobal.fetchData(
            () => googleMapRepository.getNearByLocation(lat, lng));
      });
      if (currentLocation.message == AppString.ALERT_MESSAGE_CHECK_LOCATION) {
        bloc.error(message: AppString.ALERT_MESSAGE_CHECK_LOCATION);
      }
      if (currentLocation != null && currentLocation.result.length != 0) {
        placeAttachmentDto = currentLocation.result[0];
      }
      yield PinedLocationState(
        PositionDto(
            lat: placeAttachmentDto.point.lat,
            lng: placeAttachmentDto.point.lng),
        placeAttachmentDto.name,
        placeAttachmentDto.id,
      );
    } catch (err) {
      //
    }
  }
}
