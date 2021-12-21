part of 'signup_bloc.dart';

class SignUpState extends Equatable {
  final SignUpStatus status;
  UserCredential? data;
  String? error;
  SignUpState({required this.status});

  @override
  List<Object> get props => [status];

  SignUpState copyWith(SignUpStatus? status, UserCredential? data,
      String? error) {
    var newState = SignUpState(status: status ?? this.status);
    if (data != null) {
      newState.data = data;
    }
    if (error != null) {
      newState.error = error;
    }
    return newState;
  }
}

enum SignUpStatus { Initial, Processing, Success, Failed }

