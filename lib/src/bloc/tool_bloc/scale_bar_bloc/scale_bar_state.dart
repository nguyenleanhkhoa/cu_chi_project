part of 'scale_bar_bloc.dart';

@immutable
abstract class ScaleBarState {}

class ScaleBarInitial extends ScaleBarState {}

class ScaleBarValueState extends ScaleBarState {
  final String scale;
  ScaleBarValueState({this.scale});
}
