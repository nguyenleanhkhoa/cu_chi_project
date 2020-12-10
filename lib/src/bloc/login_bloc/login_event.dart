part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginEmailChange extends LoginEvent {
  final String email;
  LoginEmailChange({this.email});
}

class LoginPasswordChange extends LoginEvent {
  final String password;
  LoginPasswordChange({this.password});
}

class LoginPressed extends LoginEvent {
  final String email;
  final String password;

  LoginPressed({this.email, this.password});
}
