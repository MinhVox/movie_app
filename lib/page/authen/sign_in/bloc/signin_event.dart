part of 'signin_bloc.dart';

class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends SignInEvent {
  final String email;
  final String password;

  SignIn(this.email, this.password);
}

class SignInSuccess extends SignInEvent {
  final UserCredential data;

  SignInSuccess(this.data);
}

class SignInFailed extends SignInEvent {
  final String error;

  SignInFailed(this.error);
}