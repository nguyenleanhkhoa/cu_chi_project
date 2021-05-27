part of 'button_int_detail_bloc.dart';

@immutable
abstract class ButtonIntDetailEvent {}

class ChangeTextEvent extends ButtonIntDetailEvent {
  final bool saved;
  ChangeTextEvent(this.saved);
}
