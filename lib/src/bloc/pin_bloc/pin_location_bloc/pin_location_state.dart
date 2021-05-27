part of 'pin_location_bloc.dart';

@immutable
abstract class PinLocationState {
  final PositionDto position;
  final String name;
  final int id;
  PinLocationState(this.position, this.name, this.id);
}

class PinLocationInitial extends PinLocationState {
  PinLocationInitial(PositionDto position, String name, int id)
      : super(position, name, id);
}

class PinedLocationState extends PinLocationState {
  PinedLocationState(PositionDto position, String name, int id)
      : super(position, name, id);
}

class LoadingSearchingLocationState extends PinLocationState {
  LoadingSearchingLocationState() : super(null, "", -1);
}

class ErrorSearchingLocationState extends PinLocationState {
  ErrorSearchingLocationState() : super(null, "", -1);
}
