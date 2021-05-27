part of 'button_map_bloc.dart';

@immutable
abstract class ButtonMapState {}

class ButtonMapInitial extends ButtonMapState {}

class ShowBottunState extends ButtonMapState {
  final bool filter;
  final bool showList;
  ShowBottunState(this.filter, this.showList);
}
