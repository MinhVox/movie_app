import 'package:final_training_aia/page/authen/sign_in/models/user_entity.dart';
import 'package:final_training_aia/services/authentication_service.dart';
import 'package:flutter/material.dart';
class SignInRestRepository {
  Future signIn(
    String email,
    String password,
    ValueSetter<dynamic> completion,
  ) async {
    AuthenticationService _authSevice = AuthenticationService();
    var result = await _authSevice.loginWithEmail(email: email, password: password);
    if(result != null){
      var user = await _authSevice.getUser(email: result);
      UserCredential userCre = UserCredential.fromJson(user);
      completion(userCre);
    }else {
      completion(false);
    }
  }
}
