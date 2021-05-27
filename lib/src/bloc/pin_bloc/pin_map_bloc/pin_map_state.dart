part of 'pin_map_bloc.dart';

@immutable
abstract class PinMapState {}

class PinMapInitial extends PinMapState {}

class LoadSuccessInitMapPinState extends PinMapState {
  final List<PlaceListPoinModel> data;
  LoadSuccessInitMapPinState(this.data);
}
