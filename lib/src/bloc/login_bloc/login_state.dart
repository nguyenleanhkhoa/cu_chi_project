part of 'login_bloc.dart';

class LoginState {
  final bool isEmailValidate;
  final bool isPasswordValidate;
  final bool isSubmiting;
  final bool isLoginSuccess;
  final bool isLoginFailure;

  LoginState(
      {this.isEmailValidate,
      this.isPasswordValidate,
      this.isSubmiting,
      this.isLoginSuccess,
      this.isLoginFailure});

  bool get isFormValid => isEmailValidate && isPasswordValidate;

  factory LoginState.initial() {
    return LoginState(
      isEmailValidate: true,
      isPasswordValidate: true,
      isSubmiting: true,
      isLoginSuccess: true,
      isLoginFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isEmailValidate: true,
      isPasswordValidate: true,
      isSubmiting: true,
      isLoginFailure: false,
      isLoginSuccess: false,
    );
  }

  factory LoginState.loginSuccess() {
    return LoginState(
      isEmailValidate: true,
      isPasswordValidate: true,
      isSubmiting: true,
      isLoginFailure: false,
      isLoginSuccess: true,
    );
  }

  factory LoginState.loginFailure() {
    return LoginState(
      isEmailValidate: true,
      isPasswordValidate: true,
      isSubmiting: true,
      isLoginSuccess: false,
      isLoginFailure: true,
    );
  }

  LoginState updateState({bool isEmailValid, bool isPasswordValid}) {
    return LoginState(
      isEmailValidate: isEmailValid,
      isPasswordValidate: isPasswordValid,
      isLoginFailure: false,
      isLoginSuccess: false,
      isSubmiting: false,
    );
  }
}
