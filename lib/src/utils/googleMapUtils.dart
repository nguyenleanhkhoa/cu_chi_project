import 'dart:async';
import 'dart:typed_data';

import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/dto/dtos/current_postion.dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

class GoogleMapUtils {
  static void onNavigateTopClick(
      GoogleMapsController _googleMapcontroller, PositionDto latLng) async {
    double lat = latLng.lat;
    double lng = latLng.lng;
    double zoom = latLng.zoom;

    double latTemp = lat + 0.0009;
    LatLng latLngTmp = LatLng(latTemp, double.parse(lng.toStringAsFixed(7)));
    CameraPosition cameraPos =
        CameraPosition(bearing: 0.0, target: latLngTmp, tilt: 0.0, zoom: zoom);

    _googleMapcontroller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  }

  static void onNavigateBottomClick(
      GoogleMapsController _googleMapcontroller, PositionDto latLng) {
    double lat = latLng.lat;
    double lng = latLng.lng;
    double zoom = latLng.zoom;

    CameraPosition cameraPos = CameraPosition(
        bearing: 0.0, target: LatLng(lat - 0.0009, lng), tilt: 0.0, zoom: zoom);

    _googleMapcontroller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  }

  static void onNavigateLeftClick(
      GoogleMapsController _googleMapcontroller, PositionDto latLng) {
    double lat = latLng.lat;
    double lng = latLng.lng;
    double zoom = latLng.zoom;

    CameraPosition cameraPos = CameraPosition(
        bearing: 0.0, target: LatLng(lat, lng - 0.0009), tilt: 0.0, zoom: zoom);

    _googleMapcontroller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  }

  static void onNavigateRigthClick(
      GoogleMapsController _googleMapcontroller, PositionDto latLng) {
    double lat = latLng.lat;
    double lng = latLng.lng;
    double zoom = latLng.zoom;

    CameraPosition cameraPos = CameraPosition(
        bearing: 0.0, target: LatLng(lat, lng + 0.0009), tilt: 0.0, zoom: zoom);

    _googleMapcontroller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  }

  static Future<String> getJsonFile(String part) async {
    return await rootBundle.loadString(part);
  }

  static void setMapStype(
      String mapstyle, GoogleMapsController _googleMapcontroller) {
    _googleMapcontroller.setMapStyle(mapstyle);
  }

  static changeMapMode(GoogleMapsController _googleMapcontroller) {
    getJsonFile('assets/map_style.json')
        .then((value) => setMapStype(value, _googleMapcontroller));
  }

  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static final bloc = BaseObserver();
  static Future<CurrentPositionDto> getCurrentPosition() async {
    try {
      // await Geolocator.openAppSettings();
      // await Geolocator.openLocationSettings();
      // final position = await Location().getLocation();
      CurrentPositionDto currentPosition;

      Position position = await _determinePosition().timeout(
        Duration(milliseconds: 6000),
        onTimeout: () {
          // UtilsCommon.showSnackBarAlert(message: "GPS is get error!");
          bloc.error(message: AppString.ERROR_GPS);
          return null;
        },
      );
      bool isValid = await checkCurrentLocationIsValid(
          position.latitude, position.longitude);

      currentPosition = CurrentPositionDto(
          lat: position.latitude,
          lng: position.longitude,
          isCurrentValid: isValid);

      return currentPosition;
    } catch (error) {
      return new CurrentPositionDto(
          lat: getDefaultLocation().latitude,
          lng: getDefaultLocation().longitude,
          isCurrentValid: true);
    }
  }

  static Future<bool> checkCurrentLocationIsValid(
      double lat, double lng) async {
    var res = await new GoogleMapRepository().getNearByLocation(lat, lng);

    if (res != null && res.statusCode != 200) {
      return false;
    }
    return true;
  }

  static LatLng getDefaultLocation() {
    return LatLng(11.141621, 106.462229);
  }

  static void renderStreetRoute(
      List<RouteLatlng> listStreet,
      Set<Marker> setMarker,
      List<Uint8List> listAlphalbetPoint,
      firstPoint,
      List<Polyline> polylineStreetSearched,
      GoogleMapsController _googleMapcontroller) {
    if (listStreet.length != 0) {
      setMarker.clear();
      var index = 0;
      var iconMarker;
      var anchor;

      LatLng firstMarker;
      LatLng endMarker;

      for (var item in listStreet) {
        if (index == 0 && item.isDestination) {
          // firstMarker = LatLng(item.lat, item.lng);
          firstMarker = LatLng(11.141107, 106.461538);
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
          index++;
        } else if (item.isDestination) {
          endMarker = LatLng(item.lat, item.lng);

          // endMarker = LatLng(11.142027, 106.463987);
          iconMarker = BitmapDescriptor.fromBytes(listAlphalbetPoint[index]);
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
          index++;
        }
      }
      // LatLng temp;

      // if (firstMarker.latitude > endMarker.latitude) {
      //   temp = firstMarker;
      //   firstMarker = endMarker;
      //   endMarker = temp;
      // }
      // double firstLongtitude =
      //     double.parse(firstMarker.longitude.toStringAsFixed(6));
      // double endLongtitude =
      //     double.parse(endMarker.longitude.toStringAsFixed(6));

      // LatLng firstMarkerTmp = LatLng(firstMarker.latitude, firstLongtitude);
      // LatLng endMarkerTmp = LatLng(endMarker.latitude, endLongtitude);

      // latLngBounds =
      //     new LatLngBounds(southwest: firstMarkerTmp, northeast: endMarkerTmp);

      polylineStreetSearched.add(Polyline(
        polylineId: PolylineId(listStreet[1].name),
        color: LightTheme.colorMain,
        width: 4,
        consumeTapEvents: true,
        zIndex: 1,
        points: castRoute(listStreet),
      ));
      _googleMapcontroller.addPolylines(polylineStreetSearched);

      Timer(Duration(milliseconds: 1000), () {
        CameraPosition cameraPos = CameraPosition(
            tilt: 0.0,
            bearing: 0.0,
            target: LatLng(endMarker.latitude, endMarker.longitude),
            zoom: 16.0);

        _googleMapcontroller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPos));
      });
    }
  }

  static List<LatLng> castRoute(List<RouteLatlng> routes) {
    List<LatLng> latlng = [];
    routes.map((i) {
      LatLng point = LatLng(i.lat, i.lng);
      latlng.add(point);
    }).toList();
    return latlng;
  }
}
