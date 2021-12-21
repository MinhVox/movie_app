import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/authen/sign_in/models/user_entity.dart';
import 'package:final_training_aia/page/authen/sign_in/repository/sign_in_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SignInEvent, SignInState> {
  SigninBloc() : super(SignInState(status: SignInStatus.Initial));

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignIn) {
      yield state.copyWith(SignInStatus.Processing, null, null);
      yield* _mapSignInToState(event);
    } else if (event is SignInSuccess) {
      yield state.copyWith(SignInStatus.Success, event.data, null);
    } else if (event is SignInFailed) {
      yield state.copyWith(SignInStatus.Failed, null, event.error);
    }
  }

  Stream<SignInState> _mapSignInToState(SignIn event) async* {
    final repository = SignInRestRepository();
    try {
      repository.signIn(event.email, event.password, (data) {
        if (data is UserCredential) {
          add(SignInSuccess(data));
        } else {
          add(SignInFailed("Wrong Email/Password"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          SignInStatus.Failed, null, "An error has occurred");
    }
  }
}
