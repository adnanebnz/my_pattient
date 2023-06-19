import 'package:get/state_manager.dart';
import 'package:my_patients_sql/db/db_helper.dart';
import 'package:my_patients_sql/models/patient.dart';

class PatientController extends GetxController {
  RxList patientsList = <Patient>[].obs;
  RxList activePatientsList = <Patient>[].obs;

  Future insertPatient(Patient? patient) async {
    await DbHelper.insert('patients', patient!.toMap());
    getActivePatients();
    getPatients();
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
