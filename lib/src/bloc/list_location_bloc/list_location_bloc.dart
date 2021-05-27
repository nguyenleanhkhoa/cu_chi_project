import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/utils/api/api.g.dart';
import 'package:meta/meta.dart';

part 'list_location_event.dart';
part 'list_location_state.dart';

class ListLocationBloc extends Bloc<ListLocationEvent, ListLocationState> {
  GoogleMapRepository googleMapRepository;
  ListLocationBloc() : super(ListLocationInitial());
  final bloc = BaseObserver();
  @override
  Stream<ListLocationState> mapEventToState(ListLocationEvent event) async* {
    if (event is SearchLocationEvent) {
      yield* eventLoadSearch(event.q, event.loadMore, event.offset);
    } else if (event is InitSearchLocationEvent) {
      yield await eventInit();
    }
  }

  Stream<ListLocationState> eventLoadSearch(
      String q, bool loadMore, int offset) async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto data = await ApiGlobal.fetchData(() =>
        googleMapRepository.getSearchAddess(q, ["places"], loadMore, offset));

    if (data.statusCode == 200) {
      if (loadMore) {
        yield LoadMoreSearchLocationState(data.result, true);
      } else {
        yield LoadSuccessSearchLocationState(data.result, true, "Kết quả");
      }
    }
  }

  Future<ListLocationState> eventInit() async {
    return ListLocationInitial();
  }
}
