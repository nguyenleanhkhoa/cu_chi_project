part of 'zoom_in_out_bloc.dart';

@immutable
abstract class ZoomInOutState {}

class ZoomInOutInitial extends ZoomInOutState {}

class CurrentLngLatState extends ZoomInOutState {
  final double lng;
  final double lat;
  CurrentLngLatState(this.lng, this.lat);
}
