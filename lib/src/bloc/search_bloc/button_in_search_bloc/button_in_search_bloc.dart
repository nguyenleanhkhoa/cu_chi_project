import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'button_in_search_event.dart';
part 'button_in_search_state.dart';

class ButtonInSearchBloc
    extends Bloc<ButtonInSearchEvent, ButtonInSearchState> {
  ButtonInSearchBloc() : super(ButtonInSearchInitial());

  @override
  Stream<ButtonInSearchState> mapEventToState(
    ButtonInSearchEvent event,
  ) async* {
    if (event is ShowHistoryEvent) {
      yield await eventShowHistory(event.show);
    }
  }

  Future<ButtonInSearchState> eventShowHistory(
    bool show,
  ) async {
    await Future.delayed(Duration(milliseconds: 1000));
    return ShowHistoryState(
      show,
    );
  }
}
