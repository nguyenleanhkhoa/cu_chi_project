import 'dart:async';
import 'dart:typed_data';

import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/datas/data_morkup.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/dto/dtos/current_postion.dto.dart';
import 'package:cuchi/src/model/models.dart';

import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/googleMapUtils.dart';
import 'package:cuchi/src/utils/resources/colors_string.resource.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/src/utils/resources/image_string.resource.dart';
import 'package:cuchi/src/widgets/widgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

import '../../../styles/theme.dart';

class MapOverviewDetail extends StatefulWidget {
  static const routeName = "/map-overview-detail";

  @override
  _MapOverviewDetailState createState() => _MapOverviewDetailState();
}

class _MapOverviewDetailState extends State<MapOverviewDetail>
    with WidgetsBindingObserver {
  MapDetailBloc mapDetailBloc;
  ScaleBarBloc scaleBarBloc;
  ZoomInOutBloc zoomInOutBloc;
  ToolMapBloc _toolMapBloc;
  GoogleMapsController _googleMapcontroller;
  CameraPosition currentPinPosition;
  DetailMapBloc detailMapBloc;
  MapNavigatorBloc mapNavigatorBloc;
  TimelineBarBloc timelineBarBloc;

  double zoomTmp = 17;
  LatLng targetTmp;
  bool _isInit = false;
  bool _isShowHistoryList = false;
  String logLatLocation = "";
  List<Polyline> mypolyline = [];

  List<Polyline> mypolylineDefault = [];
  List<Uint8List> listAlphalbetPoint = [];

  List<Map<String, dynamic>> listLocationDirection = [];
  List<Polyline> polylineStreetSearched = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CameraPosition currentPos = CameraPosition(
      bearing: 0.0,
      target: LatLng(11.143686, 106.464185),
      tilt: 0.0,
      zoom: 15.5);
  PositionDto currentPosition;
  // var geoLocator = Geolocator();
  Future<String> getJsonFile(String part) async {
    return await rootBundle.loadString(part);
  }

  void setMapStype(String mapstyle) {
    _googleMapcontroller.setMapStyle(mapstyle);
  }

  changeMapMode() {
    getJsonFile('assets/map_style.json').then((value) => setMapStype(value));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _googleMapcontroller
          .setMapStyle("[]"); // fix map will gone when app on resume
    } else if (state == AppLifecycleState.inactive) {
      print("inactive");
    }
  }

  var kilometerScale = 0.0;

  void cleanMap() {
    if (setMarker.length > 0) {
      _googleMapcontroller.removeMarkers(setMarker.toList());
    }
    if (polygonSet.length > 0) {
      _googleMapcontroller.removePolygons(polygonSet.toList());
    }
    if (mypolyline.length > 0) {
      _googleMapcontroller.removePolylines(mypolyline);
    }
    if (mypolylineDefault.length > 0) {
      _googleMapcontroller.removePolylines(mypolylineDefault);
    }
    // param.dataHistory = [];

    /// clean all
  }

  // on camera move
  void onCameraMapMoving(CameraPosition cameraPosition) {
    currentPos = cameraPosition;
    currentPinPosition = cameraPosition;
    currentPosition = PositionDto(
        lat: cameraPosition.target.latitude,
        lng: cameraPosition.target.longitude,
        zoom: cameraPosition.zoom);
    zoomInOutBloc.add(GetCurrentLngLatEvent(
        cameraPosition.target.longitude, cameraPosition.target.latitude));
    if (!_isInit) {
      LatLng latLngPostion = cameraPosition.target;
      targetTmp = latLngPostion;
      zoomTmp = cameraPosition.zoom;
    }
    scaleBarBloc.add(ChangeScaleBarValueEvent(currentPos, zoomTmp));
  }

  LatLng latLngPostion = LatLng(11.144777, 106.462759);

  void renderPolyline(List<PlaceListPoinModel> data) {
    for (var item in data) {
      mypolyline.add(Polyline(
        polylineId: PolylineId(item.id.toString()),
        color: Color.fromRGBO(247, 208, 99, 1),
        width: 4,
        consumeTapEvents: true,
        onTap: () {
          //   detailMapBloc.add(LoadingDetailPlaceInMapEvent(item.id, item.type));
        },
        points: castPoint(item.points),
      ));
    }
  }

  List<RouteLatlng> listStreetTmp = [];

  List<StreetRouteDto> listStreetRoute = [];

  var firstPoint;
  var endPoint;
  // LatLngBounds latLngBounds;

  List<String> listAlphalbet = ["pin", "A", "B", "C", "D", "E", "F"];
  var pointDestination;
  Future<void> customMarkerFirstPointEndPoint() async {
    Uint8List firstIconMarker =
        await UtilsCommon.getBytesFromAsset(ImageString.PIN_LOCATION, 100);
    firstPoint = BitmapDescriptor.fromBytes(firstIconMarker);
    endPoint = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(24, 24)),
        ImageString.PIN_DESTINATION_LOCATION);
    for (var i = 0; i < listAlphalbet.length; i++) {
      pointDestination = listAlphalbet[i];
      Uint8List iconMarker = await UtilsCommon.getBytesFromAsset(
          'assets/icons/$pointDestination.png', 100);
      listAlphalbetPoint.add(iconMarker);
    }
  }

  Future<void> renderDefaultPolyline(List<PlaceListPoinModel> data) async {
    await Future.delayed(new Duration(milliseconds: 1000));
    for (var item in data) {
      mypolylineDefault.add(Polyline(
        polylineId: PolylineId(item.name),
        color: AppColors.defaultPolylineStreet,
        width: 4,
        geodesic: false,
        points: castPoint(item.points),
      ));
    }

    _googleMapcontroller.addPolylines(mypolylineDefault);
  }

  void renderStreetRoute(List<RouteLatlng> listStreet, Point firstRoute) {
    if (listStreet.length != 0) {
      setMarker.clear();
      var index = 0;
      var iconMarker;
      var anchor;

      LatLng firstMarker;
      LatLng endMarker;
      for (var item in listStreet) {
        if (index == 0) {
          firstMarker = LatLng(item.lat, item.lng);
          iconMarker = firstPoint;
          anchor = Offset(0.5, 1.0);
          setMarker.add(
            Marker(
              anchor: anchor,
              icon: iconMarker,
              infoWindow: InfoWindow(title: item.name),
              markerId: MarkerId(item.name),
              draggable: false,
              onTap: () {},
              position: LatLng(item.lat, item.lng),
            ),
          );
        } else if (index == listStreet.length - 1) {
          endMarker = LatLng(item.lat, item.lng);
          iconMarker = endPoint;
          anchor = Offset(0.5, 1.0);
          setMarker.add(
            Marker(
              anchor: anchor,
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: item.name),
              markerId: MarkerId(item.name),
              draggable: false,
              onTap: () {},
              position: LatLng(item.lat, item.lng),
            ),
          );
        }

        index++;
      }
      LatLng temp;

      if (firstMarker.latitude > endMarker.latitude) {
        temp = firstMarker;
        firstMarker = endMarker;
        endMarker = temp;
      }
      // latLngBounds = LatLngBounds(southwest: firstMarker, northeast: endMarker);

      mypolyline.clear();

      mypolyline.add(Polyline(
        polylineId: PolylineId(listStreet[1].name),
        color: LightTheme.colorMain,
        width: 4,
        consumeTapEvents: true,
        points: castRoute(listStreet),
      ));

      _googleMapcontroller.addPolylines(mypolyline);
      Timer(Duration(milliseconds: 300), () {
        CameraPosition cameraPos = CameraPosition(
            bearing: 0.0,
            target: LatLng(endMarker.latitude, endMarker.longitude),
            zoom: 17);

        _googleMapcontroller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
      });
    }
  }

  List<Polyline> inItpolyline = [];

  Future<void> renderInItMap(List<PlaceListPoinModel> data) async {
    for (var item in data) {
      inItpolyline.add(Polyline(
        polylineId: PolylineId("init_map" + item.id.toString()),
        color: AppColors.defaultPolylineGoogleMap,
        width: 2,
        geodesic: true,
        points: castPoint(item.points),
      ));
    }
    _googleMapcontroller.addPolylines(inItpolyline);
  }

  List<LatLng> castRoute(List<RouteLatlng> routes) {
    List<LatLng> latlng = [];
    routes.map((i) {
      LatLng point = LatLng(i.lat, i.lng);
      latlng.add(point);
    }).toList();
    return latlng;
  }

  List<LatLng> castPoint(List<Point> points) {
    List<LatLng> latlng = [];
    points.map((i) {
      LatLng point = LatLng(i.lat, i.lng);
      latlng.add(point);
    }).toList();
    return latlng;
  }

  List<ListMarker> listCustomMarker;

  @override
  void initState() {
    super.initState();
    cleanMap();
    // customMarkerFirstPointEndPoint();
    currentPosition = PositionDto(
        lat: currentPos.target.latitude, lng: currentPos.target.longitude);
    _isInit = true;
    //convertMarker();

    //init bloc provider
    mapDetailBloc = BlocProvider.of<MapDetailBloc>(context);

    scaleBarBloc = BlocProvider.of<ScaleBarBloc>(context);
    zoomInOutBloc = BlocProvider.of<ZoomInOutBloc>(context);
    detailMapBloc = BlocProvider.of<DetailMapBloc>(context);
    _toolMapBloc = BlocProvider.of<ToolMapBloc>(context);
    mapNavigatorBloc = BlocProvider.of<MapNavigatorBloc>(context);
    timelineBarBloc = BlocProvider.of<TimelineBarBloc>(context);
    mapNavigatorBloc.add(InitMapNavigatorEvent());
    // mapBloc.add(LoadingInitMapDetailEvent());
    _toolMapBloc.add(DisplayToolMapEvent(true));
    customMarkerFirstPointEndPoint();
    initGoogleMap();
    mapDetailBloc.add(LoaddingDefaultPolylineMapDetailEvent());

    Timer(new Duration(milliseconds: 1000), () {
      mapDetailBloc.add(LoadingInitZoneEvent());
    });

    //userInforBloc = BlocProvider.of<UserInforBloc>(context);
  }

  void initGoogleMap() {
    _googleMapcontroller = GoogleMapsController(
      // initialPolygons: myPolygon(),
      initialPolylines: mypolyline.toSet(),
      initialCameraPosition: currentPos,
      onCameraMove: (value) => onCameraMapMoving(value),
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      compassEnabled: false,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: true,
    );
  }

  @override
  void didChangeDependencies() {
    _isInit = false;

    scaleBarBloc.add(ChangeScaleBarValueEvent(currentPos, currentPos.zoom));

    super.didChangeDependencies();
  }

  // list render search
  Result data;

  Set<Marker> setMarker = new Set();

  void renderPolygon(List<PlaceListPoinModel> data) {
    data.forEach(
      (item) => {addPoygon(item)},
    );
  }

  void addPoygon(PlaceListPoinModel data) {
    String namePolygon =
        ConvertVietNamese.unsign(data.name).replaceAll(" ", "-").toLowerCase();
    //Set<Polygon> polygonSet = new Set();

    data.points
        .forEach((item) => {polygonCoords.add(LatLng(item.lat, item.lng))});
    polygonSet.add(
      Polygon(
        onTap: () {
          //Todo new bloc

          // detailMapBloc.add(LoadingDetailPlaceInMapEvent(data.id, data.type));
        },
        consumeTapEvents: true,
        polygonId: PolygonId(data.type + "-" + namePolygon),
        points: polygonCoords,
        strokeWidth: 1,
        fillColor: data.type == "rivers"
            ? Colors.blue[50]
            : data.type == "plants"
                ? Colors.green[50]
                : Colors.brown[50],
        strokeColor: data.type == "rivers"
            ? Colors.blue
            : data.type == "plants"
                ? Colors.green
                : Colors.brown,
      ),
    );

    polygonCoords = [];
  }

  void renderMarker(List<PlaceModel> data) {
    setMarker.clear();
    for (var item in data) {
      setMarker.add(
        Marker(
          // icon: item.marker != 0
          //     ? listCustomMarker
          //         .firstWhere((element) => element.marker == item.marker)
          //         .bitmapDescriptor
          //     : null,
          infoWindow: InfoWindow(title: item.name),
          markerId: MarkerId(item.id.toString()),
          draggable: false,
          onTap: () {
            //detailMapBloc.add(LoadingDetailPlaceInMapEvent(item.id, item.type));
          },
          position: LatLng(item.point.lat, item.point.lng),
        ),
      );
    }
  }

  Set<Polygon> polygonSet = new Set();
  List<LatLng> polygonCoords = [];
  PlaceListDetailModel detailInMap;

  void convertMarker() async {
    listCustomMarker = await convertByteMarker();
    // listCustomMarker = [];
    // BitmapDescriptor castMarker;
    // for (int i = 0; i < Data.iconNames.length; i++) {
    //   Uint8List firstIconMarker =
    //       await UtilsCommon.getBytesFromAsset(Data.iconNames[i], 80);
    //   castMarker = BitmapDescriptor.fromBytes(firstIconMarker);
    //   listCustomMarker
    //       .add(ListMarker(marker: i + 1, bitmapDescriptor: castMarker));
    // }
  }

  Future<List<ListMarker>> convertByteMarker() async {
    listCustomMarker = [];
    BitmapDescriptor castMarker;
    for (int i = 0; i < Data.iconNames.length; i++) {
      Uint8List firstIconMarker =
          await UtilsCommon.getBytesFromAsset(Data.iconNames[i], 80);
      castMarker = BitmapDescriptor.fromBytes(firstIconMarker);
      listCustomMarker
          .add(ListMarker(marker: i + 1, bitmapDescriptor: castMarker));
    }
    return listCustomMarker;
  }

  final bloc = BaseObserver();
  void locatePosition() async {
    CurrentPositionDto position;
    await bloc.callFunctionFuture(func: () async {
      position = await GoogleMapUtils.getCurrentPosition();
    });

    if (!position.isCurrentValid) {
      bloc.error(message: AppString.ALERT_MESSAGE_CHECK_LOCATION);
    }

    currentPosition =
        PositionDto(lat: position.lat, lng: position.lng, zoom: 17);
    // boundToDefaultLocation();

    try {
      targetTmp = LatLng(position.lat, position.lng);

      _googleMapcontroller.myLocationEnabled = true;

      _googleMapcontroller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(target: targetTmp, zoom: 15.5)));
    } catch (error) {
      bloc.error(message: AppString.GPS_NOT_SUPPORT_PLATFORM);
    }

    ///time outs
  }

  Future<void> searchRoute(SearchRouteDetailSuccessState state) async {
    bloc.loading();
    await Future.delayed(new Duration(milliseconds: 2000));
    _isShowHistoryList = false;
    if (state.listResponse.result != null &&
        (state.listResponse.result as List).length != 0) {
      listStreetTmp = [];
      listStreetRoute = [];
      for (var itemRoute in state.listResponse.result) {
        listStreetTmp.add(RouteLatlng(
            lat: (itemRoute.lat), lng: (itemRoute.lng), name: itemRoute.name));
      }

      renderStreetRoute(listStreetTmp, state.currentPoint);

      _googleMapcontroller.markers = setMarker;

      // zoom to location after 1s
    }
    bloc.success();
  }

  @override
  void dispose() {
    mapNavigatorBloc.add(InitMapNavigatorEvent());
    detailMapBloc.add(ShowDescriptionEvent(false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var idPlace = ModalRoute.of(context).settings.arguments;
    if (idPlace is ParamMapDetail) {
      switch (idPlace.type) {
        case 1:
          mapDetailBloc.add(LoadingPlaceMapEvent(
              idPlace.paramRequest.id, idPlace.paramRequest.type));
          detailMapBloc.add(LoadingDetailPlaceInMapEvent(
              idPlace.paramRequest.id, idPlace.paramRequest.type));
          break;
        case 2:
          // timelineBarBloc.add(TimelineBarShowEvent(
          //     true, Point(lat: currentPosition.lat, lng: currentPosition.lng)));
          // mapBloc.add(SearchStreetRouteEvent(
          //     idPlace: idPlace.paramRequest.idPlace,
          //     lastPoint: idPlace.paramRequest.pointEnd));
          // detailMapBloc.add(ShowDescriptionEvent(false));

          break;
      }
    } else if (idPlace is PlaceLocationModel) {
      timelineBarBloc.add(TimelineBarShowEvent(true, idPlace));
    }

    //
    Widget toolMap() {
      return BlocBuilder<ToolMapBloc, ToolMapState>(builder: (context, state) {
        if (state is DisPlayToolMapState) {
          if (state.show) {
            return Expanded(
              flex: 2,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ZoomInOut(
                            googleMapcontroller: _googleMapcontroller,
                            target: targetTmp,
                            zoomNumber: zoomTmp,
                          ),
                          SizedBox(height: 10),
                          CircleButtonMapWidget(
                            onTap: () {
                              // locatePosition(true);
                              CameraPosition cameraPos = CameraPosition(
                                  bearing: 0.0,
                                  target: LatLng(
                                      GoogleMapUtils.getDefaultLocation()
                                          .latitude,
                                      GoogleMapUtils.getDefaultLocation()
                                          .longitude),
                                  zoom: 15.5);

                              _googleMapcontroller.animateCamera(
                                  CameraUpdate.newCameraPosition(cameraPos));
                            },
                            icon: Icons.assistant_photo_sharp,
                          ),
                          SizedBox(height: 10),
                          CircleButtonMapWidget(
                            onTap: locatePosition,
                            icon: Icons.my_location,
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              mapNavigatorBloc
                                  .add(ShowMapNavigationEvent(true));
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: AssetImage(
                                      ImageString.MAP_NAVIGATOR_ICON),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(width: 0.0, height: 0.0);
          }
        }
        return Container(width: 0.0, height: 0.0);
      });
    }

    Widget bottomBar() {
      return Container(
        height: 250.0,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                MapNavigatorWidget(
                  currentPosition: currentPos,
                  googleMapcontroller: _googleMapcontroller,
                  onBottomPressed: () {
                    GoogleMapUtils.onNavigateBottomClick(
                        _googleMapcontroller, currentPosition);
                  },
                  onLeftPressed: () {
                    GoogleMapUtils.onNavigateLeftClick(
                        _googleMapcontroller, currentPosition);
                  },
                  onRightPressed: () {
                    GoogleMapUtils.onNavigateRigthClick(
                        _googleMapcontroller, currentPosition);
                  },
                  onTopPressed: () {
                    GoogleMapUtils.onNavigateTopClick(
                        _googleMapcontroller, currentPosition);
                  },
                ),
                toolMap(),
              ],
            ),
          ],
        ),
      );
    }

    _googleMapcontroller.removePolylines(mypolylineDefault);
    _googleMapcontroller.removePolylines(mypolyline);
    return WillPopScope(
      onWillPop: () {
        if (_isShowHistoryList) {
          // searchBloc.add(ShowHistoryEvent(false, []));
        } else {
          // Navigator.pop(context, false);
        }
        return Future.value(false);
      },
      child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              /// bloc main
              BlocConsumer<MapDetailBloc, MapDetailState>(
                listener: (context, state) {
                  //
                },
                buildWhen: (oldState, currentState) {
                  if (currentState is SearchRouteDetailFailState) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  // cleanMap();
                  if (state is LoadSuccessInitMapDetailState) {
                    renderInItMap(state.data);
                  } else if (state is LoadSuccessDetailPlaceState) {
                    _isShowHistoryList = true;
                    bloc.loading();
                    switch (state.detail.type) {
                      case "places":
                        renderMarker([
                          PlaceModel(
                            id: state.detail.id,
                            point: state.detail.points[0],
                            name: state.detail.name,
                            type: state.detail.type,
                            marker: state.detail.marker,
                          )
                        ]);
                        _googleMapcontroller.markers = setMarker;
                        break;

                      case "streets":
                        mypolyline = [];
                        renderPolyline([
                          PlaceListPoinModel(
                            id: state.detail.id,
                            points: state.detail.points,
                            name: state.detail.name,
                            type: state.detail.type,
                          )
                        ]);
                        _googleMapcontroller.addPolylines(mypolyline);
                        break;

                      default:
                        polygonSet = Set();

                        renderPolygon([
                          PlaceListPoinModel(
                            id: state.detail.id,
                            points: state.detail.points,
                            name: state.detail.name,
                            type: state.detail.type,
                          )
                        ]);
                        _googleMapcontroller.polygons = polygonSet;
                        break;
                    }
                    bloc.success();
                    Timer(Duration(milliseconds: 500), () {
                      CameraPosition cameraPos = CameraPosition(
                          bearing: 0.0,
                          target: LatLng(state.detail.points[0].lat,
                              state.detail.points[0].lng),
                          zoom: 16);

                      _googleMapcontroller.animateCamera(
                          CameraUpdate.newCameraPosition(cameraPos));
                    });
                  } else if (state is StreetRouteSearchedDetailState) {
                    if (state.listResponse.result != null &&
                        (state.listResponse.result as List).length != 0) {
                      _googleMapcontroller.removeMarkers(setMarker.toList());
                      setMarker = Set();
                      _googleMapcontroller
                          .removePolylines(polylineStreetSearched.toList());
                      polylineStreetSearched = [];

                      listStreetTmp = [];
                      listStreetRoute = [];
                      for (var itemRoute in state.listResponse.result) {
                        listStreetTmp.add(itemRoute);
                      }

                      GoogleMapUtils.renderStreetRoute(
                          listStreetTmp,
                          setMarker,
                          listAlphalbetPoint,
                          firstPoint,
                          polylineStreetSearched,
                          _googleMapcontroller);

                      _googleMapcontroller.addPolylines(mypolyline);
                      _googleMapcontroller.markers = setMarker;
                    }
                  } else if (state is GoogleMapLoadDetailDefaultPolylineState) {
                    renderDefaultPolyline(state.data);
                  }
                  changeMapMode();
                  return Container(
                    child: GoogleMaps(controller: _googleMapcontroller),
                  );
                },
              ),
              Positioned(
                top: 40,
                left: 25,
                child: CircleButtonMapWidget(
                  icon: Icons.chevron_left,
                  onTap: () {
                    cleanMap();
                    detailMapBloc.add(ShowDescriptionEvent(false));
                    _toolMapBloc.add(DisplayToolMapEvent(true));
                    Navigator.of(context).pop();
                  },
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      bottomBar(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ScaleBarWidget(),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DescriptionPlaceWidget(
                        onTap: () {
                          detailMapBloc.add(ShowDescriptionEvent(false));
                          _toolMapBloc.add(DisplayToolMapEvent(true));
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
              ),
              TimelineDirectionCustom(context: this.context),
            ],
          )),
    );
  }
}
