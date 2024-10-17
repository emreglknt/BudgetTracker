import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'getIt.dart';

class AuthManager {
  static final ValueNotifier<String?> authChangeNotifier = ValueNotifier(null);
  static final ValueNotifier<String?> authUsername = ValueNotifier(null);
  static SharedPreferences get _sharedPreferences => locator<SharedPreferences>();


  static Future<void> init() async {
    final token = _sharedPreferences.getString('authToken');
    final username = _sharedPreferences.getString('authUsername');
    if (token != null && token.isNotEmpty) {
      authChangeNotifier.value = token;
      if (username != null && username.isNotEmpty) {
        authUsername.value = username;
      }
    }
  }

 //save username and token (login status check)
  static Future<void> saveTokenanUsername(String token,String authUsername) async {
    await _sharedPreferences?.setString('authToken', token);
    await _sharedPreferences?.setString('authUsername', authUsername);
    authChangeNotifier.value = token;
    authChangeNotifier.value = authUsername;
  }



  // Token okuma fonksiyonu
  static String? readAuth() {
    return _sharedPreferences.getString('authToken');
  }

  static String? readUsername() {
    return _sharedPreferences.getString('authUsername');
  }


  // Çıkış yapma ve verileri temizleme fonksiyonu
  static Future<void> logout() async {
    await _sharedPreferences?.clear();
    authChangeNotifier.value = null;
    authChangeNotifier.value = null;
  }





}
