part of 'button_in_search_bloc.dart';

@immutable
abstract class ButtonInSearchState {}

class ButtonInSearchInitial extends ButtonInSearchState {}

class ShowHistoryState extends ButtonInSearchState {
  final bool show;

  ShowHistoryState(
    this.show,
  );
}

class LoadingShowHistory extends ButtonInSearchState {}
