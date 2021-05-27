part of 'tab_bar_type_bloc.dart';

@immutable
abstract class TabBarTypeEvent {}

class SelectTabBarTypeEvent extends TabBarTypeEvent {
  final int typeId;
  SelectTabBarTypeEvent(this.typeId);
}

class EnableCheckEvent extends TabBarTypeEvent {
  final bool check;
  EnableCheckEvent(this.check);
}

class RemoteAllTabEvent extends TabBarTypeEvent {}
