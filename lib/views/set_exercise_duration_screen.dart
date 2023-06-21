import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer show log;

import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patientExercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'package:my_patients_sql/models/exercise.dart';

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
  PatientExerciseController patientExerciseController =
      Get.put(PatientExerciseController());
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

  late final Exercise exercise;
  @override
  void initState() {
    super.initState();
    exerciseController.getExercises();
    patientController
        .getPatientExercises(
            patientController.activePatientsList[widget.patientIndex])
        .then((value) => {
              setState(() {
                exercise = value[widget.exerciseIndex];
              })
            });
  }

//TODO SHOW MORE FEEDBACK
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Center(
              child: Text(
                'Définir la durée de l\'exercice',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            Container(
              padding: const EdgeInsets.only(
                bottom: 5, // Space between underline and text
              ),
              child: Center(
                child: Text(
                  "Nom de l'exercice: ${exercise.name}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      pickTime(DateTime.now(),
                              int.parse(_durationController.text))
                          .then(
                        (value) {
                          //setDuration(value, widget.exerciseId, widget.patientId);

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
                            developer.log('THE VALUE IS $value');
                            if (value) {
                              // exerciseController.setExerciseProgrammed(
                              //     exerciseController
                              //         .exercises[widget.exerciseIndex].id,
                              //     1);
                              //TODO SET EXERCISE IS PROGRAMMED
                              patientExerciseController.setExerciseProgrammed(
                                  patientController
                                      .activePatientsList[widget.patientIndex]
                                      .id,
                                  exercise.id,
                                  1);
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: const Text('Définir l\'heure de début')),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
