import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer show log;

import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';

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
  final TextEditingController _durationController = TextEditingController();

  Future pickTime(DateTime? initialTime, int duration) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime!),
    );
    if (pickedTime != null) {
      final DateTime pickedDateTime = DateTime(
        initialTime.year,
        initialTime.month,
        initialTime.day,
        pickedTime.hour,
        pickedTime.minute + duration,
      );
      developer.log("THE PCIKED TIME IS $pickedTime");
      developer.log("THE PCIKED DATE TIME IS $pickedDateTime");
      return pickedDateTime;
    }
  }

  ExerciseController exerciseController = Get.put(ExerciseController());
  PatientController patientController = Get.put(PatientController());

  Future setDuration(DateTime? pcikedDateTime, exerciseId, patientId) {
    final Map<String, dynamic> completedExerciseData = {
      'patient_id': patientId,
      'exercise_id': exerciseId,
      'duration': _durationController.text,
      'start_time': pcikedDateTime.toString(),
    };
    developer.log("THE COMPLETED EXERCISE DATA IS $completedExerciseData");
    return patientController.insertPatientsExercises(patientId, exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 28.0, left: 10.0, right: 10.0),
          child: Column(children: [
            const Text(
              'Définir la durée de l\'exercice',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: ElevatedButton(
                  onPressed: () {
                    pickTime(
                            DateTime.now(), int.parse(_durationController.text))
                        .then(
                      (value) {
                        //setDuration(value, widget.exerciseId, widget.patientId);
                        // SET ALARM HERE
                        Navigator.of(context).pop();
                        developer.log("THE VALUE IS $value");
                      },
                    );
                  },
                  child: const Text('Définir l\'heure de début')),
            )
          ]),
        ),
      ),
    );
  }
}
