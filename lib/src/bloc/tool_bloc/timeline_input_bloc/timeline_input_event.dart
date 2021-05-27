part of 'timeline_input_bloc.dart';

@immutable
abstract class TimelineInputEvent {}

class LoadTimeLineInputEvent extends TimelineInputEvent {}

class ChangeValueTimelineInputEvent extends TimelineInputEvent {
  final List<Map<String, dynamic>> listDirection;
  final List<Map<String, dynamic>> itemList;
  final double height;
  ChangeValueTimelineInputEvent(
      {this.listDirection, this.itemList, this.height});
}

class ChangeHeightTimeLineInputEvent extends TimelineInputEvent {
  final double height;
  ChangeHeightTimeLineInputEvent(this.height);
}
