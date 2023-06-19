import 'package:get/state_manager.dart';
import 'package:my_patients_sql/db/db_helper.dart';
import 'package:my_patients_sql/models/exercise.dart';
import 'dart:developer' as developer show log;

class ExerciseController extends GetxController {
  RxList exercises = <Exercise>[].obs;

  Future insertExercise(Exercise? exercise) async {
    final data = exercise!.toMap();
    developer.log('insertExercise: $data', name: 'ExerciseController');
    await DbHelper.insert('exercises', data);
    getExercises();
  }

  Future setExerciseProgrammed(int id, int isPorgrammed) async {
    DbHelper.setExerciseIsProgrammed(id, isPorgrammed);
    getExercises();
  }

  Future getExercises() async {
    final List<Map<String, dynamic>> exercisesData =
        await DbHelper.getData('exercises');
    final List<Exercise> fetchedExercises = [];
    for (var exerciseData in exercisesData) {
      fetchedExercises.add(Exercise(
        id: exerciseData['id'],
        name: exerciseData['name'],
        description: exerciseData['description'],
      ));
    }
    exercises.value = fetchedExercises;
    return exercises;
  }

  Future deleteExercise(int? id) async {
    await DbHelper.delete('exercises', id!);
    getExercises();
  }

  Future updateExercise(int? id, Exercise? exercise) async {
    await DbHelper.update("exercises", exercise!.toMap(), id);
    getExercises();
  }

  Future insertPatientExercise(int patientId, int exerciseId) async {
    final Map<String, dynamic> patientExerciseData = {
      'patient_id': patientId,
      'exercise_id': exerciseId,
    };
    await DbHelper.insert('patient_exercise', patientExerciseData);
    getPatientExercises(patientId);
  }

  Future deletePatientExercise(int id) async {
    await DbHelper.delete('patient_exercise', id);
  }

  Future insertCompletedExercise(int patientId, int exerciseId) async {
    final Map<String, dynamic> completedExerciseData = {
      'patient_id': patientId,
      'exercise_id': exerciseId,
    };
    return await DbHelper.insert('completed_exercise', completedExerciseData);
  }

  static Future<List<Map<String, dynamic>>> getPatientExercises(
      patientId) async {
    return await DbHelper.getPatientExercises(patientId);
  }

  static Future<List<Map<String, dynamic>>> getCompletedExercises(
      patientId) async {
    return await DbHelper.getPatientCompletedExercises(patientId);
  }
}
