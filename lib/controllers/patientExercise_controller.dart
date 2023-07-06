// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:my_patients_sql/db/db_helper.dart';
import 'package:my_patients_sql/models/exercise.dart';
import 'package:my_patients_sql/models/patient.dart';

import 'package:my_patients_sql/models/patient_exercise.dart';

class PatientExerciseController extends GetxController {
  RxList patientExercises = <PatientExercise>[].obs;

  Future getPatientExercises(Patient? patient) async {
    final List<Map<String, dynamic>> patientExercisesData =
        await DbHelper.getPatientExercises(patient!.id!);
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
    await getLatestPatientWithLatestEndTime();

    return data;
  }

  Future insertExercisesToPatient(int? patientId, Exercise? exercise) async {
    final Map<String, dynamic> patientExerciseData = {
      'patient_id': patientId,
      'exercise_id': exercise!.id,
    };
    await DbHelper.insert('patient_exercise', patientExerciseData);
    await getLatestPatientWithLatestEndTime();
  }

  Future deletePatientExercise(Patient? patient, int? exerciseId) async {
    await DbHelper.deletePatientExercise(patient!.id!, exerciseId!);
    await getPatientExercises(patient);
    await getLatestPatientWithLatestEndTime();
  }

  Future setExerciseDone(int? id, int value) async {
    await DbHelper.setExerciseIsDone(id!, value);
    await getLatestPatientWithLatestEndTime();
  }

  Future setExerciseProgrammed(int? id, int? isProgrammed) async {
    await DbHelper.setExerciseIsProgrammed(id!, isProgrammed!);
    await getLatestPatientWithLatestEndTime();
  }

  Future setExerciseStartTime(int? id, DateTime? startTime) async {
    await DbHelper.setExerciseStartTime(id!, startTime!);
    await getLatestPatientWithLatestEndTime();
  }

  Future setExerciseEndTime(int? id, DateTime? endTime) async {
    await DbHelper.setExerciseEndTime(id!, endTime!);
    await getLatestPatientWithLatestEndTime();
  }

  Future getLatestPatientWithLatestEndTime() async {
    final List<Map<String, dynamic>> patientExercisesData =
        await DbHelper.getLatestPatientWithLatestEndTime();
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
    patientExercises.value = data;
    return patientExercises;
  }
}
