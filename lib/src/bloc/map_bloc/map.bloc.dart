import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/dto/dtos/current_postion.dto.dart';
import 'package:cuchi/src/dto/dtos/street_route.dto.dart';

import 'package:cuchi/src/dto/dtos/response.dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/repository/places_repository/places.repository.dart';
import 'package:cuchi/src/repository/street_route_repository/street_route.repository.dart';
import 'package:cuchi/src/utils/api/api.g.dart';
import 'package:cuchi/src/utils/googleMapUtils.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:meta/meta.dart';

part 'map.event.dart';
part 'map.state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  GoogleMapRepository googleMapRepository;
  PlacesRepository placesRepository;
  StreetRouteRepository streetRouteRepository;
  final bloc = BaseObserver();

  MapBloc() : super(MapLoadingState());

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is LoadingGoogleMapEvent) {
      yield await eventLoadingMap();
    } else if (event is LoadedGoogleMapEvent) {
      yield await eventLoadedMap();
    } else if (event is LoadingPolygonIdEvent) {
      yield* eventLoadingPolygon(event.typeId, event.q);
    } else if (event is LoadingPolylineIdEvent) {
      yield* eventLoadingPolyline(event.q);
    } else if (event is LoadingMarkerEvent) {
      yield* eventLoadMarker(event.q);
    } else if (event is DeletePolylineEvent) {
      yield await eventDeletePolyline();
    } else if (event is DeletePolygonIdEvent) {
      yield await eventDeletePolygonId(event.typeId);
    } else if (event is DeleteMarkerEvent) {
      yield await eventDeleteMarker();
    } else if (event is SearchStreetMapRouteEvent) {
      yield* eventSearchStreetRoute(event.listRoute, event.radius);
    } else if (event is BindingSearchEvent) {
      yield await eventShowFilter(event.data);
    } else if (event is BindingDeleteHistoryEvent) {
      yield await eventBindingDelete();
    } else if (event is GoogleMapFinishedEvent) {
      yield await eventFinishGoogleMapState(event.googleMapController);
    } else if (event is LoaddingRadiusEvent) {
      yield* eventSearchRadius(event.latlocal, event.lnglocal, event.radius,
          event.loadMore, event.q, event.offset);
    } else if (event is LoadingInitMapEvent) {
      yield* eventDefaultZone();
    } else if (event is LoaddingDefaultPolylineEvent) {
      yield* eventLoadingDefaultPolyline(event.show);
    } else if (event is ClosedTimeLineBarEvent) {
      yield* eventCloseTimelineBarMapToState(event.isBackHome);
    }
  }

  Stream<MapState> eventDefaultZone() async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto res = await ApiGlobal.fetchData(
        () => googleMapRepository.getDefaultZoneMap());

    try {
      if (res != null && res.statusCode == 200) {
        await Future.delayed(const Duration(milliseconds: 500));
        yield LoadSuccessInitMapState(res.result);
      }
    } catch (err) {
      print(err);
    }
  }

  Stream<MapState> eventSearchRadius(double lat, double lng, int radius,
      bool loadMore, String q, int offset) async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto res;
    await bloc.callFunctionFuture(func: () async {
      res = await ApiGlobal.fetchData(() => googleMapRepository.getSearchRadius(
          lat, lng, radius, q, loadMore, offset));
    });

    if (res != null && res.statusCode == 200) {
      if ((res.result as Result).result.length == 0) {
        bloc.error(message: "Không tìm thấy địa điểm gần bạn !");
        return;
      } else {
        yield LoadSuccessRadiusState((res.result as Result).result);
      }
    } else if (res != null && res.statusCode == 500) {
      bloc.error(message: "Không tìm thấy địa điểm gần bạn !");
      return;
    }
  }

  Future<MapState> eventBindingDelete() async {
    return BindingDeleteSearchState();
  }

  Future<MapState> eventShowFilter(List<PlaceListPoinModel> data) async {
    return BindingDataSearchState(data);
  }

  Future<MapState> eventDeletePolyline() async {
    return DeleteSuccessPolylineState();
  }

  Future<MapState> eventDeleteMarker() async {
    return DeleteSuccessMarkerState();
  }

  Future<MapState> eventDeletePolygonId(int typeId) async {
    return DeleteSuccessPolygonState(typeId);
  }

  Stream<MapState> eventLoadMarker(String q) async* {
    googleMapRepository = GoogleMapRepository();
    ResponseDto res;
    await bloc.callFunctionFuture(func: () async {
      res = await ApiGlobal.fetchData(() => googleMapRepository.getMarker(q));
    });

    if (res != null && res.statusCode == 200) {
      yield LoadSuccessMarkerState(res.result);
    }
  }

  Stream<MapState> eventLoadingPolyline(String q) async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto res;
    await bloc.callFunctionFuture(func: () async {
      res =
          await ApiGlobal.fetchData(() => googleMapRepository.getPolylineId(q));
    });
    if (res != null && res.statusCode == 200) {
      yield LoadSuccessPolylineState(res.result);
    }
  }

  Future<MapState> eventLoadingMap() async {
    return MapLoadingState();
  }

  Future<MapState> eventLoadedMap() async {
    return MapLoadedState();
  }

  Stream<MapState> eventLoadingPolygon(int typeId, String q) async* {
    googleMapRepository = GoogleMapRepository();
    ResponseDto res;

    await bloc.callFunctionFuture(func: () async {
      res = await ApiGlobal.fetchData(
          () => googleMapRepository.getPolygonId(typeId, q));
    });

    if (res != null && res.statusCode == 200) {
      yield LoadSuccessPolygonState(res.result);
    }
  }

  Stream<MapState> eventLoadingDefaultPolyline(int show) async* {
    if (show == 3) {
      yield CleanDefautPolylineState();
      return;
    }
    googleMapRepository = GoogleMapRepository();

    ResponseDto res;
    await bloc.callFunctionFuture(func: () async {
      res = await ApiGlobal.fetchData(
          () => googleMapRepository.getPolylineId(""));
    });
    if (res != null && res.statusCode == 200) {
      if (show == 3) {
        yield CleanDefautPolylineState();
      } else {
        yield GoogleMapLoadDefaultPolylineState(res.result, show);
      }
    }
  }

  Stream<MapState> eventSearchStreetRoute(
      List<PlaceLocationModel> listRouteId, int radius) async* {
    googleMapRepository = GoogleMapRepository();

    List<PlaceLocationModel> listRouteIdTemp = [];
    if (listRouteId.length == 2 && !listRouteId[1].pinLocation) {
      bloc.error(message: AppString.PLEASE_FILL_FULL_INFORMATION);
    } else {
      listRouteIdTemp = listRouteId;
      if (listRouteId.length > 2) {
        listRouteIdTemp = listRouteId
            .where((element) => element.isDestination == true)
            .toList();
      }

      ResponseDto currentLocation;
      PlaceLocationModel firstPlaceLocationModel;

      //if id of list[0].id = 0 ==> get currentlocation
      if (listRouteIdTemp[0].id == 0) {
        CurrentPositionDto positionTmp =
            await GoogleMapUtils.getCurrentPosition();
        await bloc.callFunctionFuture(func: () async {
          currentLocation = await ApiGlobal.fetchData(() => googleMapRepository
              .getNearByLocation(positionTmp.lat, positionTmp.lng));
        });

        if (currentLocation.message == AppString.ALERT_MESSAGE_CHECK_LOCATION) {
          bloc.error(message: AppString.ALERT_MESSAGE_CHECK_LOCATION);
          return;
        }

        if ((currentLocation.result as List).length != 0) {
          PlaceAttachmentModel placeAttachmentModel =
              currentLocation.result[0] as PlaceAttachmentModel;

          listRouteIdTemp[0].id = placeAttachmentModel.id;
          listRouteIdTemp[0].point = placeAttachmentModel.point;
          firstPlaceLocationModel = PlaceLocationModel(
              point: Point(
                  lat: placeAttachmentModel.point.lat,
                  lng: placeAttachmentModel.point.lng),
              id: placeAttachmentModel.id,
              isDestination: true,
              name: listRouteIdTemp[0].name);
        }
      } else {
        // if id of list[0].id != 0 ==> get infor location of first point

        firstPlaceLocationModel = listRouteIdTemp[0];
      }

      int ind = 0;
      List<RouteModel> listRoute = [];
      List<PlaceLocationModel> listNum = [];

      for (var item in listRouteIdTemp) {
        if (ind > 1) {
          listNum.add(listRouteIdTemp[ind - 1]);
        }

        if (listRouteIdTemp.length > 2 && ind > 1) {
          listNum.add(item);
        } else {
          listNum.add(item);
        }

        if (ind % 2 != 0 || listNum.length > 1) {
          listRoute.add(RouteModel(startId: listNum[0], endId: listNum[1]));
          listNum = [];
        }

        ind++;
      }
      ResponseDto response;

      List<RouteLatlng> listStreetRoute = [];
      streetRouteRepository = StreetRouteRepository();
      List<RouteLatLngDto> listRouteTmp = [];
      bloc.loading();
      for (var itemRoute in listRoute) {
        await bloc.callFunctionFuture(func: () async {
          response = await ApiGlobal.fetchData(() => streetRouteRepository
              .getRoute(itemRoute.startId.id, itemRoute.endId.id));
        });

        // tim duoc
        if (response.result != null && response.statusCode != 500) {
          //if list >0
          for (var ite in (response.result as List<RouteLatLngDto>)) {
            listRouteTmp.add(ite);
          }
          listRouteTmp.add(RouteLatLngDto(
            name: itemRoute.endId.name,
            lat: itemRoute.endId.point.lat.toString(),
            lng: itemRoute.endId.point.lng.toString(),
            isDestination: true,
          ));
        }
      }
      bloc.success();
      if (listRouteTmp.isNotEmpty) {
        listStreetRoute.addAll((listRouteTmp.map((e) => RouteLatlng(
            lat: double.parse(e.lat),
            lng: double.parse(e.lng),
            isDestination: e.isDestination ?? false,
            name: e.name ?? ""))));

        listStreetRoute.insert(
          0,
          RouteLatlng(
            isDestination: true,
            name: firstPlaceLocationModel.name,
            lat: firstPlaceLocationModel.point.lat,
            lng: firstPlaceLocationModel.point.lng,
          ),
        );

        if ((response.result as List).length == 1) {
          // yield GoogleMapLoadErrorState(ResponseDto(
          //     message: AppString.HAVE_SAME_POINT, statusCode: 404, result: ""));
          bloc.error(message: AppString.HAVE_SAME_POINT);
        } else {
          yield StreetRouteSearchedState(
            ResponseDto(
                message: "Get Route success !",
                statusCode: 200,
                result: listStreetRoute),
          );
        }
      } else {
        // yield GoogleMapLoadErrorState(ResponseDto(
        //     message: AppString.PLEASE_FILL_FULL_INFORMATION,
        //     statusCode: 404,
        //     result: ""));
        bloc.error(message: AppString.PLEASE_FILL_FULL_INFORMATION);
      }
    }
  }

  Future<MapState> eventFinishGoogleMapState(
      GoogleMapsController googleMapController) async {
    return GoogleMapfinishedState(googleMapController);
  }

  Stream<MapState> eventCloseTimelineBarMapToState(
      bool isSearchedRoute) async* {
    yield ClosedTimeLineBarState(isSearchedRoute);
    // await Future.delayed(const Duration(milliseconds: 500));
    if (!isSearchedRoute) {
      yield CleanDefautPolylineState();
    }
  }
}
