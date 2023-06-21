import 'package:get/state_manager.dart';
import 'package:my_patients_sql/db/db_helper.dart';
import 'package:my_patients_sql/models/exercise.dart';

class ExerciseController extends GetxController {
  RxList exercises = <Exercise>[].obs;

  Future insertExercise(Exercise? exercise) async {
    final data = exercise!.toMap();
    await DbHelper.insert('exercises', data);
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
}
