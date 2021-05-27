part of 'button_int_detail_bloc.dart';

@immutable
abstract class ButtonIntDetailState {}

class ButtonIntDetailInitial extends ButtonIntDetailState {}

class ChangeTextState extends ButtonIntDetailState {
  final String text;
  ChangeTextState(this.text);
}
