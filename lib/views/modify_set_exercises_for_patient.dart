import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/patientExercise_controller.dart';
import 'package:my_patients_sql/models/patient.dart';

class ModifySetExercisesForPatient extends StatefulWidget {
  const ModifySetExercisesForPatient({super.key, required this.patient});
  final Patient patient;
  @override
  State<ModifySetExercisesForPatient> createState() =>
      _ModifySetExercisesForPatientState();
}

class _ModifySetExercisesForPatientState
    extends State<ModifySetExercisesForPatient> {
  PatientExerciseController patientExerciseController =
      Get.put(PatientExerciseController());

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
                  "Supprimer des exercices a ce patient",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 1.0,
        ),
        Expanded(
          child: FutureBuilder(
            future:
                patientExerciseController.getPatientExercises(widget.patient),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 4, right: 4, bottom: 1),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text(
                              snapshot.data[index].exerciseName,
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            subtitle: Text(
                              snapshot.data[index].exerciseDescription,
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                patientExerciseController.deletePatientExercise(
                                    widget.patient,
                                    snapshot.data[index].exerciseId);
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Exercice supprimé',
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    ));
  }
}
