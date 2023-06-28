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

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "patientId": patientId,
      "exerciseId": exerciseId,
      "patientName": patientName,
      "patientAge": patientAge,
      "patientDisease": patientDisease,
      "exerciseName": exerciseName,
      "exerciseDescription": exerciseDescription,
      "isProgrammed": isProgrammed,
      "isDone": isDone,
      "startTime": startTime,
      "endTime": endTime,
    };
  }
}
