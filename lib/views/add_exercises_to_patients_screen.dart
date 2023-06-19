import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/models/patient.dart';

class AddExercisesToPatientPage extends StatefulWidget {
  const AddExercisesToPatientPage({super.key, required this.patient});
  final Patient patient;
  @override
  State<AddExercisesToPatientPage> createState() =>
      _AddExercisesToPatientPageState();
}

class _AddExercisesToPatientPageState extends State<AddExercisesToPatientPage> {
  ExerciseController exerciseController = Get.put(ExerciseController());
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
                        title: Text(controller.exercises[index].name),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            size: 25,
                          ),
                        )),
                  ),
                );
              },
            );
          }))
        ],
      ),
    );
  }
}
