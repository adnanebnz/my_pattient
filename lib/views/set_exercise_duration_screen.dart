import 'package:flutter/material.dart';

class SetExerciseDurationPage extends StatefulWidget {
  const SetExerciseDurationPage(
      {super.key, required this.exerciseId, required this.patientId});
  final int exerciseId;
  final int patientId;
  @override
  State<SetExerciseDurationPage> createState() =>
      _SetExerciseDurationPageState();
}

class _SetExerciseDurationPageState extends State<SetExerciseDurationPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Set Exercise Duration"),
      ),
    );
  }
}
