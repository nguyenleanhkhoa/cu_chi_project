part of 'user_infor_bloc.dart';

@immutable
abstract class UserState {
  bool show = false;
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage = "";
  String username = "";
  String email = "";
  String birthday = "";
  UserState(this.show, this.isBusy, this.isLoggedIn, this.errorMessage,
      this.email, this.username, this.birthday);
}

class InitialState extends UserState {
  InitialState() : super(false, false, false, "none error", "", "", "");
}

class ShowDialogUser extends UserState {
  ShowDialogUser(bool show, String email, String username, bool isLoggin)
      : super(show, false, isLoggin, "none error", email ?? "", username ?? "",
            "");
}

class IsLoggingState extends UserState {
  IsLoggingState() : super(false, true, false, "", "", "", "");
}

class IsLoggedState extends UserState {
  IsLoggedState(String email, String username, bool show)
      : super(show, false, true, "", email, username, "");
}

class CheckLoggingState extends UserState {
  CheckLoggingState(bool isLoggedIn, String email, String username)
      : super(false, false, isLoggedIn, "", email, username, "");
}

class IsLogginErrorState extends UserState {
  IsLogginErrorState(
    String errorMessage,
  ) : super(false, false, false, errorMessage, "", "", "");
}

class IsLoggoutState extends UserState {
  IsLoggoutState() : super(false, false, false, "", "", "", "");
}

class UserCurrentInformationState extends UserState {
  UserCurrentInformationState(String email, String username, String birthday)
      : super(false, false, true, "", email ?? "", username ?? "",
            birthday ?? "");
}
