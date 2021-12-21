import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/main/onboarding/models/onboard_entity.dart';
import 'package:final_training_aia/services/authentication_service.dart';
import 'package:final_training_aia/services/networking.dart';
import 'package:flutter/material.dart';

class OnboardRestRepository extends Networking {
  void getThumbnail(
    ValueSetter<dynamic> completion,
  ) {
    final params = {'api_key': Constants.apiKey};
    final configuration = RequestConfiguration(
        HTTPMethod.Get, '/3/trending/all/day', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = OnboardResponse.fromJson(response.data["results"]);
        print(data);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  Future updateView(
    String email,
    ValueSetter<dynamic> completion,
  ) async {
    AuthenticationService _authSevice = AuthenticationService();
    var result = await _authSevice.updateViewOnboard(email: email);
    print(result.toString());
    if (result is bool && result) {
      completion(true);
    } else {
      completion(false);
    }
  }
}
