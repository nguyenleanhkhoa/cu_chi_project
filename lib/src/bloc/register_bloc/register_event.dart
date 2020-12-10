part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterUsernamChange extends RegisterEvent {}

class RegisterEmailChange extends RegisterEvent {}

class RegisterPasswordChange extends RegisterEvent {}

class RegisterConfirmPasswordChange extends RegisterEvent {}
