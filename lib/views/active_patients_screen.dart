import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';

class ActivePatientsPage extends StatefulWidget {
  const ActivePatientsPage({super.key});

  @override
  State<ActivePatientsPage> createState() => _ActivePatientsPageState();
}

class _ActivePatientsPageState extends State<ActivePatientsPage> {
  String searchText = '';
  DateTime now = DateTime.now();

  PatientController patientController = Get.put(PatientController());
  ExerciseController exerciseController = Get.put(ExerciseController());

  @override
  void initState() {
    super.initState();
    patientController.getActivePatients();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: GetX<PatientController>(builder: (controller) {
            return ListView.builder(
              itemCount: controller.activePatientsList.length,
              itemBuilder: (context, index) {
                if (controller.activePatientsList.isEmpty) {
                  return const Center(
                    child: Text("Auccun patient est présent!"),
                  );
                } else {
                  return ListTile(
                    title: Text(controller.activePatientsList[index].name),
                    subtitle:
                        Text(controller.activePatientsList[index].disease),
                    onTap: () {
                      showModalBottomSheet(
                          barrierColor: Colors.white60,
                          backgroundColor: Colors.white70,
                          isScrollControlled: true,
                          elevation: 2,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          showDragHandle: true,
                          context: context,
                          builder: (_) {
                            return Container(
                              height: size.height * 0.65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Ajouter des exercises pour ce patient",
                                      style: TextStyle(),
                                    ),
                                    Expanded(child: GetX<ExerciseController>(
                                        builder: (controller) {
                                      return ListView.builder(
                                        itemCount: controller.exercises.length,
                                        itemBuilder: (context, index) {
                                          return Center(
                                            child: Text(controller
                                                .exercises[index].name),
                                          );
                                        },
                                      );
                                    }))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  );
                }
              },
            );
          }),
        ),
      ],
    );
  }
}
