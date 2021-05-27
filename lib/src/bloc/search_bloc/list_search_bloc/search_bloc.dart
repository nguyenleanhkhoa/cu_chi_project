import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/model/models.dart';

import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/utils/api/api.g.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial());
  GoogleMapRepository googleMapRepository;
  final bloc = BaseObserver();
  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is LoadingSearchAddressEvent) {
      yield* eventLoadSearchAddress(
          event.q, event.type, event.loadMore, event.offset);
    } else if (event is DeleteSearchAddressEvent) {
      yield await eventDeleteSearch(event.text, event.showDelete);
    } else if (event is SearchRadiusEvent) {
      yield* eventSearchRadius(event.latlocal, event.lnglocal, event.radius,
          event.loadMore, event.q, event.offset);
    } else if (event is BindingDataShareEvent) {
      yield await eventBindingDataShare(true, event.data);
    } else if (event is LoaddingMarkerHisEvent) {
      yield* eventLoadMarker(event.q);
    } else if (event is LoadingPolygonIdHisEvent) {
      yield* eventLoadingPolygon(event.typeId, event.q);
    } else if (event is LoadingPolylineHisEvent) {
      yield* eventLoadingPolyline(event.q);
    } else if (event is DeletePolylineHisEvent) {
      yield await eventDeletePolyline();
    } else if (event is DeletePolygonIdHisEvent) {
      yield await eventDeletePolygonId(event.typeId);
    } else if (event is DeleteMarkerHisEvent) {
      yield await eventDeleteMarker();
    }
  }

  Future<SearchState> eventDeletePolyline() async {
    return DeleteSuccessPolylineHisState();
  }

  Future<SearchState> eventDeleteMarker() async {
    return DeleteSuccessMarkerHisState();
  }

  Future<SearchState> eventDeletePolygonId(int typeId) async {
    return DeleteSuccessPolygonHisState(typeId);
  }

  Stream<SearchState> eventLoadingPolyline(String q) async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto res =
        await ApiGlobal.fetchData(() => googleMapRepository.getPolylineId(q));

    if (res != null && res.statusCode == 200) {
      yield LoadSuccessPolylineHisState(res.result, true, "Kết quả");
    }
  }

  Stream<SearchState> eventLoadMarker(String q) async* {
    googleMapRepository = GoogleMapRepository();
    ResponseDto res =
        await ApiGlobal.fetchData(() => googleMapRepository.getMarker(q));

    if (res != null && res.statusCode == 200) {
      yield LoadSuccessMarkerHisState(res.result, true, "Kết quả");
    }
  }

  Stream<SearchState> eventLoadingPolygon(int typeId, String q) async* {
    googleMapRepository = GoogleMapRepository();
    ResponseDto res = await ApiGlobal.fetchData(
        () => googleMapRepository.getPolygonId(typeId, q));

    if (res != null && res.statusCode == 200) {
      yield LoadSuccessPolygonHisState(res.result, true, "Kết quả");
    }
  }

  List<PlaceModel> convertData(List<PlaceListPoinModel> data) {
    List<PlaceModel> res = [];
    if (data.length > 0) {
      data.map((i) {
        PlaceModel point = PlaceModel(
            id: i.id, point: i.points[0], type: i.type, name: i.name);
        res.add(point);
      }).toList();
      return res;
    }
    return res;
  }

  Future<SearchState> eventBindingDataShare(
      bool show, List<PlaceListPoinModel> data) async {
    Result res = Result(result: data);
    return BindingDataShareState(res, "Lịch sử", true, true);
  }

  Stream<SearchState> eventSearchRadius(double lat, double lng, int radius,
      bool loadMore, String q, int offset) async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto res;
    bloc.callFunctionFuture(func: () async {
      res = await ApiGlobal.fetchData(() => googleMapRepository.getSearchRadius(
          lat, lng, radius, q, loadMore, offset));
    });
    if (res != null && res.statusCode == 200) {
      if (loadMore) {
        yield LoadMoreSuccessSearchRadiusState(res.result, "Kết quả", true);
      } else {
        yield LoadSuccessSearchRadiusState(res.result, "Kết quả", true);
      }
    } else if (res != null && res.statusCode == 500) {
      bloc.error(message: "Không lấy được dữ liệu!");
    }
  }

  Future<SearchState> eventDeleteSearch(String value, bool show) async {
    return DeleteSearchSuccessAddressState(value, show);
  }

  Stream<SearchState> eventLoadSearchAddress(
      String q, List<String> type, bool loadMore, int offset) async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto data;

    await bloc.callFunctionFuture(func: () async {
      data = await ApiGlobal.fetchData(
          () => googleMapRepository.getSearchAddess(q, type, loadMore, offset));
    });
    if (data != null && data.statusCode == 200) {
      if (loadMore) {
        yield LoadMoreSearchAddressState(data.result, true);
      } else {
        yield LoadSuccessSearchAddressState(data.result, true, "Kết quả");
      }
    }
  }
}
