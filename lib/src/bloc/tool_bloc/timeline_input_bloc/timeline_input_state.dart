part of 'timeline_input_bloc.dart';

@immutable
abstract class TimelineInputState {}

class TimelineInputInitial extends TimelineInputState {}

class TimelineInputInitialState extends TimelineInputState {}

class TimelineInputChangeValueState extends TimelineInputState {
  final List<Map<String, dynamic>> itemList;
  final double height;
  // List<Map<String, dynamic>> listDirection;
  TimelineInputChangeValueState(this.itemList, this.height);
}
