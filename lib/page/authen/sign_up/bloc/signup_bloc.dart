import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/authen/sign_in/models/user_entity.dart';
import 'package:final_training_aia/page/authen/sign_up/repository/sign_up_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignUpEvent, SignUpState> {
  SignupBloc() : super(SignUpState(status: SignUpStatus.Initial));

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUp) {
      yield state.copyWith(SignUpStatus.Processing, null, null);
      yield* _mapSignUpToState(event);
    } else if (event is SignUpSuccess) {
      yield state.copyWith(SignUpStatus.Success, event.data, null);
    } else if (event is SignUpFailed) {
      yield state.copyWith(SignUpStatus.Failed, null, event.error);
    }
  }

  Stream<SignUpState> _mapSignUpToState(SignUp event) async* {
    final repository = SignUpRestRepository();
    try {
      repository.signUp(event.email, event.password, event.name, (data) {
        if (data is UserCredential) {
          add(SignUpSuccess(data));
        } else {
          add(SignUpFailed("This email is already sign up"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(SignUpStatus.Failed, null, "An error has occurred");
    }
  }
}
