part of 'map_navigator_bloc.dart';

@immutable
abstract class MapNavigatorEvent {}

class InitMapNavigatorEvent extends MapNavigatorEvent {}

class ShowMapNavigationEvent extends MapNavigatorEvent {
  bool show = false;
  ShowMapNavigationEvent(this.show);
}
