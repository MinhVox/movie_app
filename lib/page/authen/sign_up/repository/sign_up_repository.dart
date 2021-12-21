import 'package:final_training_aia/page/authen/sign_in/models/user_entity.dart';
import 'package:final_training_aia/services/authentication_service.dart';
import 'package:flutter/material.dart';

class SignUpRestRepository {
  Future signUp(
    String email,
    String password,
    String name,
    ValueSetter<dynamic> completion,
  ) async {
    AuthenticationService _authSevice = AuthenticationService();
    var result =
        await _authSevice.signUpWithEmail(email: email, password: password);
    if (result != null) {
      var user = await _authSevice.addUser(email: result,name: name);
      UserCredential userCre = UserCredential.fromJson(user);
      completion(userCre);
    } else {
      completion(false);
    }
  }
}
