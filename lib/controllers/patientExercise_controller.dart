// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:my_patients_sql/db/db_helper.dart';
import 'package:my_patients_sql/models/exercise.dart';
import 'package:my_patients_sql/models/patient.dart';
import "dart:developer" as developer show log;

import 'package:my_patients_sql/models/patient_exercise.dart';

class PatientExerciseController extends GetxController {
  Future getSelectedExercisesByPatient(Patient? patient) async {
    await DbHelper.getPatientProgrammedExercises(patient!.id!);
  }

  Future getPatientExercises(Patient? patient) async {
    final List<Map<String, dynamic>> patientExercisesData =
        await DbHelper.getPatientExercises(patient!.id!);
    developer.log(patientExercisesData.toString());
    final List<PatientExercise> data = [];
    for (var patientExerciseData in patientExercisesData) {
      final PatientExercise patientExercise = PatientExercise(
        patientId: patientExerciseData['patientId'],
        exerciseId: patientExerciseData['exerciseId'],
        patientName: patientExerciseData['patientName'],
        patientAge: patientExerciseData['patientAge'],
        patientDisease: patientExerciseData['patientDisease'],
        exerciseName: patientExerciseData['exerciseName'],
        exerciseDescription: patientExerciseData['exerciseDescription'],
        isProgrammed: patientExerciseData['isProgrammed'],
        isDone: patientExerciseData['isDone'],
        startTime: patientExerciseData['startTime'],
        endTime: patientExerciseData['endTime'],
      );
      data.add(patientExercise);
    }
    return data;
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

  Future deletePatientExercise(Patient? patient, int? exerciseId) async {
    await DbHelper.deletePatientExercise(patient!.id!, exerciseId!);
    await getPatientExercises(patient);
  }

  Future updatePatientExercise(
      int? patientId, int? exerciseId, String column, String value) async {
    await DbHelper.updatePatientExercise(
        patientId!, exerciseId!, column, value);
  }

  Future setExerciseDone(int? patientId, int? exerciseId, int value) async {
    await DbHelper.setExerciseIsDone(patientId!, exerciseId!, value);
  }

  Future setExerciseProgrammed(
      int? patientId, int? exerciseId, int? isProgrammed) async {
    await DbHelper.setExerciseIsProgrammed(
        patientId!, exerciseId!, isProgrammed!);
  }

  Future setExerciseEndTime(
      int? exerciseId, int? patientId, DateTime? endTime) async {
    await DbHelper.setExerciseEndTime(exerciseId!, patientId!, endTime!);
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
        isProgrammed: programmedExerciseData['isProgrammed'],
        isDone: programmedExerciseData['isDone'],
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
        isProgrammed: doneExerciseData['isProgrammed'],
        isDone: doneExerciseData['isDone'],
      ));
    }
    return doneExercisesFinal;
  }
}
