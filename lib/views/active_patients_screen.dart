import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';

import 'set_exercise_duration_screen.dart';

class ActivePatientsPage extends StatefulWidget {
  const ActivePatientsPage({super.key});

  @override
  State<ActivePatientsPage> createState() => _ActivePatientsPageState();
}

class _ActivePatientsPageState extends State<ActivePatientsPage> {
  PatientController patientController = Get.put(PatientController());
  ExerciseController exerciseController = Get.put(ExerciseController());

  @override
  void initState() {
    super.initState();
    patientController.getActivePatients();
    exerciseController.getExercises();
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
                    child: Card(
                      surfaceTintColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            trailing: Switch.adaptive(
                              activeColor: Colors.green,
                              value:
                                  controller.patientsList[index].isActive == 1,
                              onChanged: (value) {
                                setState(() {
                                  controller.patientsList[index].isActive =
                                      value ? 1 : 0;
                                  if (controller.patientsList[index].isActive ==
                                      1) {
                                    controller.setPatientActive(
                                        controller.patientsList[index].id, 1);
                                  } else {
                                    controller.setPatientActive(
                                        controller.patientsList[index].id, 0);
                                  }
                                });
                              },
                            ),
                            title:
                                Text(controller.activePatientsList[index].name),
                            subtitle: Text(
                                "${controller.activePatientsList[index].age} ans"),
                            onTap: () {
                              showModalBottomSheet(
                                  barrierColor: Colors.white70,
                                  backgroundColor: Colors.white30,
                                  isScrollControlled: true,
                                  elevation: 1,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Ajouter des exercises pour ce patient",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Expanded(child:
                                                GetX<ExerciseController>(
                                                    builder:
                                                        (exerciseController) {
                                              return ListView.builder(
                                                itemCount: exerciseController
                                                    .exercises.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 13.0),
                                                    child: ListTile(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      tileColor: Colors.white70,
                                                      title: Text(
                                                          exerciseController
                                                              .exercises[index]
                                                              .name),
                                                      subtitle: Text(
                                                          exerciseController
                                                              .exercises[index]
                                                              .description),
                                                      trailing: IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                          color: Colors.green,
                                                          size: 25,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (_) {
                                                            return SetExerciseDurationPage(
                                                                exerciseId:
                                                                    exerciseController
                                                                        .exercises[
                                                                            index]
                                                                        .id,
                                                                patientId: controller
                                                                    .patientsList[
                                                                        index]
                                                                    .id);
                                                          }));
                                                        },
                                                      ),
                                                    ),
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
                          ),
                          const Divider(
                            height: 0,
                            thickness: 1,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                            child: Text(
                                "Maladie: ${controller.patientsList[index].disease}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                          ),
                        ],
                      ),
                    ),
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
