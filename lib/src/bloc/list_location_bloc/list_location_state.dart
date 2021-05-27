part of 'list_location_bloc.dart';

@immutable
abstract class ListLocationState {}

class ListLocationInitial extends ListLocationState {}

class LoadSuccessSearchLocationState extends ListLocationState {
  final String textHistory;
  final Result listPlace;
  final bool show;

  LoadSuccessSearchLocationState(this.listPlace, this.show, this.textHistory);
}

class LoadFailedSearchLocationState extends ListLocationState {
  final String error;
  LoadFailedSearchLocationState(this.error);
}

class LoadMoreSearchLocationState extends ListLocationState {
  final Result listPlace;
  final bool show;
  LoadMoreSearchLocationState(this.listPlace, this.show);
}
