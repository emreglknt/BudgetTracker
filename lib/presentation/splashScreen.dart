import 'package:flutter/material.dart';
import 'package:budget_family/utils/auth_manager.dart';
import 'package:lottie/lottie.dart';

import 'home.dart';
import 'login.dart';


class SplashScreen extends StatelessWidget {

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _checkUserLoggedIn(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.44,
              width: size.width,
              child: Lottie.asset('assets/splash.json'),
            ),
            SizedBox(height: size.height * 0.1,),
            const Text(
              'Budge🆃 ',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w500,
                color: Colors.indigo,
              ),
            ),
          ],
        ),// Loading indicator

      ),
    );
  }

  void _checkUserLoggedIn(BuildContext context) async {
    final token = AuthManager.readAuth();
    await Future.delayed(const Duration(seconds: 7));
    if (token != null){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with your actual HomeScreen
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Your existing LoginScreen
      );
    }
  }
}
