import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  bool loginStatus = false;
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  void setUserData({required String key, required String value}) async {
    await asyncPrefs.setString(key, value);
  }

  Future<String> getUserData({required String key}) async {
    String data = await asyncPrefs.getString(key) ?? "";
    return data;
  }

  void setLoginStatus({required String key, required bool value}) async {
    await asyncPrefs.setBool(key, value);
  }

  Future<bool> getLoginStatus({required String key}) async {
    bool isLoggedIn = await asyncPrefs.getBool(key) ?? false;
    return isLoggedIn;
  }
}
