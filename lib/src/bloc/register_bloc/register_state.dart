part of 'register_bloc.dart';

class RegisterState {
  final bool isUsernameValidate;
  final bool isEmailValidate;
  final bool isPasswordValidate;
  final bool isPasswordConfirmValidate;
  final bool isSubmit;
  RegisterState(
      {this.isUsernameValidate,
      this.isEmailValidate,
      this.isPasswordValidate,
      this.isPasswordConfirmValidate,
      this.isSubmit});

  bool get isFormValid =>
      isUsernameValidate &&
      isEmailValidate &&
      isPasswordValidate &&
      isPasswordConfirmValidate;

  factory RegisterState.initial() {
    return RegisterState(
        isEmailValidate: true,
        isPasswordConfirmValidate: true,
        isPasswordValidate: true,
        isUsernameValidate: true,
        isSubmit: false);
  }

  factory RegisterState.isLoading() {
    return RegisterState(
        isEmailValidate: true,
        isPasswordValidate: true,
        isUsernameValidate: true,
        isPasswordConfirmValidate: true,
        isSubmit: true);
  }

  factory RegisterState.isRegisterSuccess() {
    return RegisterState(
        isEmailValidate: true,
        isPasswordValidate: true,
        isPasswordConfirmValidate: true,
        isUsernameValidate: true,
        isSubmit: true);
  }

  factory RegisterState.isRegisterFailure() {
    return RegisterState(
        isEmailValidate: true,
        isUsernameValidate: true,
        isPasswordValidate: true,
        isPasswordConfirmValidate: false,
        isSubmit: true);
  }
}
