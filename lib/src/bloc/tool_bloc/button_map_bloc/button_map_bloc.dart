import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'button_map_event.dart';
part 'button_map_state.dart';

class ButtonMapBloc extends Bloc<ButtonMapEvent, ButtonMapState> {
  ButtonMapBloc() : super(ButtonMapInitial());

  @override
  Stream<ButtonMapState> mapEventToState(
    ButtonMapEvent event,
  ) async* {
    if (event is ShowButtonEvent) {
      yield await eventShowButton(event.filter, event.showList);
    }
  }

  Future<ButtonMapState> eventShowButton(bool filter, bool showList) async {
    return ShowBottunState(filter, showList);
  }
}
