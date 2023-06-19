import 'package:my_patients_sql/models/exercise.dart';

class Patient {
  int? id;
  String name;
  int age;
  String disease;
  int isActive;
  List<Exercise>? exercises;
  List<Exercise>? selectedExercises;
  List<Exercise>? completedExercises;
  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.disease,
    required this.isActive,
    this.exercises,
    this.selectedExercises,
    this.completedExercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'disease': disease,
      'isActive': isActive,
    };
  }

  Patient.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        age = map['age'],
        disease = map['disease'],
        isActive = map['isActive'];
}
