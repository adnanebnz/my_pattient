import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'package:my_patients_sql/models/exercise.dart';
import 'package:my_patients_sql/models/patient.dart';
import "dart:developer" as developer show log;

class AddPersonForm extends StatefulWidget {
  const AddPersonForm({super.key});

  @override
  State<AddPersonForm> createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<AddPersonForm> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _patientFormKey = GlobalKey<FormState>();
  bool addExercise = false;
  List<Exercise> selectedExercises = [];
  PatientController patientController = Get.put(PatientController());
  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ Obligatoire';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _patientFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nom et prénom'),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_2_outlined),
            ),
            controller: _nameController,
            validator: _fieldValidator,
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Text('Age'),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_2_outlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _ageController,
            validator: _fieldValidator,
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Text('Maladie'),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.sick_outlined),
            ),
            controller: _diseaseController,
            validator: _fieldValidator,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 24.0),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_patientFormKey.currentState!.validate()) {
                    try {
                      final patient = Patient(
                        id: null,
                        isActive: 0,
                        name: _nameController.text,
                        age: int.parse(_ageController.text),
                        disease: _diseaseController.text,
                        exercises: selectedExercises,
                      );

                      patientController.insertPatient(patient);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          showCloseIcon: true,
                          closeIconColor: Colors.white,
                          content: Text('Patient ajoutée avec succès'),
                        ),
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      developer.log(e.toString());
                    }
                  }
                },
                child: const Text('Sauvgarder'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
