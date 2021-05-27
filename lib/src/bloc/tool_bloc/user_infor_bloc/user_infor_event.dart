part of 'user_infor_bloc.dart';

@immutable
abstract class UserInforEvent {
  final bool show;
  UserInforEvent(this.show);
}

class ShowUserInforEvent extends UserInforEvent {
  ShowUserInforEvent(bool show) : super(show);
}

class InitUserInfoEvent extends UserInforEvent {
  InitUserInfoEvent(bool show) : super(show);
}

class LoggingEvent extends UserInforEvent {
  LoggingEvent(bool show) : super(show);
}

class LogoutEvent extends UserInforEvent {
  LogoutEvent(bool show) : super(show);
}

class CheckingLoginEvent extends UserInforEvent {
  CheckingLoginEvent(bool show) : super(show);
}

class ShowCurrentUserInformationEvent extends UserInforEvent {
  final String email;
  final String username;
  final String birthday;

  ShowCurrentUserInformationEvent(
      {this.email, this.username, this.birthday, bool show})
      : super(show);
}

class CloseDialogUserInformationEvent extends UserInforEvent {
  CloseDialogUserInformationEvent() : super(false);
}
