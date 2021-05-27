part of 'zoom_in_out_bloc.dart';

@immutable
abstract class ZoomInOutEvent {}

class GetCurrentLngLatEvent extends ZoomInOutEvent {
  final double lng;
  final double lat;
  GetCurrentLngLatEvent(this.lng, this.lat);
}
