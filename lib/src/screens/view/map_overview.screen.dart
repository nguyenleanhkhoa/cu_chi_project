import 'dart:async';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/datas/data_morkup.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/dto/dtos/current_postion.dto.dart';
import 'package:cuchi/src/dto/dtos/street_route.dto.dart';
import 'package:cuchi/src/model/models.dart';

import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/googleMapUtils.dart';
import 'package:cuchi/src/utils/resources/colors_string.resource.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/src/utils/resources/image_string.resource.dart';
import 'package:cuchi/src/widgets/widgets.dart';

import 'package:cuchi/styles/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../screen.dart';

class MapOverviewScreen extends StatefulWidget {
  static const routeName = "/map-overview";

  @override
  _MapOverviewScreenState createState() => _MapOverviewScreenState();
}

class _MapOverviewScreenState extends State<MapOverviewScreen>
    with
        WidgetsBindingObserver,
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin {
  bool checkNetworkConnection = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // declare variable
  // final baseBloc = BaseObserver();
  MapBloc mapBloc;
  ScaleBarBloc scaleBarBloc;
  NearByBloc nearByBloc;
  TimelineBarBloc timelineBarBloc;
  TabBarTypeBloc tabBarTypeBloc;
  UserInforBloc userInforBloc;
  SearchBloc searchBloc;
  ButtonInSearchBloc buttonInSearchBloc;
  ZoomInOutBloc zoomInOutBloc;
  DetailMapBloc detailMapBloc;
  ButtonMapBloc buttonMapBloc;
  MapNavigatorBloc mapNavigatorBloc;
  GoogleMapsController _googleMapcontroller;
  ToolMapBloc _toolMapBloc;
  FilterRadiusBloc _filterRadiusBloc;
  ListLocationHistoryBloc listLocationHistoryBloc;
  final bloc = BaseObserver();

  LatLng currentLatLng = GoogleMapUtils.getDefaultLocation();

  LatLng latLngPostion = GoogleMapUtils.getDefaultLocation();

  CameraPosition currentPinPosition;
  double zoomTmp = 16;
  LatLng targetTmp;
  bool _isInit = false;
  bool _isShowHistoryList = false;
  bool _isShowNearBy = true; //
  bool _isShowButtonFilterRadius = false;
  bool _isShowFilterRadius = false;
  bool _isPinLocation = false;
  String logLatLocation = "";

  List<RouteLatlng> listStreetTmp = [];
  List<BitmapDescriptor> listIconMarker = [];
  var firstPoint;
  var endPoint;
  List<Uint8List> listAlphalbetPoint = [];
  var pointA;
  var pointB;

  FocusNode searchFocusScope;
  String initRadius;
  List<StreetRouteDto> listStreetRoute = [];
  List<Map<String, dynamic>> listLocationDirection = [];
  CameraPosition currentPos = CameraPosition(
      bearing: 0.0,
      target: GoogleMapUtils.getDefaultLocation(),
      tilt: 0.0,
      zoom: 15.5);
  PositionDto currentPosition;
  double currentLat;
  double currentLng;

  TabController controller;
  List<Polyline> polylineStreetSearched = [];

  TextEditingController searchController;
  var kilometerScale = 0.0;
  List<PlaceLocationModel> listPlaceLocation = [];

  List<PlaceListPoinModel> dataSearch = [];

  Set<Polygon> polygonSet = new Set();
  List<LatLng> polygonCoords = [];
  Future<SharedPreferences> _prefs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        break;
      default:
        bloc.warning(message: "Error network !");

        break;
    }
  }

  Future<void> getRadius() async {
    final SharedPreferences prefs = await _prefs;
    final int radius = (prefs.getInt('radiusValue') ?? 0);
    initRadius = radius == 0 ? "0" : radius.toString();
  }

  void cleanMap(int type, String nameType) {
    switch (type) {
      case 1:

        ///clear marker
        dataSearch.removeWhere((element) => element.type == 'places');
        _googleMapcontroller.removeMarkers(setMarkerSearch.toList());
        setMarkerSearch = Set();
        param.radius = 0;
        _isShowFilterRadius = false;
        break;
      case 2:

        /// clear polyline
        dataSearch.removeWhere((element) => element.type == 'streets');
        _googleMapcontroller.removePolylines(mypolyline.toList());
        mypolyline = [];
        break;
      case 3:

        /// clean polygon and type name
        dataSearch.removeWhere((element) => element.type == nameType);
        _googleMapcontroller.removePolygons(polygonSet
            .where((val) => val.polygonId.value.contains(nameType))
            .toList()) as Set;
        break;
      case 0:
        removeRadius();
        // delete marker
        _googleMapcontroller.removeMarkers(setMarker.toList());
        setMarker = Set();

        _googleMapcontroller.removeMarkers(setMarkerSearch.toList());
        setMarkerSearch = Set();
        // delete polygon
        _googleMapcontroller.removePolygons(polygonSet.toList());
        polygonSet = Set();
        // delete polyline
        _googleMapcontroller.removePolylines(mypolyline.toList());
        mypolyline = [];

        dataSearch = [];

        checkButton();

        /// clean all
        break;
      case 4:
        _googleMapcontroller.removePolylines(polylineStreetSearched.toList());
        _googleMapcontroller.removePolylines(mypolyline.toList());
        _googleMapcontroller.removeMarkers(setMarker.toList());
        setMarker = Set();
        polylineStreetSearched = [];
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _googleMapcontroller
          .setMapStyle("[]"); // fix map will gone when app on resume
    } else if (state == AppLifecycleState.inactive) {}

    super.didChangeAppLifecycleState(state);
  }

  void locatePosition(bool getNearBy) async {
    CurrentPositionDto position;
    await bloc.callFunctionFuture(func: () async {
      position = await GoogleMapUtils.getCurrentPosition();
    });
    if (!position.isCurrentValid) {
      bloc.error(message: AppString.ALERT_MESSAGE_CHECK_LOCATION);
    }
    currentPosition = PositionDto(lat: position.lat, lng: position.lng);
    if (getNearBy) {
      nearByBloc
          .add(DisplayNearByEvent(!_isShowNearBy, position.lat, position.lng));
      _isShowNearBy = !_isShowNearBy;
    }
    // bloc.loading();

    detailMapBloc.add(ShowDescriptionEvent(false));
    _filterRadiusBloc.add(DisPlayFilterRadiusEvent(false, ""));
    _isShowFilterRadius = !_isShowFilterRadius;

    if (_isShowNearBy) {
      try {
        targetTmp = LatLng(position.lat, position.lng);

        _googleMapcontroller.myLocationEnabled = true;

        _googleMapcontroller.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(target: targetTmp, zoom: 15.5)));
      } catch (error) {
        UtilsCommon.showSnackBarAlert(
            context: this.context, message: AppString.GPS_NOT_SUPPORT_PLATFORM);
      }
    }

    ///time outs
  }

  Future<void> setValueToSharePreference(String key, String value) async {
    assert(value.isEmpty == false);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
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

  void checkButton() {
    if (Data.listTab.where((element) => element["checked"] == true).length >
        0) {
      if (Data.listTab.where((element) => element["checked"] == true).length ==
              1 &&
          Data.listTab
                  .where((element) =>
                      element["id"] == 1 && element["checked"] == true)
                  .length ==
              1) {
        buttonMapBloc.add(ShowButtonEvent(true, true));
      } else {
        buttonMapBloc.add(ShowButtonEvent(false, true));
      }
    } else {
      buttonMapBloc.add(ShowButtonEvent(false, false));
      _filterRadiusBloc.add(DisPlayFilterRadiusEvent(false, ""));
    }
  }

  void closeAllWidget() {
    userInforBloc.add(CloseDialogUserInformationEvent());
  }

  void onShowDirectionBar() {
    checkButton();
    cleanMap(0, "");
    nearByBloc.add(DisplayNearByEvent(false, 0, 0));
    userInforBloc.add(ShowUserInforEvent(false));
    detailMapBloc.add(ShowDescriptionEvent(false));
    tabBarTypeBloc.add(RemoteAllTabEvent());
    timelineBarBloc.add(TimelineBarShowEvent(true, null));
    listPlaceLocation = [];
    // timelineBarBloc.add(event)
    //
    // Navigator.of(context).pushNamed(TestReorderScreen.routeName);
  }

  List<Polyline> mypolyline = [];
  ListParam param = ListParam(radius: 0, dataHistory: []);

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

  void renderPolyline(List<PlaceListPoinModel> data, int isDefault) {
    switch (isDefault) {
      case 1:
        for (var item in data) {
          mypolyline.add(Polyline(
            polylineId: PolylineId('default-' + item.name),
            color: AppColors.defaultPolylineStreet,
            width: 4,
            geodesic: false,
            points: castPoint(item.points),
          ));
        }
        break;
      case 2:
        for (var item in data) {
          mypolyline.add(Polyline(
            polylineId: PolylineId(item.id.toString()),
            color: AppColors.streetColor,
            width: 4,
            geodesic: false,
            consumeTapEvents: true,
            onTap: () {
              detailMapBloc
                  .add(LoadingDetailPlaceInMapEvent(item.id, item.type));
              nearByBloc.add(DisplayNearByEvent(false, 0, 0));
            },
            points: castPoint(item.points),
          ));
        }
        break;
    }

    _googleMapcontroller.addPolylines(mypolyline);
  }

  List<Polyline> inItpolyline = [];

  void renderInItMap(List<PlaceListPoinModel> data) {
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

  // void renderStreetRoute(List<RouteLatlng> listStreet) {
  //   if (listStreet.length != 0) {
  //     setMarker.clear();
  //     var index = 0;
  //     var iconMarker;
  //     var anchor;

  //     LatLng firstMarker;
  //     LatLng endMarker;

  //     for (var item in listStreet) {
  //       if (index == 0 && item.isDestination) {
  //         // firstMarker = LatLng(item.lat, item.lng);
  //         firstMarker = LatLng(11.141107, 106.461538);
  //         iconMarker = firstPoint;
  //         anchor = Offset(0.5, 1.0);
  //         setMarker.add(
  //           Marker(
  //             anchor: anchor,
  //             icon: iconMarker,
  //             infoWindow: InfoWindow(title: item.name),
  //             markerId: MarkerId(item.name),
  //             draggable: false,
  //             onTap: () {},
  //             position: LatLng(item.lat, item.lng),
  //           ),
  //         );
  //         index++;
  //       } else if (item.isDestination) {
  //         endMarker = LatLng(item.lat, item.lng);

  //         // endMarker = LatLng(11.142027, 106.463987);
  //         iconMarker = BitmapDescriptor.fromBytes(listAlphalbetPoint[index]);
  //         anchor = Offset(0.5, 1.0);
  //         setMarker.add(
  //           Marker(
  //             anchor: anchor,
  //             icon: iconMarker,
  //             infoWindow: InfoWindow(title: item.name),
  //             markerId: MarkerId(item.name),
  //             draggable: false,
  //             onTap: () {},
  //             position: LatLng(item.lat, item.lng),
  //           ),
  //         );
  //         index++;
  //       }
  //     }
  //     // LatLng temp;

  //     // if (firstMarker.latitude > endMarker.latitude) {
  //     //   temp = firstMarker;
  //     //   firstMarker = endMarker;
  //     //   endMarker = temp;
  //     // }
  //     // double firstLongtitude =
  //     //     double.parse(firstMarker.longitude.toStringAsFixed(6));
  //     // double endLongtitude =
  //     //     double.parse(endMarker.longitude.toStringAsFixed(6));

  //     // LatLng firstMarkerTmp = LatLng(firstMarker.latitude, firstLongtitude);
  //     // LatLng endMarkerTmp = LatLng(endMarker.latitude, endLongtitude);

  //     // latLngBounds =
  //     //     new LatLngBounds(southwest: firstMarkerTmp, northeast: endMarkerTmp);

  //     polylineStreetSearched.add(Polyline(
  //       polylineId: PolylineId(listStreet[1].name),
  //       color: LightTheme.colorMain,
  //       width: 4,
  //       consumeTapEvents: true,
  //       zIndex: 1,
  //       points: castRoute(listStreet),
  //     ));
  //     _googleMapcontroller.addPolylines(polylineStreetSearched);

  //     Timer(Duration(milliseconds: 1000), () {
  //       CameraPosition cameraPos = CameraPosition(
  //           tilt: 0.0,
  //           bearing: 0.0,
  //           target: LatLng(endMarker.latitude, endMarker.longitude),
  //           zoom: 16.0);

  //       _googleMapcontroller
  //           .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  //     });
  //   }
  // }

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

  Future<void> _clearInputDataSearchInSharePreference() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("dataSearch");
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    customMarkerFirstPointEndPoint();
    showProcess(scaffoldKey);
    // checkConnection(context: this.context);
    // UtilsCommon.check();
    currentPosition = PositionDto(
        lat: currentPos.target.latitude, lng: currentPos.target.longitude);
    _isInit = true;
    //init bloc provider
    _toolMapBloc = BlocProvider.of<ToolMapBloc>(context);
    mapBloc = BlocProvider.of<MapBloc>(context);
    scaleBarBloc = BlocProvider.of<ScaleBarBloc>(context);
    timelineBarBloc = BlocProvider.of<TimelineBarBloc>(context);
    nearByBloc = BlocProvider.of<NearByBloc>(context);
    tabBarTypeBloc = BlocProvider.of<TabBarTypeBloc>(context);
    userInforBloc = BlocProvider.of<UserInforBloc>(context);
    zoomInOutBloc = BlocProvider.of<ZoomInOutBloc>(context);
    mapNavigatorBloc = BlocProvider.of<MapNavigatorBloc>(context);
    searchController = TextEditingController();
    _prefs = SharedPreferences.getInstance();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    detailMapBloc = BlocProvider.of<DetailMapBloc>(context);
    buttonMapBloc = BlocProvider.of<ButtonMapBloc>(context);
    buttonInSearchBloc = BlocProvider.of<ButtonInSearchBloc>(context);
    _filterRadiusBloc = BlocProvider.of<FilterRadiusBloc>(context);
    listLocationHistoryBloc = BlocProvider.of<ListLocationHistoryBloc>(context);
    param = ListParam();
    initGoogleMap();
    _toolMapBloc.add(DisplayToolMapEvent(true));
    mapBloc.add(LoadingInitMapEvent());
    mapNavigatorBloc.add(InitMapNavigatorEvent());
    WidgetsBinding.instance.addObserver(this);
    // locatePosition(true);
    convertMarker();
  }

  @override
  void didChangeDependencies() {
    _clearInputDataSearchInSharePreference();
    zoomInOutBloc.add(GetCurrentLngLatEvent(
        currentPos.target.longitude, currentPos.target.latitude));
    scaleBarBloc.add(ChangeScaleBarValueEvent(currentPos, currentPos.zoom));
    UtilsCommon.setDataFromInput(false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    _isInit = false;

    super.dispose();
  }

  Future<void> retreivedVlueFromBottomSheet(value) async {
    locatePosition(false);
    param.radius = int.parse(value);
    print(param.radius);
    _isShowFilterRadius = false;
    final SharedPreferences prefs = await _prefs;

    prefs.setInt("radiusValue", param.radius);
    prefs.setDouble("latlocal", latLngPostion.latitude);
    prefs.setDouble("lnglocal", latLngPostion.longitude);
    CurrentPositionDto pos;
    pos = await GoogleMapUtils.getCurrentPosition();

    mapBloc.add(LoaddingRadiusEvent(
        pos.lat, pos.lng, param.radius, searchController.text, 0, false));
    searchBloc.add(SearchRadiusEvent(
        pos.lat, pos.lng, param.radius, searchController.text, 0, false));
    _filterRadiusBloc.add(DisPlayFilterRadiusEvent(false, ""));
  }

  Future<void> removeRadius() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("radiusValue");
    prefs.remove("latlocal");
    prefs.remove("lnglocal");
  }

  void initGoogleMap() {
    _googleMapcontroller = GoogleMapsController(
      initialPolylines: mypolyline.toSet(),
      initialCameraPosition: currentPos,
      onCameraMove: (value) => onCameraMapMoving(value),
      initialMarkers: Set.from(allMarkers),
      zoomControlsEnabled: false,
      compassEnabled: false,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: true,
    );

    Timer(new Duration(milliseconds: 700), () {
      tabBarTypeBloc.add(SelectTabBarTypeEvent(1));
    });
  }

  // list render search
  List<Marker> allMarkers = [];

  Set<Marker> setMarkerSearch = new Set();
  Set<Marker> setMarker = new Set();

  void renderSearch(List<PlaceListPoinModel> data) {
    if (data.where((element) => element.type == "places").length > 0) {
      renderMarker(data.where((element) => element.type == "places").toList());
    }
    if (data.where((element) => element.type == "streets").length > 0) {
      renderPolyline(
          data.where((element) => element.type == "streets").toList(), 2);
    }
    if (data
            .where((element) =>
                element.type != "Đang cập nhật" &&
                element.type != "streets" &&
                element.type != "places")
            .length >
        0) {
      renderPolygon(data
          .where((element) =>
              element.type != "streets" && element.type != "places")
          .toList());
    }
    if (data[0].type == "Đang cập nhật") {
      renderPolyline(data, 2);
    }
  }

  List<ListMarker> listCustomMarker = [];
  void convertMarker() async {
    BitmapDescriptor castMarker;
    for (int i = 0; i < Data.iconNames.length; i++) {
      Uint8List firstIconMarker =
          await UtilsCommon.getBytesFromAsset(Data.iconNames[i], 80);
      castMarker = BitmapDescriptor.fromBytes(firstIconMarker);
      listCustomMarker
          .add(ListMarker(marker: i + 1, bitmapDescriptor: castMarker));
    }
  }

  void renderMarker(List<PlaceListPoinModel> data) {
    for (var item in data) {
      if (item.marker != null && item.marker != 0) {
        setMarkerSearch.add(
          Marker(
            infoWindow: InfoWindow(title: item.name),
            markerId: MarkerId(item.type + "-" + item.id.toString()),
            draggable: false,
            icon: listCustomMarker == null
                ? BitmapDescriptor.defaultMarker
                : listCustomMarker
                    .firstWhere((element) => element.marker == item.marker)
                    .bitmapDescriptor,
            onTap: () {
              print("Asdad");
              detailMapBloc
                  .add(LoadingDetailPlaceInMapEvent(item.id, item.type));
              nearByBloc.add(DisplayNearByEvent(false, 0, 0));
              if (_isShowFilterRadius) {
                _filterRadiusBloc.add(DisPlayFilterRadiusEvent(false, ""));
                _isShowFilterRadius = !_isShowFilterRadius;
              }
            },
            position: LatLng(item.points[0].lat, item.points[0].lng),
          ),
        );
      } else {
        setMarkerSearch.add(
          Marker(
            infoWindow: InfoWindow(title: item.name),
            markerId: MarkerId(item.type + "-" + item.id.toString()),
            draggable: false,
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              detailMapBloc
                  .add(LoadingDetailPlaceInMapEvent(item.id, item.type));
              nearByBloc.add(DisplayNearByEvent(false, 0, 0));
              if (_isShowFilterRadius) {
                _filterRadiusBloc.add(DisPlayFilterRadiusEvent(false, ""));
                _isShowFilterRadius = !_isShowFilterRadius;
              }
            },
            position: LatLng(item.points[0].lat, item.points[0].lng),
          ),
        );
      }
    }
    _googleMapcontroller.markers = setMarkerSearch;
  }

  void renderPolygon(List<PlaceListPoinModel> data) {
    data.forEach(
      (item) => {addPoygon(item)},
    );
    _googleMapcontroller.polygons = polygonSet;
  }

  void addPoygon(PlaceListPoinModel data) {
    String namePolygon =
        ConvertVietNamese.unsign(data.name).replaceAll(" ", "-").toLowerCase();

    data.points
        .forEach((item) => {polygonCoords.add(LatLng(item.lat, item.lng))});
    polygonSet.add(
      Polygon(
        onTap: () {
          detailMapBloc.add(LoadingDetailPlaceInMapEvent(data.id, data.type));
          nearByBloc.add(DisplayNearByEvent(false, 0, 0));
        },
        consumeTapEvents: true,
        polygonId: PolygonId(data.type + "-" + namePolygon),
        points: polygonCoords,
        strokeWidth: 1,
        fillColor: data.type == "rivers"
            ? AppColors.riverColor
            : data.type == "plants"
                ? AppColors.plantColor
                : AppColors.zoneColor,
        strokeColor: data.type == "rivers"
            ? AppColors.riverColor
            : data.type == "plants"
                ? AppColors.plantColor
                : AppColors.zoneColor,
      ),
    );

    polygonCoords = [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () {
        if (_isShowHistoryList) {
          //   searchBloc.add(ShowHistoryEvent(false, []));
        } else {
          // Navigator.pop(context, false);
          showDialog(
              context: context,
              builder: (_) => AlertDialogMessage(
                    isError: true,
                    subscription: "Bạn có muốn thoát ứng dụng!",
                    isShowButtonAction: true,
                    okButton: true,
                    onOkPressed: () => SystemChannels.platform
                        .invokeMethod('SystemNavigator.pop'),
                  ));
          return null;
        }
        return Future.value(false);
      },
      child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              /// bloc main
              BlocConsumer<MapBloc, MapState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is LoadSuccessPolygonState) {
                    dataSearch.addAll(state.data);
                    renderPolygon(state.data);
                    _googleMapcontroller.polygons = polygonSet;
                    checkButton();
                  } else if (state is DeleteSuccessPolygonState) {
                    String type = UtilsCommon.convertTypeString(state.typeId);

                    cleanMap(3, type);
                    checkButton();
                  } else if (state is BindingDataSearchState) {
                    //  data = state.data;

                    cleanMap(0, "");

                    dataSearch = [];
                    dataSearch.addAll(state.data);
                    if (dataSearch.length > 0) {
                      renderSearch(dataSearch);
                      buttonMapBloc.add(ShowButtonEvent(false, true));
                    }
                    checkButton();
                  } else if (state is LoadSuccessPolylineState) {
                    renderPolyline(state.data, 2);

                    dataSearch.addAll(state.data);
                    _googleMapcontroller.addPolylines(mypolyline);
                    buttonMapBloc.add(ShowButtonEvent(false, true));
                    checkButton();
                  } else if (state is DeleteSuccessPolylineState) {
                    cleanMap(2, "");
                    checkButton();
                  } else if (state is DeleteSuccessMarkerState) {
                    cleanMap(1, "");
                    checkButton();
                    removeRadius();
                  } else if (state is LoadSuccessMarkerState) {
                    dataSearch.addAll(state.place);
                    renderSearch(state.place);
                    _googleMapcontroller.markers = setMarkerSearch;

                    checkButton();
                  } else if (state is LoadSuccessRadiusState) {
                    cleanMap(0, "");
                    dataSearch = [];
                    dataSearch.addAll(state.place);
                    if (dataSearch.length > 0) {
                      renderSearch(dataSearch);
                      buttonMapBloc.add(ShowButtonEvent(false, true));
                    }
                    checkButton();
                  } else if (state is BindingDeleteSearchState) {
                    tabBarTypeBloc.add(EnableCheckEvent(false));

                    cleanMap(0, "");
                    checkButton();
                    removeRadius();
                  } else if (state is StreetRouteSearchedState) {
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
                      timelineBarBloc.add(SearchingRouteEvent());
                      mapBloc.add(LoaddingDefaultPolylineEvent(1));

                      Timer(new Duration(milliseconds: 500), () {
                        GoogleMapUtils.renderStreetRoute(
                            listStreetTmp,
                            setMarker,
                            listAlphalbetPoint,
                            firstPoint,
                            polylineStreetSearched,
                            _googleMapcontroller);
                      });

                      _googleMapcontroller.addPolylines(mypolyline);
                      _googleMapcontroller.markers = setMarker;
                    }
                  } else if (state is LoadSuccessInitMapState) {
                    renderInItMap(state.data);
                  } else if (state is GoogleMapLoadDefaultPolylineState) {
                    renderPolyline(state.data, state.show);
                  } else if (state is CleanDefautPolylineState) {
                    cleanMap(4, "");
                    _googleMapcontroller
                        .removePolylines(polylineStreetSearched.toList());
                    polylineStreetSearched = [];
                  }

                  GoogleMapUtils.changeMapMode(_googleMapcontroller);
                  _googleMapcontroller.padding = EdgeInsets.only(top: 200.0);
                  return GoogleMaps(controller: _googleMapcontroller);
                },
              ),
              Column(
                children: [
                  BlocBuilder<MapBloc, MapState>(builder: (context, state) {
                    if (state is ClosedTimeLineBarState) {
                      if (state.isSearchedRoute) {
                        return Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 40.0,
                              ),
                              CircleButtonMapWidget(
                                icon: Icons.chevron_left,
                                onTap: () async {
                                  mapBloc.add(ClosedTimeLineBarEvent(false));
                                  timelineBarBloc
                                      .add(CloseTimelineBarEvent(false));
                                },
                              )
                            ],
                          ),
                        );
                      }
                    }

                    return Container(
                        color: _isShowHistoryList
                            ? Colors.white
                            : Colors.transparent,
                        child: Column(
                          children: [
                            inputSearch(context),
                            TabBarWidget(
                              isDataFromInput: false,
                              controller: controller,
                              textEditingController: searchController.text,
                            ),
                          ],
                        ));
                  }),
                  Expanded(
                    child: Container(
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
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 15, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ScaleBarWidget(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //todo change bloc
                  DescriptionPlaceWidget(
                    onTap: () {
                      detailMapBloc.add(ShowDescriptionEvent(false));
                      _toolMapBloc.add(DisplayToolMapEvent(true));
                    },
                  ),
                  placeNearMe(),

                  FilterRadiusWidget(
                    retreivedValue: (value) =>
                        retreivedVlueFromBottomSheet(value),
                  ),
                ],
              ),
              // todo change widget
              // ListHistoryScreen(
              //   textEditingController: searchController,
              // ),
              TimelineDirectionCustom(
                context: this.context,
              ),

              UserDialogWidget(),
            ],
          )),
    );
  }

  Widget filterButtonWidget() {
    return BlocBuilder<ButtonMapBloc, ButtonMapState>(
      builder: (context, state) {
        if (state is ShowBottunState) {
          _isShowButtonFilterRadius = state.filter;
        }

        return _isShowButtonFilterRadius
            ? GestureDetector(
                onTap: () {
                  detailMapBloc.add(ShowDescriptionEvent(false));
                  timelineBarBloc.add(CloseTimelineBarEvent(false));
                  nearByBloc.add(DisplayNearByEvent(false, 0, 0));
                  if (!_isShowFilterRadius) {
                    getRadius();
                    _filterRadiusBloc.add(DisPlayFilterRadiusEvent(
                        true, param.radius.toString()));
                    _isShowFilterRadius = !_isShowFilterRadius;
                  } else {
                    _filterRadiusBloc.add(DisPlayFilterRadiusEvent(false, ""));
                    _isShowFilterRadius = !_isShowFilterRadius;
                  }
                },
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      width: 25,
                      height: 50,
                      child: Icon(
                        Icons.filter_alt,
                        color: LightTheme.colorMain,
                      )),
                ),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              );
      },
    );
  }

  Widget buttomShowList() {
    bool buttonShowList = false;
    return BlocBuilder<ButtonMapBloc, ButtonMapState>(
      builder: (context, state) {
        if (state is ShowBottunState) {
          buttonShowList = state.showList;
        }

        return buttonShowList
            ? CircleButtonMapWidget(
                onTap: () {
                  // buttonInSearchBloc.add(ShowHistoryEvent(true));
                  if (!_isShowHistoryList) {
                    Navigator.of(context)
                        .pushNamed(ListHistoryScreen.routeName);

                    // buttonInSearchBloc.add(ShowHistoryEvent(true));

                    // userInforBloc.add(CloseDialogUserInformationEvent());
                    // nearByBloc.add(DisplayNearByEvent(false, 0, 0));
                    // detailMapBloc.add(ShowDescriptionEvent(false));
                  }
                },
                icon: Icons.list,
              )
            : Container(
                width: 0,
                height: 0,
              );
      },
    );
  }

  Widget toolMap() {
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
                  buttomShowList(),
                  SizedBox(height: 10),
                  CircleButtonMapWidget(
                    onTap: () {
                      locatePosition(true);
                    },
                    icon: Icons.my_location,
                  ),
                  SizedBox(height: 10),
                  CircleButtonMapWidget(
                    onTap: () {
                      // locatePosition(true);
                      CameraPosition cameraPos = CameraPosition(
                          bearing: 0.0,
                          target: LatLng(
                              GoogleMapUtils.getDefaultLocation().latitude,
                              GoogleMapUtils.getDefaultLocation().longitude),
                          zoom: 15.5);

                      _googleMapcontroller.animateCamera(
                          CameraUpdate.newCameraPosition(cameraPos));
                    },
                    icon: Icons.assistant_photo_sharp,
                  ),
                  SizedBox(height: 10),
                  CircleButtonMapWidget(
                    onTap: onShowDirectionBar,
                    icon: Icons.directions,
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      mapNavigatorBloc.add(ShowMapNavigationEvent(true));
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage(ImageString.MAP_NAVIGATOR_ICON),
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
  }

  Widget inputSearch(BuildContext context) {
    double top = MediaQuery.of(context).padding.top + 5;
    return Padding(
      padding: EdgeInsets.only(top: top, left: 15, right: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: SearchInputWidget(
              hasShadowBox: true,
              readonly: true,
              controller: searchController,
              onFocus: () {
                if (!_isShowHistoryList) {
                  Navigator.of(context).pushNamed(ListHistoryScreen.routeName);

                  // buttonInSearchBloc.add(ShowHistoryEvent(true));

                  // userInforBloc.add(CloseDialogUserInformationEvent());
                  // nearByBloc.add(DisplayNearByEvent(false, 0, 0));
                  // detailMapBloc.add(ShowDescriptionEvent(false));
                }
              },
              focusNode: searchFocusScope,
              prefixIcon: _isShowHistoryList
                  ? GestureDetector(
                      onTap: () {
                        /// ToDo bloc Search Show/hide history
                      },
                      child:
                          Icon(Icons.chevron_left, color: LightTheme.colorMain),
                    )
                  : null,
              suffixIcon: !_isShowHistoryList
                  ? Container(
                      child: CircleButtonMapWidget(
                        onTap: () {
                          userInforBloc.add(ShowUserInforEvent(true));
                        },
                        icon: Icons.person,
                      ),
                    )
                  : Container(
                      width: 0.0,
                      height: 0.0,
                    ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          filterButtonWidget(),
        ],
      ),
    );
  }

  Widget placeNearMe() {
    return BlocConsumer<NearByBloc, NearByState>(
      listener: (context, state) {
        //
      },
      builder: (context, state) {
        if (state is NearByShowState) {
          _isShowNearBy = state.show;
          if (_isShowNearBy) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: NearByLocationWidget(
                listplace: state.place,
                onNavigateTo: (id) {
                  Navigator.of(context)
                      .pushNamed(DetailPlaceScreen.routeName, arguments: id);
                },
                onShowAllList: () {
                  Navigator.of(context).pushNamed(
                      NearByLocationScreen.routeName,
                      arguments: state.place);
                },
              ),
            );
          } else {
            return const SizedBox(
              height: 0.0,
              width: 0.0,
            );
          }
        }
        return const SizedBox(
          height: 0.0,
          width: 0.0,
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // @override
  // bool get wantKeepAlive => true;
}
