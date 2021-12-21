import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/main/onboarding/models/onboard_entity.dart';
import 'package:final_training_aia/page/main/onboarding/repository/onboard_repository.dart';
import 'package:final_training_aia/services/networking.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardState> {
  OnboardingBloc() : super(OnboardState(status: OnboardStatus.Initial));

  @override
  Stream<OnboardState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is GetOnboard) {
      yield state.copyWith(OnboardStatus.Processing, null, null,null);
      yield* _mapOnboardToState(event);
    } else if (event is OnboardSuccess) {
      yield state.copyWith(OnboardStatus.Success, event.data, null,null);
    } else if (event is OnboardFailed) {
      yield state.copyWith(OnboardStatus.Failed, null, event.error,null);
    } else if (event is UpdateView) {
      yield state.copyWith(OnboardStatus.UpdateProcessing, null, null,null);
      yield* _mapUpdateToState(event);
    } else if (event is UpdateViewSuccess) {
      yield state.copyWith(OnboardStatus.UpdateSuccess, null, null,event.data);
    } else if (event is UpdateViewFailed) {
      yield state.copyWith(OnboardStatus.UpdateFailed, null, event.error,null);
    }
  }

  Stream<OnboardState> _mapOnboardToState(GetOnboard event) async* {
    final repository = OnboardRestRepository();
    try {
      repository.getThumbnail((data) {
        if (data is OnboardResponse) {
          add(OnboardSuccess(data));
        } else {
          add(OnboardFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          OnboardStatus.Failed, null, "An error has occurred",null);
    }
  }

  Stream<OnboardState> _mapUpdateToState(UpdateView event) async* {
    final repository = OnboardRestRepository();
    try {
      repository.updateView(event.email, (data) {
        if (data is bool) {
          add(UpdateViewSuccess(data));
        } else {
          add(UpdateViewFailed("This email is already sign up"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(OnboardStatus.UpdateFailed, null, "An error has occurred",null);
    }
  }
}
