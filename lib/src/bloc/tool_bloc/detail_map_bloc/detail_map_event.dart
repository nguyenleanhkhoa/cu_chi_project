part of 'detail_map_bloc.dart';

@immutable
abstract class DetailMapEvent {}

class LoadingDetailPlaceInMapEvent extends DetailMapEvent {
  final int id;
  final String placeType;
  LoadingDetailPlaceInMapEvent(this.id, this.placeType);
}

class ShowDescriptionEvent extends DetailMapEvent {
  final bool show;
  ShowDescriptionEvent(this.show);
}
