part of 'tool_map_bloc.dart';

@immutable
abstract class ToolMapEvent {}

class DisplayToolMapEvent extends ToolMapEvent {
  final bool show;
  DisplayToolMapEvent(this.show);
}
