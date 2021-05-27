import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'button_int_detail_event.dart';
part 'button_int_detail_state.dart';

class ButtonIntDetailBloc
    extends Bloc<ButtonIntDetailEvent, ButtonIntDetailState> {
  ButtonIntDetailBloc() : super(ButtonIntDetailInitial());

  @override
  Stream<ButtonIntDetailState> mapEventToState(
    ButtonIntDetailEvent event,
  ) async* {
    if (event is ChangeTextEvent) {
      yield await eventChangeText(event.saved);
    }
  }

  Future<ButtonIntDetailState> eventChangeText(bool saved) async {
    if (saved) {
      return ChangeTextState("Đã lưu");
    } else {
      return ChangeTextState("Lưu");
    }
  }
}
