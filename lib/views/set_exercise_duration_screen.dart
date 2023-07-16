import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patientExercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'package:my_patients_sql/models/patient_exercise.dart';

class SetExerciseDurationPage extends StatefulWidget {
  const SetExerciseDurationPage({super.key, required this.data});
  final PatientExercise data;
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
  final _formKey = GlobalKey<FormState>();
  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ Obligatoire';
    }
    return null;
  }

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
      return pickedDateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(top: 28.0, left: 10.0, right: 10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Center(
              child: Text(
                'Définir la durée de l\'exercice',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            Container(
              padding: const EdgeInsets.only(
                bottom: 5,
              ),
              child: Center(
                child: Text(
                  "Nom de l'exercice: ${widget.data.exerciseName}",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: _fieldValidator,
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      prefixIcon: Icon(Icons.timer_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Column(
                      children: [
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                patientExerciseController.setExerciseStartTime(
                                    widget.data.id, DateTime.now());
                                final DateTime value = DateTime.now().add(
                                    Duration(
                                        minutes: int.parse(
                                            _durationController.text)));

                                Alarm.set(
                                        alarmSettings: AlarmSettings(
                                            id: widget.data.id as int,
                                            dateTime: value,
                                            assetAudioPath: 'assets/alarm.mp3',
                                            enableNotificationOnKill: true,
                                            vibrate: true,
                                            notificationBody:
                                                '${widget.data.exerciseName} est terminé pour ${widget.data.patientName}',
                                            notificationTitle:
                                                'Exercise terminé!'))
                                    .then((valueFuture) {
                                  if (valueFuture) {
                                    patientExerciseController
                                        .setExerciseProgrammed(
                                            widget.data.id, 1);

                                    patientExerciseController
                                        .setExerciseEndTime(
                                            widget.data.id, value);
                                  }
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            child: const Text(
                              'Lancer l\'exercice maintenant',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  pickTime(DateTime.now(),
                                          int.parse(_durationController.text))
                                      .then(
                                    (value) {
                                      patientExerciseController
                                          .setExerciseStartTime(
                                              widget.data.id, DateTime.now());
                                      Alarm.set(
                                              alarmSettings: AlarmSettings(
                                                  id: widget.data.id as int,
                                                  dateTime: value,
                                                  assetAudioPath:
                                                      'assets/alarm.mp3',
                                                  enableNotificationOnKill:
                                                      true,
                                                  vibrate: true,
                                                  notificationBody:
                                                      '${widget.data.exerciseName} est terminé pour ${widget.data.patientName}',
                                                  notificationTitle:
                                                      'Exercise terminé!'))
                                          .then((valueFuture) {
                                        if (valueFuture) {
                                          patientExerciseController
                                              .setExerciseProgrammed(
                                                  widget.data.id, 1);

                                          patientExerciseController
                                              .setExerciseEndTime(
                                                  widget.data.id, value);
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              },
                              child: const Text(
                                'Définir l\'heure de début',
                                style: TextStyle(fontFamily: 'Poppins'),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
