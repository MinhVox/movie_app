part of 'signup_bloc.dart';

class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUp extends SignUpEvent {
  final String email;
  final String password;
  final String name;

  SignUp(this.email, this.password, this.name);
}

class SignUpSuccess extends SignUpEvent {
  final UserCredential data;

  SignUpSuccess(this.data);
}

class SignUpFailed extends SignUpEvent {
  final String error;

  SignUpFailed(this.error);
}
