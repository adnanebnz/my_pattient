import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:my_patients_sql/views/splash_screen.dart';

void main() async {
  runApp(const MyApp());
  await Alarm.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPatients',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
