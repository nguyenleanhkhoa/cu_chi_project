part of 'pin_location_bloc.dart';

@immutable
abstract class PinLocationEvent {
  final double lat;
  final double lng;
  PinLocationEvent(this.lat, this.lng);
}

class PinLatLngLocationEvent extends PinLocationEvent {
  PinLatLngLocationEvent(double lat, double lng) : super(lat, lng);
}

class GetCurrentPinedLocationEvent extends PinLocationEvent {
  GetCurrentPinedLocationEvent(double lat, double lng) : super(lat, lng);
}
