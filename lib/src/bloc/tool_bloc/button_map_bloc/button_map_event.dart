part of 'button_map_bloc.dart';

@immutable
abstract class ButtonMapEvent {}

class ShowButtonEvent extends ButtonMapEvent {
  final bool filter;
  final bool showList;
  ShowButtonEvent(this.filter, this.showList);
}
