import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/model/models.dart';

import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/repository/places_repository/places.repository.dart';
import 'package:cuchi/src/utils/api/api.g.dart';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'detail_place.event.dart';
part 'detail_place.state.dart';

class DetailPlaceBloc extends Bloc<DetailPlaceEvent, DetailPlaceState> {
  PlacesRepository placeRepository;
  GoogleMapRepository googleMapRepository;

  DetailPlaceBloc() : super(DetailPlaceState.initial());
  final bloc = BaseObserver();
  @override
  Stream<DetailPlaceState> mapEventToState(DetailPlaceEvent event) async* {
    if (event is LoadingGetDetailEvent) {
      yield* _eventGetPlaceDetail(event.id, event.type);
    }
  }

  Stream<DetailPlaceState> _eventGetPlaceDetail(int id, String type) async* {
    try {
      placeRepository = PlacesRepository();
      ResponseDto response = await ApiGlobal.fetchData(
          () => placeRepository.getDetailPlace(id, type));

      if (response.statusCode == 200) {
        yield DetailPlaceState.getDataSuccess(response.result);
      } else if (response.statusCode == 500) {
        yield DetailPlaceState.getDateFail(response.message);
      }
    } catch (er) {
      print(er);
    }
  }
}
