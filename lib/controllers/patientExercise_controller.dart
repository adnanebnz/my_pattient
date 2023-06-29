// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:my_patients_sql/db/db_helper.dart';
import 'package:my_patients_sql/models/exercise.dart';
import 'package:my_patients_sql/models/patient.dart';
import "dart:developer" as developer show log;

import 'package:my_patients_sql/models/patient_exercise.dart';

class PatientExerciseController extends GetxController {
  Future getPatientExercises(Patient? patient) async {
    final List<Map<String, dynamic>> patientExercisesData =
        await DbHelper.getPatientExercises(patient!.id!);
    developer.log(patientExercisesData.toString());
    final List<PatientExercise> data = [];
    for (var patientExerciseData in patientExercisesData) {
      final PatientExercise patientExercise = PatientExercise(
        id: patientExerciseData['id'],
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

  Future setExerciseDone(int? id, int value) async {
    await DbHelper.setExerciseIsDone(id!, value);
  }

  Future setExerciseProgrammed(int? id, int? isProgrammed) async {
    await DbHelper.setExerciseIsProgrammed(id!, isProgrammed!);
  }

  Future setExerciseEndTime(int? id, DateTime? endTime) async {
    await DbHelper.setExerciseEndTime(id!, endTime!);
  }
}
