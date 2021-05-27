part of 'button_in_search_bloc.dart';

@immutable
abstract class ButtonInSearchEvent {}

class ShowHistoryEvent extends ButtonInSearchEvent {
  final bool show;
  ShowHistoryEvent(this.show);
}
