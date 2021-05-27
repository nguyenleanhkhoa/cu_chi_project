import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/dto/dtos/current_postion.dto.dart';
import 'package:cuchi/src/dto/dtos/street_route.dto.dart';

import 'package:cuchi/src/dto/dtos/response.dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/utils/api/api.g.dart';
import 'package:cuchi/src/utils/googleMapUtils.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:meta/meta.dart';

import '../../repository/google_map_respository/google_map.respository.dart';
import '../../repository/places_repository/places.repository.dart';
import '../../repository/street_route_repository/street_route.repository.dart';

part 'map_detail_event.dart';
part 'map_detail_state.dart';

class MapDetailBloc extends Bloc<MapDetailEvent, MapDetailState> {
  MapDetailBloc() : super(MapDetailInitial());
  PlacesRepository placesRepository;
  GoogleMapRepository googleMapRepository;
  StreetRouteRepository streetRouteRepository;
  final bloc = BaseObserver();
  @override
  Stream<MapDetailState> mapEventToState(
    MapDetailEvent event,
  ) async* {
    if (event is LoadingPlaceMapEvent) {
      yield* eventGetDetail(event.id, event.placeType);
    } else if (event is SearchStreetMapDetailRouteEvent) {
      yield* eventSearchStreetDetailRoute(event.listRoute, event.radius);
    } else if (event is LoadingInitZoneEvent) {
      yield* eventInitZone();
    } else if (event is LoaddingDefaultPolylineMapDetailEvent) {
      yield* eventLoadingDefaultPolyline();
    }
  }

  Stream<MapDetailState> eventInitZone() async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto res = await ApiGlobal.fetchData(
        () => googleMapRepository.getDefaultZoneMap());

    if (res != null && res.statusCode == 200) {
      yield LoadSuccessInitMapDetailState(res.result);
    }
  }

  Stream<MapDetailState> eventSearchStreetRoute(
      double lat, double lng, int idplace, RouteLatlng lastPoint) async* {
    googleMapRepository = GoogleMapRepository();
    CurrentPositionDto positionTmp = await GoogleMapUtils.getCurrentPosition();

    ResponseDto res = await ApiGlobal.fetchData(() => googleMapRepository
        .getNearByLocation(positionTmp.lat, positionTmp.lng));
    if (res == null) {
      bloc.error(message: AppString.ALERT_MESSAGE_CHECK_LOCATION);
    } else {
      List<PlaceAttachmentModel> data = res.result;
      if (data.length > 0) {
        List<RouteLatlng> listStreetRoute = [];

        streetRouteRepository = StreetRouteRepository();
        var response =
            await streetRouteRepository.getRoute(data.first.id, idplace);
        List<RouteLatLngDto> res = response.result;
        var map = res
            .map((e) => e != null
                ? listStreetRoute.add(RouteLatlng(
                    lat: double.parse(e.lat),
                    lng: double.parse(e.lng),
                    name: e.name))
                : null)
            .toList();

        listStreetRoute
          ..insert(
              0,
              RouteLatlng(
                isDestination: true,
                lat: data.first.point.lat,
                lng: data.first.point.lng,
                name: data.first.name,
              ))
          ..add(lastPoint);
        if (listStreetRoute.length < 2) {
          bloc.error(message: "Không tìm thấy đường đi phù hợp !");
        } else {
          yield SearchRouteDetailSuccessState(
            ResponseDto(
                message: "Get Route success !",
                statusCode: 200,
                result: listStreetRoute),
            Point(lat: lat, lng: lng),
          );
        }
      }
    }
  }

  Stream<MapDetailState> eventSearchStreetDetailRoute(
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
          yield StreetRouteSearchedDetailState(
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

  Stream<MapDetailState> eventGetDetail(int id, String typeplace) async* {
    placesRepository = PlacesRepository();

    var data = await ApiGlobal.fetchData(
        () => placesRepository.getDetailMap(id, typeplace));

    if (data != null && data.statusCode == 200) {
      yield LoadSuccessDetailPlaceState(data.result);
    }
  }

  Stream<MapDetailState> eventLoadingDefaultPolyline() async* {
    googleMapRepository = GoogleMapRepository();

    ResponseDto res =
        await ApiGlobal.fetchData(() => googleMapRepository.getPolylineId(""));

    yield GoogleMapLoadDetailDefaultPolylineState(res.result);
  }
}
