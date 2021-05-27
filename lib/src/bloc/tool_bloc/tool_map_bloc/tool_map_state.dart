part of 'tool_map_bloc.dart';

@immutable
abstract class ToolMapState {}

class ToolMapInitial extends ToolMapState {}

class DisPlayToolMapState extends ToolMapState {
  final bool show;
  DisPlayToolMapState(this.show);
}
