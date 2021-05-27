import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tool_map_event.dart';
part 'tool_map_state.dart';

class ToolMapBloc extends Bloc<ToolMapEvent, ToolMapState> {
  ToolMapBloc() : super(ToolMapInitial());

  @override
  Stream<ToolMapState> mapEventToState(
    ToolMapEvent event,
  ) async* {
    if (event is DisplayToolMapEvent) {
      yield await eventDisplayToolMap(event.show);
    }
  }

  Future<ToolMapState> eventDisplayToolMap(bool show) async {
    return DisPlayToolMapState(show);
  }
}
