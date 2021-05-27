import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timeline_input_event.dart';
part 'timeline_input_state.dart';

class TimelineInputBloc extends Bloc<TimelineInputEvent, TimelineInputState> {
  TimelineInputBloc() : super(TimelineInputInitial());

  @override
  Stream<TimelineInputState> mapEventToState(TimelineInputEvent event) async* {
    if (event is LoadTimeLineInputEvent) {
      yield await eventLoadTimeLine();
    } else if (event is ChangeValueTimelineInputEvent) {
      yield await eventChangeValueTimelineInput(event.itemList, event.height);
    }
  }

  Future<TimelineInputState> eventLoadTimeLine() async {
    return TimelineInputInitialState();
  }

  Future<TimelineInputState> eventChangeValueTimelineInput(
      List<Map<String, dynamic>> itemList, double height) async {
    return TimelineInputChangeValueState(itemList, height);
  }
}
