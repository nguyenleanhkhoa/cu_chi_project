part of 'list_location_history_bloc.dart';

@immutable
abstract class ListLocationHistoryEvent {}

class ShowHistoryLocationEvent extends ListLocationHistoryEvent {
  final List<PlaceLocationModel> listPlaceLocation;
  ShowHistoryLocationEvent(this.listPlaceLocation);
}

class CloseHistoryLocationEvent extends ListLocationHistoryEvent {}
