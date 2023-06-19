// ignore_for_file: unused_import

import 'dart:developer' as developer show log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'package:my_patients_sql/models/exercise.dart';
import 'package:my_patients_sql/models/patient.dart';

class AddExercisesToPatientPage extends StatefulWidget {
  const AddExercisesToPatientPage({super.key, required this.patient});

  final Patient patient;

  @override
  State<AddExercisesToPatientPage> createState() =>
      _AddExercisesToPatientPageState();
}

class _AddExercisesToPatientPageState extends State<AddExercisesToPatientPage> {
  List<Exercise> selectedExercises = [];
  ExerciseController exerciseController = Get.put(ExerciseController());
  PatientController patientController = Get.put(PatientController());

  @override
  void initState() {
    super.initState();
    exerciseController.getExercises();
    getPatientExercises();
    exerciseController
        .getSelectedExercisesByPatient(widget.patient)
        .then((value) => {
              setState(() {
                selectedExercises = value;
              })
            });
  }

  Future saveExercises() async {
    for (var exercise in selectedExercises) {
      await patientController.insertExercisesToPatient(
          widget.patient.id, exercise);
    }
  }

  Future getPatientExercises() async {
    await patientController
        .getPatientExercises(widget.patient)
        .then((value) => {
              setState(() {
                selectedExercises = value;
              })
            });
  }

  //TODO APPLY THE STYLE TO THE LISTTILE IF THE EXERCISE IS ALREADY ASSIGNED TO THE PATIENT

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: GetX<ExerciseController>(builder: (controller) {
            return ListView.builder(
              itemCount: controller.exercises.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 4, right: 4, bottom: 1),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        controller.exercises[index].name,
                      ),
                      subtitle: Text(controller.exercises[index].description),
                      selected: selectedExercises
                          .contains(controller.exercises[index]),
                      selectedColor: Colors.green,
                      selectedTileColor: Colors.white38,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () {
                        setState(() {
                          if (selectedExercises
                              .contains(controller.exercises[index])) {
                            selectedExercises
                                .remove(controller.exercises[index]);
                          } else {
                            selectedExercises.add(controller.exercises[index]);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            );
          })),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 36.0),
            child: ElevatedButton(
              child: const Text("Enregistrer"),
              onPressed: () async {
                await saveExercises();
              },
            ),
          )
        ],
      ),
    );
  }
}
