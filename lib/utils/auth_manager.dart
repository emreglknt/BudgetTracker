import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final ValueNotifier<String?> authChangeNotifier = ValueNotifier(null);
  static SharedPreferences? _sharedPreferences;

  // Asenkron init metodu SharedPreferences'ı yükler
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Token kaydetme fonksiyonu
  static Future<void> saveToken(String token) async {
    await _sharedPreferences?.setString('authToken', token);
    authChangeNotifier.value = token;
  }

  // Token okuma fonksiyonu
  static String readAuth() {
    return _sharedPreferences?.getString('authToken') ?? '';
  }

  // Çıkış yapma ve verileri temizleme fonksiyonu
  static Future<void> logout() async {
    await _sharedPreferences?.clear();
    authChangeNotifier.value = null;
  }
}
