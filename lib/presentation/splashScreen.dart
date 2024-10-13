import 'package:flutter/material.dart';
import 'package:budget_family/utils/auth_manager.dart';

import 'home.dart';
import 'login.dart';

/*
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _checkUserLoggedIn(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Loading indicator
      ),
    );
  }

  void _checkUserLoggedIn(BuildContext context) async {
    final token = AuthManager.readAuth();

    await Future.delayed(const Duration(seconds: 2));

    if (token.isNotEmpty) {
      // User is logged in, navigate to HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with your actual HomeScreen
      );
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Your existing LoginScreen
      );
    }
  }
}*/
