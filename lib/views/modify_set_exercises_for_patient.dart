import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/patientExercise_controller.dart';
import 'package:my_patients_sql/models/patient.dart';
import 'dart:developer' as developer show log;

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
  //TODO FIX BUGS RELATED TO ACTIVE PATIENT WHEN
  //TODO FIX BUGS RELATED TO GO BACK TO THE FORM WHEN YOU ADD AN EXERCISE
  //TODO FIX ADD EXERCISE STYE TO HAVE TRAILLING AND DELETE ENREGISTER BUTTON
  //TODO ADD THE POSSIBILITY TO STOP THE ALARM
  //TODO USE ENDTIME AND STARTTIME TO SAVE THEM IN DB WHILE SETTING THE DURATION
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: patientExerciseController.getPatientExercises(widget.patient),
      builder: (context, snapshot) {
        developer.log("snapshot data: ${snapshot.data}");
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
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].description),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          patientExerciseController.deletePatientExercise(
                              widget.patient, snapshot.data[index].id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Exercice supprimé'),
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
    ));
  }
}
