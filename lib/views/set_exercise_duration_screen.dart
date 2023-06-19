import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer show log;

import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';

class SetExerciseDurationPage extends StatefulWidget {
  const SetExerciseDurationPage(
      {super.key, required this.exerciseIndex, required this.patientIndex});
  final int exerciseIndex;
  final int patientIndex;
  @override
  State<SetExerciseDurationPage> createState() =>
      _SetExerciseDurationPageState();
}

class _SetExerciseDurationPageState extends State<SetExerciseDurationPage> {
  final TextEditingController _durationController = TextEditingController();
  ExerciseController exerciseController = Get.put(ExerciseController());
  PatientController patientController = Get.put(PatientController());
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

  @override
  void initState() {
    super.initState();
    exerciseController.getExercises();
    patientController.getPatientExercises(
        patientController.activePatientsList[widget.patientIndex],
        patientController.activePatientsList[widget.patientIndex].id);
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
                        //TODO FETCH EXERCISE DATA FOR THE ALARM NOTIFICATION BODY AND TITLE
                        //TODO SAVE IT TO DATABASE
                        //TODO WHILE CREATING THE PATIENTS OR MODIFIYING THEM ADD THE POSSIBILITY TO ADD THE EXISTING EXERCISES TO THEM
                        //TODO FETCH THE ONLY SELECTED EXERCISES FOR THE PATIENT IN THE ACTIVE PATIENTS PAGE
                        //TODO ADD THE POSSIBILITY TO STOP THE TIMER AND MODIFY IT

                        Alarm.set(
                                alarmSettings: AlarmSettings(
                                    id: 0,
                                    dateTime: value,
                                    assetAudioPath: 'assets/alarm.mp3',
                                    notificationBody: exerciseController
                                            .exercises[widget.exerciseIndex]
                                            .name +
                                        ' est terminé pour ' +
                                        patientController
                                            .activePatientsList[
                                                widget.patientIndex]
                                            .name,
                                    notificationTitle: 'Exercise terminé!'))
                            .then((value) {
                          developer.log('THE VALUE IS ' + value.toString());
                          if (value) {
                            exerciseController.setExerciseProgrammed(
                                exerciseController
                                    .exercises[widget.exerciseIndex].id,
                                1);
                          }
                        });
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
