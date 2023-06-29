import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patientExercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'set_exercise_duration_screen.dart';
import 'dart:developer' as developer show log;

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
  bool showProgrammableExercises = false;
  bool showDoneExercises = false;
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
                                    return _BottomSheetContent(
                                      refreshData: (p0) async {
                                        return await patientExerciseController
                                            .getPatientExercises(controller
                                                .activePatientsList[p0]);
                                      },
                                      size: size,
                                      index: index,
                                      key: refreshIndicatorKey,
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

class _BottomSheetContent extends StatefulWidget {
  final Size size;
  final int index;
  final Function(int) refreshData;

  const _BottomSheetContent({
    required this.size,
    required this.index,
    required this.refreshData,
    required Key key,
  });

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  PatientExerciseController patientExerciseController =
      Get.find<PatientExerciseController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.refreshData(widget.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
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
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                key: widget.key,
                onRefresh: () async {
                  setState(() {});
                  await widget.refreshData(widget.index);
                },
                child: GetX<PatientController>(builder: (controller) {
                  return FutureBuilder(
                    future: patientExerciseController.getPatientExercises(
                        controller.activePatientsList[widget.index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        );
                      } else if (snapshot.hasError) {
                        developer.log("error: ${snapshot.error}");
                        return const Center(
                          child: Text("Une erreur est survenue!"),
                        );
                      } else if (snapshot.hasData) {
                        // Separate done exercises and programmable exercises
                        List doneExercises = [];
                        List programmableExercises = [];
                        for (var exercise in snapshot.data) {
                          if (exercise.isDone == 1) {
                            doneExercises.add(exercise);
                          } else {
                            programmableExercises.add(exercise);
                          }
                        }
                        // Sort done exercises by timestamp in descending order
                        doneExercises.sort(
                          (a, b) => b.timestamp.compareTo(a.timestamp),
                        );
                        // Combine done exercises and programmable exercises
                        List combinedExercises = [
                          ...doneExercises,
                          ...programmableExercises
                        ];

                        return ListView.builder(
                          itemCount: combinedExercises.length,
                          itemBuilder: (context, exoIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color:
                                    combinedExercises[exoIndex].isProgrammed ==
                                            1
                                        ? Colors.green[100]
                                        : Colors.white,
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      title: Text(combinedExercises[exoIndex]
                                          .exerciseName),
                                      subtitle: Text(combinedExercises[exoIndex]
                                          .exerciseDescription),
                                      trailing: combinedExercises[exoIndex]
                                                  .isDone ==
                                              1
                                          ? const Text(
                                              "status : Terminé",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : combinedExercises[exoIndex]
                                                      .isProgrammed ==
                                                  1
                                              ? const Text(
                                                  "status : Exercise programée ",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : const Text(
                                                  "status : non programée",
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 14),
                                                ),
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                IconButton(
                                                  tooltip:
                                                      "Programmer l'exercise",
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SetExerciseDurationPage(
                                                                data: combinedExercises[
                                                                    exoIndex]),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.alarm,
                                                    size: 28,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                const Text(
                                                    "Programmer l'exercise",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await Alarm.stop(
                                                          combinedExercises[
                                                                  exoIndex]
                                                              .patientId!);
                                                      await patientExerciseController
                                                          .setExerciseProgrammed(
                                                              combinedExercises[
                                                                      exoIndex]
                                                                  .id,
                                                              0);
                                                      await patientExerciseController
                                                          .setExerciseDone(
                                                              combinedExercises[
                                                                      exoIndex]
                                                                  .id,
                                                              0);
                                                      widget.refreshData(
                                                          widget.index);
                                                    },
                                                    icon: const Icon(
                                                      Icons.alarm_off,
                                                      color: Colors.red,
                                                      size: 28,
                                                    )),
                                                const Text("Annuler l'exercise",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  tooltip:
                                                      "Marquer l'exercise comme terminé",
                                                  onPressed: () async {
                                                    await patientExerciseController
                                                        .setExerciseDone(
                                                            combinedExercises[
                                                                    exoIndex]
                                                                .id,
                                                            1);
                                                    widget.refreshData(
                                                        widget.index);
                                                  },
                                                  icon: const Icon(
                                                    Icons.check_circle_outline,
                                                    color: Colors.green,
                                                    size: 28,
                                                  ),
                                                ),
                                                const Text(
                                                    "Marquer comme terminé",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                              ],
                                            )
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        );
                      }
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
