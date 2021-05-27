import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/utils/api/api.g.dart';
import 'package:meta/meta.dart';

part 'pin_map_event.dart';
part 'pin_map_state.dart';

class PinMapBloc extends Bloc<PinMapEvent, PinMapState> {
  PinMapBloc() : super(PinMapInitial());
  GoogleMapRepository googleMapRepository;
  final bloc = BaseObserver();
  @override
  Stream<PinMapState> mapEventToState(
    PinMapEvent event,
  ) async* {
    if (event is LoadingInitMapPinEvent) {
      yield* eventInitMap();
    }
  }

  Stream<PinMapState> eventInitMap() async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto res;
    await bloc.callFunctionFuture(func: () async {
      res = await ApiGlobal.fetchData(
          () => googleMapRepository.getDefaultZoneMap());
    });
    if (res != null && res.statusCode == 200) {
      yield LoadSuccessInitMapPinState(res.result);
    }
  }
}
