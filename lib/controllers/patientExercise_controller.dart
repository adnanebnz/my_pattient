// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:my_patients_sql/db/db_helper.dart';
import 'package:my_patients_sql/models/exercise.dart';
import 'package:my_patients_sql/models/patient.dart';

class PatientExerciseController extends GetxController {
  Future getSelectedExercisesByPatient(Patient? patient) async {
    await DbHelper.getPatientProgrammedExercises(patient!.id!);
  }

  Future getPatientExercises(int? patientId) async {
    final List<Map<String, dynamic>> patientExercisesData =
        await DbHelper.getPatientExercises(patientId!);
    final List<Exercise> patientExercisesFinal = [];
    for (var patientExerciseData in patientExercisesData) {
      patientExercisesFinal.add(Exercise(
        id: patientExerciseData['id'],
        name: patientExerciseData['name'],
        description: patientExerciseData['description'],
      ));
    }
    return patientExercisesFinal;
  }

  Future getPatientExerciseId(int? patientId, int? exerciseId) async {
    final List<Map<String, dynamic>> patientExerciseData =
        await DbHelper.getPatientExerciseId(patientId!, exerciseId!);
    return patientExerciseData;
  }

  Future insertExercisesToPatient(int? patientId, Exercise? exercise) async {
    final Map<String, dynamic> patientExerciseData = {
      'patient_id': patientId,
      'exercise_id': exercise!.id,
    };
    await DbHelper.insert('patient_exercise', patientExerciseData);
  }

  Future deletePatientExercise(int? patientId, int? exerciseId) async {
    await DbHelper.deletePatientExercise(patientId!, exerciseId!);
  }

  Future updatePatientExercise(
      int? patientId, int? exerciseId, String column, String value) async {
    await DbHelper.updatePatientExercise(
        patientId!, exerciseId!, column, value);
  }

  Future setExerciseDone(int? patientId, int? exerciseId) async {
    await DbHelper.setExerciseIsDone(patientId!, exerciseId!);
  }

  Future setExerciseProgrammed(int? patientId, int? exerciseId) async {
    await DbHelper.setExerciseIsProgrammed(patientId!, exerciseId!);
  }

  Future getProgrammedExercises(int? patientId) async {
    final List<Map<String, dynamic>> programmedExercisesData =
        await DbHelper.getPatientProgrammedExercises(patientId!);
    final List<Exercise> programmedExercisesFinal = [];
    for (var programmedExerciseData in programmedExercisesData) {
      programmedExercisesFinal.add(Exercise(
        id: programmedExerciseData['id'],
        name: programmedExerciseData['name'],
        description: programmedExerciseData['description'],
      ));
    }
    return programmedExercisesFinal;
  }

  Future getDoneExercises(int? patientId) async {
    final List<Map<String, dynamic>> doneExercisesData =
        await DbHelper.getPatientCompletedExercises(patientId!);
    final List<Exercise> doneExercisesFinal = [];
    for (var doneExerciseData in doneExercisesData) {
      doneExercisesFinal.add(Exercise(
        id: doneExerciseData['id'],
        name: doneExerciseData['name'],
        description: doneExerciseData['description'],
      ));
    }
    return doneExercisesFinal;
  }
}
