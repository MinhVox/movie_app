part of 'onboarding_bloc.dart';

class OnboardState extends Equatable {
  final OnboardStatus status;
  OnboardResponse? data;
  bool? isUpdate;
  String? error;
  OnboardState({required this.status});

  @override
  List<Object> get props => [status];

  OnboardState copyWith(OnboardStatus? status, OnboardResponse? data,
      String? error,bool? isUpdate) {
    var newState = OnboardState(status: status ?? this.status);
    if (data != null) {
      newState.data = data;
    }
    if (error != null) {
      newState.error = error;
    }
    if (isUpdate != null){
      newState.isUpdate = isUpdate;
    }
    return newState;
  }
}

enum OnboardStatus { Initial, Processing, Success, Failed, UpdateProcessing, UpdateSuccess, UpdateFailed }
