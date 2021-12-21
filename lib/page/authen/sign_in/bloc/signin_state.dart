part of 'signin_bloc.dart';

class SignInState extends Equatable {
  final SignInStatus status;
  UserCredential? data;
  String? error;
  SignInState({required this.status});

  @override
  List<Object> get props => [status];

  SignInState copyWith(SignInStatus? status, UserCredential? data,
      String? error) {
    var newState = SignInState(status: status ?? this.status);
    if (data != null) {
      newState.data = data;
    }
    if (error != null) {
      newState.error = error;
    }
    return newState;
  }
}

enum SignInStatus { Initial, Processing, Success, Failed }
