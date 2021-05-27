import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dtos/response.dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/utils/api/api.g.dart';
import 'package:meta/meta.dart';

part 'near_by_event.dart';
part 'near_by_state.dart';

class NearByBloc extends Bloc<NearByEvent, NearByState> {
  NearByBloc() : super(NearByInitial());
  GoogleMapRepository googleMapRepository;
  final bloc = BaseObserver();
  @override
  Stream<NearByState> mapEventToState(NearByEvent event) async* {
    if (event is DisplayNearByEvent) {
      yield* eventDisplayNearBy(event.show, event.lat, event.lng);
    }
  }

  Stream<NearByState> eventDisplayNearBy(
      bool show, double lat, double lng) async* {
    googleMapRepository = GoogleMapRepository();
    if (show) {
      ResponseDto res;
      await bloc.callFunctionFuture(func: () async {
        res = await ApiGlobal.fetchData(
            () => googleMapRepository.getNearByLocation(lat, lng));
      });
      print("loading finished....");
      if (res != null && res.statusCode == 200) {
        yield NearByShowState(show, res.result);
      }
    } else {
      yield NearByShowState(show, []);
    }
  }
}
