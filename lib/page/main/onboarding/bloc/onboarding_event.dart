part of 'onboarding_bloc.dart';

class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class GetOnboard extends OnboardingEvent {
  GetOnboard();
}

class OnboardSuccess extends OnboardingEvent {
  final OnboardResponse data;

  OnboardSuccess(this.data);
}

class OnboardFailed extends OnboardingEvent {
  final String error;

  OnboardFailed(this.error);
}

class UpdateView extends OnboardingEvent {
  final String email;
  UpdateView(this.email);
}

class UpdateViewSuccess extends OnboardingEvent {
  final bool data;

  UpdateViewSuccess(this.data);
}

class UpdateViewFailed extends OnboardingEvent {
  final String error;

  UpdateViewFailed(this.error);
}