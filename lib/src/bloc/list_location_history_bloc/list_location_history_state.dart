part of 'list_location_history_bloc.dart';

@immutable
abstract class ListLocationHistoryState {}

class ListLocationHistoryInitial extends ListLocationHistoryState {}

class ShowHistoryLocationState extends ListLocationHistoryState {
  final List<PlaceLocationModel> listPlaceLocation;
  ShowHistoryLocationState(this.listPlaceLocation);
}

class CLoseHistoryLocationState extends ListLocationHistoryState {}
