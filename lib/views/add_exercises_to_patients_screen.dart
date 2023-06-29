import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patientExercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'package:my_patients_sql/models/patient.dart';

class AddExercisesToPatientPage extends StatefulWidget {
  const AddExercisesToPatientPage({super.key, required this.patient});

  final Patient patient;

  @override
  State<AddExercisesToPatientPage> createState() =>
      _AddExercisesToPatientPageState();
}

class _AddExercisesToPatientPageState extends State<AddExercisesToPatientPage> {
  List selectedExercises = [];
  ExerciseController exerciseController = Get.put(ExerciseController());
  PatientController patientController = Get.put(PatientController());
  PatientExerciseController patientExerciseController =
      Get.put(PatientExerciseController());

  @override
  void initState() {
    super.initState();
    exerciseController.getExercises();
  }

  Future fillExercises() async {
    await exerciseController.getExercises().then((value) => {
          setState(() {
            selectedExercises = value;
          })
        });
  }

  Future saveExercises() async {
    for (var exercise in selectedExercises) {
      await patientExerciseController.insertExercisesToPatient(
          widget.patient.id, exercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 1),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25,
                  ),
                ),
                const Center(
                  child: Text(
                    "Ajouter des exercices a ce patient",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 1.0,
          ),
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
                      tileColor: Colors.white,
                      title: Text(
                        controller.exercises[index].name,
                      ),
                      subtitle: Text(controller.exercises[index].description),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          await patientExerciseController
                              .insertExercisesToPatient(widget.patient.id,
                                  controller.exercises[index]);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Exercice enregistré"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          })),
          const Spacer(),
        ],
      ),
    );
  }
}
