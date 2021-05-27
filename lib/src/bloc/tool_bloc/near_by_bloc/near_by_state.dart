part of 'near_by_bloc.dart';

@immutable
abstract class NearByState {}

class NearByInitial extends NearByState {}

class NearByShowState extends NearByState {
  final bool show;
  final List<PlaceAttachmentModel> place;

  NearByShowState(this.show, this.place);
}
