import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi_tunnel_gis/src/repository/login_repository/login_repository.dart';
import 'package:cuchi_tunnel_gis/src/utils/validation.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;

  LoginBloc({LoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChange) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is LoginPasswordChange) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is LoginPressed) {
      yield* _mapLoginPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapLoginEmailChangeToState(String email) async* {
    yield state.updateState(isEmailValid: Validate.isValidEmail(email));
  }

  Stream<LoginState> _mapLoginPasswordChangeToState(String password) async* {
    yield state.updateState(isEmailValid: Validate.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginPressedToState(
      {String email, String password}) async* {
    try {
      // await _loginRepository.loginWithEmailAndPassword(email, password);
      print("success!");
      yield LoginState.loginSuccess();
    } catch (error) {
      yield LoginState.loginFailure();
    }
  }
}
