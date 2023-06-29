import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_patients_sql/views/home_screen.dart';
import 'package:my_patients_sql/views/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? seen = prefs.getBool('seen');
    if (seen == null || !seen) {
      await prefs.setBool('seen', true);
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen().then((bool isFirstTime) {
      if (isFirstTime) {
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          ),
        );
      } else {
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const IntroScreen()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 220,
          height: 220,
        ),
      ),
    );
  }
}
