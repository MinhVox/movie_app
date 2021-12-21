
import 'package:final_training_aia/page/authen/sign_in/models/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSesson {
  static final ApplicationSesson shared = ApplicationSesson._internal();
  factory ApplicationSesson() {
    return shared;
  }
  ApplicationSesson._internal();
  UserCredential? credential;
  bool isShowOnboard = true;
  bool isOnline = true; // internet connection.

  Future<bool> loadSession() async {
    credential = await UserCredential.loadCredential();
    return true;
  }

  void clearSession() {
    credential = null;
    UserCredential.clearCredential();
  }

  void storeShowPermission(bool showPermission) {
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setBool("SHOW_ONBOARD", showPermission),
    );
  }

  Future<bool> loadShowPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final isShowOnboard = prefs.getBool("SHOW_ONBOARD");
    return isShowOnboard ?? false;
  }

}
