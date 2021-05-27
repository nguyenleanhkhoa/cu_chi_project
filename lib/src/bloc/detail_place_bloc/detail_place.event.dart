part of 'detail_place.bloc.dart';

@immutable
abstract class DetailPlaceEvent {}

class LoadingGetDetailEvent extends DetailPlaceEvent {
  final int id;
  final String type;
  LoadingGetDetailEvent(this.id, this.type);
}
