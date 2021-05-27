part of 'near_by_bloc.dart';

@immutable
abstract class NearByEvent {}

class DisplayNearByEvent extends NearByEvent {
  final bool show;
  final double lat;
  final double lng;
  DisplayNearByEvent(this.show, this.lat, this.lng);
}
