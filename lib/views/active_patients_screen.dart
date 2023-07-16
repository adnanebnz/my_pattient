import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patientExercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'set_exercise_duration_screen.dart';
// ignore: unused_import
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
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    patientController.getActivePatients();
    exerciseController.getExercises();
    patientExerciseController.getLatestPatientWithLatestEndTime();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GetX<PatientController>(builder: (controller) {
              if (controller.activePatientsList.isEmpty) {
                return const Center(
                  child: Text("Auccun patient n'est présent!"),
                );
              } else {
                return ListView.builder(
                  itemCount: controller.activePatientsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0, left: 5, right: 5),
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
                                      if (controller.activePatientsList[index]
                                              .isActive ==
                                          1) {
                                        controller.setPatientActive(
                                            controller.patientsList[index].id,
                                            1);
                                      } else {
                                        controller.setPatientActive(
                                            controller
                                                .activePatientsList[index].id,
                                            0);
                                      }
                                    });
                                  },
                                ),
                                title: Text(
                                    controller.activePatientsList[index].name),
                                subtitle: Text(
                                    "${controller.activePatientsList[index].age} ans"),
                                onTap: () {
                                  showModalBottomSheet(
                                      barrierColor: Colors.white70,
                                      backgroundColor: const Color.fromRGBO(
                                          226, 232, 240, 1),
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
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 12.0, 0.0, 12.0),
                                child: Text(
                                    "Maladie: ${controller.patientsList[index].disease}",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87)),
                              ),
                            ],
                          ),
                        ));
                  },
                );
              }
            }),
          ),
        ],
      ),
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

  bool showCompleted = false;
  bool showUncompleted = true;
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
            const SizedBox(height: 10),
            Center(
              child: Row(
                children: [
                  FilterChip(
                    elevation: 4,
                    label: const Text("Exercises non terminés"),
                    labelStyle: showUncompleted
                        ? const TextStyle(color: Colors.white)
                        : const TextStyle(color: Colors.black87),
                    checkmarkColor: Colors.white,
                    selectedColor: const Color.fromRGBO(34, 197, 94, 1),
                    selected: showUncompleted,
                    onSelected: (value) {
                      setState(() {
                        showCompleted = false;
                        showUncompleted = value;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  FilterChip(
                    elevation: 4,
                    selected: showCompleted,
                    label: const Text("Exercises terminés"),
                    labelStyle: showCompleted
                        ? const TextStyle(color: Colors.white)
                        : const TextStyle(color: Colors.black87),
                    checkmarkColor: Colors.white,
                    selectedColor: const Color.fromRGBO(34, 197, 94, 1),
                    onSelected: (value) {
                      setState(() {
                        showUncompleted = false;
                        showCompleted = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
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
                        return const Center(
                          child: Text("Une erreur est survenue!"),
                        );
                      } else if (snapshot.hasData) {
                        List doneExercises = [];
                        List notDoneExercises = [];
                        for (var i = 0; i < snapshot.data.length; i++) {
                          if (snapshot.data[i].isDone == 1) {
                            doneExercises.add(snapshot.data[i]);
                          } else {
                            notDoneExercises.add(snapshot.data[i]);
                          }
                        }
                        if (showCompleted && doneExercises.isEmpty) {
                          return const Center(
                            child: Text("Aucun exercise terminé!"),
                          );
                        }
                        if (showUncompleted && notDoneExercises.isEmpty) {
                          return const Center(
                            child: Text("Aucun exercise non terminé!"),
                          );
                        }

                        if (!showCompleted && !showUncompleted) {
                          return const Center(
                            child: Text("Aucun exercise n'est affiché!"),
                          );
                        }

                        if (showCompleted && doneExercises.isNotEmpty) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, exoIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white,
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        title: Text(snapshot
                                            .data[exoIndex].exerciseName),
                                        subtitle: Text(snapshot.data[exoIndex]
                                            .exerciseDescription),
                                        trailing: snapshot
                                                    .data[exoIndex].isDone ==
                                                1
                                            ? const Text(
                                                "status : Terminé",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : snapshot.data[exoIndex]
                                                        .isProgrammed ==
                                                    1
                                                ? const Text(
                                                    "status : Exercise programée ",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : const Text(
                                                    "status : non programée",
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 14),
                                                  ),
                                      ),
                                      snapshot.data[exoIndex].isProgrammed == 1
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 12.0,
                                                  bottom: 12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 3,
                                                    ),
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.0,
                                                    ))),
                                                    child: Text(
                                                      "Se termine à: ${DateFormat('HH:mm').format(DateTime.parse(snapshot.data[exoIndex].endTime))}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(height: 0),
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
                                                    tooltip: "Programmer",
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SetExerciseDurationPage(
                                                                  data: snapshot
                                                                          .data[
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
                                                  const Text("Programmer",
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
                                                            snapshot
                                                                .data[exoIndex]
                                                                .patientId!);
                                                        await patientExerciseController
                                                            .setExerciseProgrammed(
                                                                snapshot
                                                                    .data[
                                                                        exoIndex]
                                                                    .id,
                                                                0);
                                                        await patientExerciseController
                                                            .setExerciseDone(
                                                                snapshot
                                                                    .data[
                                                                        exoIndex]
                                                                    .id,
                                                                0);
                                                        widget.refreshData(
                                                            widget.index);

                                                        setState(() {
                                                          widget.refreshData(
                                                              widget.index);
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.alarm_off,
                                                        color: Colors.red,
                                                        size: 28,
                                                      )),
                                                  const Text("Annuler",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  IconButton(
                                                    tooltip: "Terminer",
                                                    onPressed: () async {
                                                      await patientExerciseController
                                                          .setExerciseDone(
                                                              snapshot
                                                                  .data[
                                                                      exoIndex]
                                                                  .id,
                                                              1);
                                                      await patientExerciseController
                                                          .setExerciseProgrammed(
                                                              snapshot
                                                                  .data[
                                                                      exoIndex]
                                                                  .id,
                                                              0);
                                                      widget.refreshData(
                                                          widget.index);
                                                      setState(() {
                                                        widget.refreshData(
                                                            widget.index);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                      size: 28,
                                                    ),
                                                  ),
                                                  const Text("Terminer",
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
                        }

                        if (showUncompleted && notDoneExercises.isNotEmpty) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, exoIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white,
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        title: Text(snapshot
                                            .data[exoIndex].exerciseName),
                                        subtitle: Text(snapshot.data[exoIndex]
                                            .exerciseDescription),
                                        trailing: snapshot
                                                    .data[exoIndex].isDone ==
                                                1
                                            ? const Text(
                                                "status : Terminé",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : snapshot.data[exoIndex]
                                                        .isProgrammed ==
                                                    1
                                                ? const Text(
                                                    "status : Exercise programée ",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : const Text(
                                                    "status : non programée",
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 14),
                                                  ),
                                      ),
                                      snapshot.data[exoIndex].isProgrammed == 1
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  top: 12.0,
                                                  bottom: 12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 3,
                                                    ),
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.0,
                                                    ))),
                                                    child: Text(
                                                      "Se termine à: ${DateFormat('HH:mm').format(DateTime.parse(snapshot.data[exoIndex].endTime))}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(height: 0),
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
                                                    tooltip: "Programmer",
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SetExerciseDurationPage(
                                                                  data: snapshot
                                                                          .data[
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
                                                  const Text("Programmer",
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
                                                            snapshot
                                                                .data[exoIndex]
                                                                .patientId!);
                                                        await patientExerciseController
                                                            .setExerciseProgrammed(
                                                                snapshot
                                                                    .data[
                                                                        exoIndex]
                                                                    .id,
                                                                0);
                                                        await patientExerciseController
                                                            .setExerciseDone(
                                                                snapshot
                                                                    .data[
                                                                        exoIndex]
                                                                    .id,
                                                                0);
                                                        widget.refreshData(
                                                            widget.index);

                                                        setState(() {
                                                          widget.refreshData(
                                                              widget.index);
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.alarm_off,
                                                        color: Colors.red,
                                                        size: 28,
                                                      )),
                                                  const Text("Annuler",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  IconButton(
                                                    tooltip: "Terminer",
                                                    onPressed: () async {
                                                      await patientExerciseController
                                                          .setExerciseDone(
                                                              snapshot
                                                                  .data[
                                                                      exoIndex]
                                                                  .id,
                                                              1);
                                                      await patientExerciseController
                                                          .setExerciseProgrammed(
                                                              snapshot
                                                                  .data[
                                                                      exoIndex]
                                                                  .id,
                                                              0);
                                                      widget.refreshData(
                                                          widget.index);
                                                      setState(() {
                                                        widget.refreshData(
                                                            widget.index);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                      size: 28,
                                                    ),
                                                  ),
                                                  const Text("Terminer",
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
                        }

                        return const SizedBox();
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
