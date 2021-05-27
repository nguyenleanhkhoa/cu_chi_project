part of 'tab_bar_type_bloc.dart';

@immutable
abstract class TabBarTypeState {}

class TabBarTypeInitial extends TabBarTypeState {}

class UnSelectTabBarTypeState extends TabBarTypeState {}

class SelectedTabBarTypeState extends TabBarTypeState {
  final bool checked;
  final int typeId;
  SelectedTabBarTypeState(this.checked, this.typeId);
}

class EnableCheckState extends TabBarTypeState {}

class RemoveAllTabState extends TabBarTypeState {}
