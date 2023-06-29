class PatientExercise {
  int? id;
  int? patientId;
  int? exerciseId;
  String patientName;
  int patientAge;
  String patientDisease;
  String exerciseName;
  String exerciseDescription;
  int? isProgrammed;
  int? isDone;
  String? startTime;
  String? endTime;

  PatientExercise({
    required this.id,
    required this.patientId,
    required this.exerciseId,
    required this.patientName,
    required this.patientAge,
    required this.patientDisease,
    required this.exerciseName,
    required this.exerciseDescription,
    required this.isProgrammed,
    required this.isDone,
    required this.startTime,
    required this.endTime,
  });
}
