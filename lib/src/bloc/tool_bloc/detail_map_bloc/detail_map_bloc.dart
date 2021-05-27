import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/repository/places_repository/places.repository.dart';
import 'package:cuchi/src/utils/api/api.g.dart';
import 'package:meta/meta.dart';

part 'detail_map_event.dart';
part 'detail_map_state.dart';

class DetailMapBloc extends Bloc<DetailMapEvent, DetailMapState> {
  DetailMapBloc() : super(DetailMapInitial());
  PlacesRepository placesRepository;
  final bloc = BaseObserver();
  @override
  Stream<DetailMapState> mapEventToState(
    DetailMapEvent event,
  ) async* {
    if (event is LoadingDetailPlaceInMapEvent) {
      yield* eventGetDetailInMap(event.id, event.placeType);
    } else if (event is ShowDescriptionEvent) {
      yield await eventShowDescription(event.show);
    }
  }

  Future<DetailMapState> eventShowDescription(bool show) async {
    return ShowDescriptionState(show);
  }

  Stream<DetailMapState> eventGetDetailInMap(int id, String typeplace) async* {
    placesRepository = PlacesRepository();

    ResponseDto data;
    await bloc.callFunctionFuture(func: () async {
      data = await ApiGlobal.fetchData(
          () => placesRepository.getDetailPlaceInMap(id, typeplace));
    });
    if (data.statusCode == 200) {
      yield LoadSuccessDetailPlaceInMapState(data.result);
    } else if (data.statusCode == 500) {
      yield LoadFailDetailPlaceInMapState(data.message);
    }
  }
}
