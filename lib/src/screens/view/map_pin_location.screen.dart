import 'dart:async';

import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/dto/dtos/current_postion.dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';

import 'package:cuchi/src/utils/googleMapUtils.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/src/widgets/widgets.dart';

import 'package:cuchi/styles/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

class GoogleMapPinLocationScreen extends StatefulWidget {
  static final routeName = "/pin-location-screen";

  @override
  _GoogleMapPinLocationScreenState createState() =>
      _GoogleMapPinLocationScreenState();
}

class _GoogleMapPinLocationScreenState extends State<GoogleMapPinLocationScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  PinLocationBloc pinLocationBloc;
  ScaleBarBloc scaleBarBloc;
  PinMapBloc pinMapBloc;
  MapNavigatorBloc mapNavigatorBloc;
  LatLng targetTmp;
  double zoomTmp = 16;
  NearByBloc nearByBloc;
  PositionDto currentPosition;
  ZoomInOutBloc zoomInOutBloc;

  GoogleMapsController _googleMapcontroller;
  CameraPosition currentPos = CameraPosition(
      bearing: 0.0, target: LatLng(11.141487, 106.463796), tilt: 0.0, zoom: 16);

  double lat;
  double lng;
  final GlobalKey<ScaffoldState> scaffoldKeyPinLocation =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    pinLocationBloc = BlocProvider.of<PinLocationBloc>(context);
    scaleBarBloc = BlocProvider.of<ScaleBarBloc>(context);
    pinMapBloc = BlocProvider.of<PinMapBloc>(context);
    zoomInOutBloc = BlocProvider.of<ZoomInOutBloc>(context);

    pinMapBloc.add(LoadingInitMapPinEvent());
    mapNavigatorBloc = BlocProvider.of<MapNavigatorBloc>(context);
    mapNavigatorBloc.add(InitMapNavigatorEvent());

    super.initState();
  }

  @override
  void didChangeDependencies() {
    initGoogleMap();
    super.didChangeDependencies();
  }

  void initGoogleMap() {
    _googleMapcontroller = GoogleMapsController(
      onCameraMove: onCameraMapMoving,
      initialCameraPosition: currentPos,
      zoomControlsEnabled: false,
      compassEnabled: false,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: true,
    );
    pinLocationBloc.add(PinLatLngLocationEvent(
        currentPos.target.latitude, currentPos.target.longitude));
  }

  void onCameraMapMoving(CameraPosition cameraPosition) {
    currentPos = cameraPosition;
    lat = cameraPosition.target.latitude;
    lng = cameraPosition.target.longitude;
    pinLocationBloc.add(PinLatLngLocationEvent(lat, lng));
    zoomInOutBloc.add(GetCurrentLngLatEvent(
        cameraPosition.target.longitude, cameraPosition.target.latitude));
    scaleBarBloc
        .add(ChangeScaleBarValueEvent(cameraPosition, cameraPosition.zoom));
    LatLng latLngPostion = cameraPosition.target;
    targetTmp = latLngPostion;
    zoomTmp = cameraPosition.zoom;
    currentPosition = PositionDto(
        lat: currentPos.target.latitude,
        lng: currentPos.target.longitude,
        zoom: currentPos.zoom);
  }

  List<LatLng> castPoint(List<Point> points) {
    List<LatLng> latlng = [];
    points.map((i) {
      LatLng point = LatLng(i.lat, i.lng);
      latlng.add(point);
    }).toList();
    return latlng;
  }

  List<Polyline> inItpolyline = [];

  void renderInItMap(List<PlaceListPoinModel> data) {
    for (var item in data) {
      inItpolyline.add(Polyline(
        polylineId: PolylineId("init_map" + item.id.toString()),
        color: Colors.orange,
        width: 2,
        geodesic: true,
        points: castPoint(item.points),
      ));
    }
    _googleMapcontroller.addPolylines(inItpolyline);
  }

  Future<void> removeMarkerDefault() async {
    await Future.delayed(Duration(milliseconds: 1000));
  }

  void boundToDefaultLocation() {
    CameraPosition cameraPos = CameraPosition(
        bearing: 0.0,
        target: LatLng(GoogleMapUtils.getDefaultLocation().latitude,
            GoogleMapUtils.getDefaultLocation().longitude),
        zoom: 15.5);

    _googleMapcontroller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  }

  @override
  void didUpdateWidget(covariant GoogleMapPinLocationScreen oldWidget) {
    removeMarkerDefault();
    super.didUpdateWidget(oldWidget);
  }

  final bloc = BaseObserver();
  void locatePosition(bool getNearBy) async {
    CurrentPositionDto position;

    await bloc.callFunctionFuture(func: () async {
      position = await GoogleMapUtils.getCurrentPosition();
    });

    if (!position.isCurrentValid) {
      bloc.error(message: AppString.ALERT_MESSAGE_CHECK_LOCATION);
    }

    currentPosition = PositionDto(lat: position.lat, lng: position.lng);
    boundToDefaultLocation();

    // try {
    //   targetTmp = LatLng(position.lat, position.lng);

    //   _googleMapcontroller.myLocationEnabled = true;

    //   _googleMapcontroller.animateCamera(CameraUpdate.newCameraPosition(
    //       new CameraPosition(target: targetTmp, zoom: 15.5)));
    // } catch (error) {
    //   bloc.error(message: AppString.GPS_NOT_SUPPORT_PLATFORM);
    // }

    ///time outs
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Timer(Duration(milliseconds: 800), () {
      GoogleMapUtils.changeMapMode(_googleMapcontroller);
    });

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
                  children: [
                    ZoomInOut(
                      googleMapcontroller: _googleMapcontroller,
                      target: targetTmp,
                      zoomNumber: zoomTmp,
                    ),
                    SizedBox(height: 10),
                    CircleButtonMapWidget(
                      onTap: () {
                        locatePosition(true);
                      },
                      icon: Icons.my_location,
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
                            image: AssetImage('assets/icons/map_navigator.png'),
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

    Widget scaleBar() {
      return Padding(
        padding: const EdgeInsets.only(right: 15, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ScaleBarWidget(),
            SizedBox(
              width: 5,
            ),
            Container(
              height: 8,
              width: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.black),
                  left: BorderSide(width: 1, color: Colors.black),
                  right: BorderSide(width: 1, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget submitButton() {
      return BlocConsumer<PinLocationBloc, PinLocationState>(
          listener: (context, state) {
        if (state is PinedLocationState) {
          var placeLocation = PlaceLocationModel(
              name: state.name,
              point: Point(lat: state.position.lat, lng: state.position.lng),
              id: state.id,
              pinLocation: true,
              index: 0);
          Navigator.of(context).pop(placeLocation);
        }
      }, builder: (context, state) {
        return Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: LightTheme.colorMain,
          ),
          child: TextButton(
            onPressed: () {
              pinLocationBloc.add(GetCurrentPinedLocationEvent(
                  double.parse(state.position.lat.toStringAsFixed(6)),
                  double.parse(state.position.lng.toStringAsFixed(6))));
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
    }

    Widget bottomBar() {
      return Column(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    // MapNavigatorWidget(
                    //   currentPosition: currentPos,
                    //   googleMapcontroller: _googleMapcontroller,
                    //   onBottomPressed: onNavigateBottomClick,
                    //   onLeftPressed: onNavigateLeftClick,
                    //   onRightPressed: onNavigateRigthClick,
                    //   onTopPressed: onNavigateTopClick,
                    // ),
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
                scaleBar(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: submitButton(),
          )
        ],
      );
    }

    return Scaffold(
        key: scaffoldKeyPinLocation,
        appBar: AppBar(
          backgroundColor: LightTheme.colorMain,
          title: Text("Tìm địa điểm"),
        ),
        body: Container(
          child: Stack(children: [
            BlocBuilder<PinMapBloc, PinMapState>(
              builder: (context, state) {
                if (state is LoadSuccessInitMapPinState) {
                  renderInItMap(state.data);
                }
                return GoogleMaps(controller: _googleMapcontroller);
              },
            ),
            bottomBar(),
            PinLocationWidget(),
          ]),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
