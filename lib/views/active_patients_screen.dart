import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patientExercise_controller.dart';
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
  PatientExerciseController patientExerciseController =
      Get.put(PatientExerciseController());
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
                              value: controller
                                      .activePatientsList[index].isActive ==
                                  1,
                              onChanged: (value) {
                                setState(() {
                                  controller.activePatientsList[index]
                                      .isActive = value ? 1 : 0;
                                  if (controller
                                          .activePatientsList[index].isActive ==
                                      1) {
                                    controller.setPatientActive(
                                        controller.patientsList[index].id, 1);
                                  } else {
                                    controller.setPatientActive(
                                        controller.activePatientsList[index].id,
                                        0);
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
                                  backgroundColor:
                                      const Color.fromRGBO(226, 232, 240, 1),
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
                                              "Programmer des exercises pour ce patient",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            const Text(
                                              "les exercises en vert sont déjà programmés pour ce patient",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54),
                                            ),
                                            const SizedBox(height: 10),
                                            Expanded(
                                                child: FutureBuilder(
                                              future: patientExerciseController
                                                  .getPatientExercises(controller
                                                          .activePatientsList[
                                                      index]),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                Colors.green),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return const Center(
                                                    child: Text(
                                                        "Une erreur est survenue!"),
                                                  );
                                                } else if (snapshot.hasData) {
                                                  return ListView.builder(
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder:
                                                        (context, exoIndex) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 12.0),
                                                        child: ListTile(
                                                          onLongPress:
                                                              () async {
                                                            //TODO cancel the alarm maybe id problem
                                                            Alarm.stop(snapshot
                                                                .data[exoIndex]
                                                                .id);
                                                            await patientExerciseController
                                                                .setExerciseProgrammed(
                                                                    controller
                                                                        .activePatientsList[
                                                                            index]
                                                                        .id,
                                                                    snapshot
                                                                        .data[
                                                                            exoIndex]
                                                                        .id,
                                                                    0);
                                                            await patientExerciseController
                                                                .getPatientExercises(
                                                                    controller
                                                                            .activePatientsList[
                                                                        index]);
                                                            //TODO refresh the list
                                                            setState(() {
                                                              patientExerciseController
                                                                  .getPatientExercises(
                                                                      controller
                                                                              .activePatientsList[
                                                                          index]);
                                                            });
                                                          },
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          tileColor: snapshot
                                                                      .data[
                                                                          exoIndex]
                                                                      .isProgrammed ==
                                                                  1
                                                              ? Colors
                                                                  .green[100]
                                                              : Colors.white70,
                                                          title: Text(snapshot
                                                              .data[exoIndex]
                                                              .name),
                                                          subtitle: Text(
                                                              snapshot
                                                                  .data[
                                                                      exoIndex]
                                                                  .description),
                                                          trailing: IconButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SetExerciseDurationPage(
                                                                    exerciseIndex:
                                                                        exoIndex,
                                                                    patientIndex:
                                                                        index,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons.add,
                                                              size: 28,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                            )),
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
