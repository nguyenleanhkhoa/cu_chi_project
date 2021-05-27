part of 'detail_map_bloc.dart';

@immutable
abstract class DetailMapState {}

class DetailMapInitial extends DetailMapState {}

class LoadSuccessDetailPlaceInMapState extends DetailMapState {
  final DetailPlaceListModel detail;
  LoadSuccessDetailPlaceInMapState(this.detail);
}

class LoadFailDetailPlaceInMapState extends DetailMapState {
  final String error;
  LoadFailDetailPlaceInMapState(this.error);
}

class ShowDescriptionState extends DetailMapState {
  final bool show;
  ShowDescriptionState(this.show);
}
