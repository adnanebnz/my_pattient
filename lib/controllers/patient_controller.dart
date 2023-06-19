import 'package:get/state_manager.dart';
import 'package:my_patients_sql/db/db_helper.dart';
import 'package:my_patients_sql/models/exercise.dart';
import 'package:my_patients_sql/models/patient.dart';
import 'dart:developer' as developer show log;

class PatientController extends GetxController {
  RxList patientsList = <Patient>[].obs;
  RxList activePatientsList = <Patient>[].obs;

  Future insertPatient(Patient? patient) async {
    await DbHelper.insert('patients', patient!.toMap());
    getActivePatients();
    getPatients();
  }

  Future insertExercisesToPatient(Patient? patient, Exercise? exercise) async {
    final Map<String, dynamic> patientExerciseData = {
      'patient_id': patient!.id,
      'exercise_id': exercise!.id,
    };
    await DbHelper.insert('patient_exercise', patientExerciseData);
  }

  Future getPatientExercises(Patient? patient, int patientId) async {
    final List<Map<String, dynamic>> patientExercisesData =
        await DbHelper.getPatientExercises(patientId);
    for (var element in patientExercisesData) {
      developer.log(element.toString());
    }
    final List<Exercise> patientExercises = [];
    for (var patientExerciseData in patientExercisesData) {
      patientExercises.add(Exercise(
        id: patientExerciseData['id'],
        name: patientExerciseData['name'],
        description: patientExerciseData['description'],
      ));
    }
    return patientExercises;
  }

  Future getPatients() async {
    final List<Map<String, dynamic>> patientsData =
        await DbHelper.getData('patients');
    final List<Patient> patients = [];
    for (var patientData in patientsData) {
      patients.add(Patient(
        id: patientData['id'],
        name: patientData['name'],
        age: patientData['age'],
        disease: patientData['disease'],
        isActive: patientData['isActive'],
      ));
    }
    patientsList.value = patients;
    return patientsList;
  }

  Future getActivePatients() async {
    final List<Map<String, dynamic>> patientsData =
        await DbHelper.getActivePatients();
    final List<Patient> patients = [];
    for (var patientData in patientsData) {
      patients.add(Patient(
        id: patientData['id'],
        name: patientData['name'],
        age: patientData['age'],
        disease: patientData['disease'],
        isActive: patientData['isActive'],
      ));
    }
    activePatientsList.value = patients;
  }

  Future deletePatient(int id) async {
    await DbHelper.delete('patients', id);
    getActivePatients();
    getPatients();
  }

  Future updatePatient(int? id, Patient? patient) async {
    await DbHelper.update('patients', patient!.toMap(), id);
    getActivePatients();
    getPatients();
  }

  Future setPatientActive(int id, int isActive) async {
    await DbHelper.setPatientIsActive(id, isActive);
    getActivePatients();
    getPatients();
  }
}
