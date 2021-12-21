import 'dart:convert';

import 'package:final_training_aia/session/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCredential {
  final String email;
  final String name;
  final bool isViewOnboard;

  static const String credentialKey = "CREDENTIALS_KEY";

  UserCredential(this.email, this.name, this.isViewOnboard);

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
      json["email"],
      json["name"],
      json["isViewOnboard"]
    );
  }

  static Future<UserCredential?> loadCredential() async {
    final prefs = await SharedPreferences.getInstance();
    final credentialString = prefs.get(credentialKey);

    if (credentialString != null &&
        credentialString != "" &&
        credentialString is String) {
      final json = jsonDecode(credentialString);
      return UserCredential.fromJson(json);
    }
    return null;
  }

  void storeCredential() {
    ApplicationSesson.shared.credential = this;
    SharedPreferences.getInstance().then((prefs) => {_storeCredential(prefs)});
  }

  static void clearCredential() {
    SharedPreferences.getInstance().then((prefs) => {_clearCredential(prefs)});
  }

  static void _clearCredential(SharedPreferences prefs) {
    prefs.remove(credentialKey);
  }

  void _storeCredential(SharedPreferences prefs) {
    final Map<String, dynamic> map = {
      "email": email,
      "name": name,
      "isViewOnboard": isViewOnboard
    };
    prefs.setString(credentialKey, jsonEncode(map));
  }
}
