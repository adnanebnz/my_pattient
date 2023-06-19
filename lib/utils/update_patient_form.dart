import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'package:my_patients_sql/views/add_exercises_to_patients_screen.dart';
import '../models/patient.dart';
import "dart:developer" as developer show log;

class UpdatePersonForm extends StatefulWidget {
  const UpdatePersonForm(
      {super.key, required this.index, required this.patient});
  final int index;
  final Patient patient;
  @override
  State<UpdatePersonForm> createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<UpdatePersonForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _diseaseController;
  late final GlobalKey<FormState> _patientFormKey = GlobalKey<FormState>();

  ExerciseController exerciseController = Get.put(ExerciseController());
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
    _nameController = TextEditingController(text: widget.patient.name);
    _ageController = TextEditingController(text: widget.patient.age.toString());
    _diseaseController = TextEditingController(text: widget.patient.disease);
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
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_patientFormKey.currentState!.validate()) {
                    try {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return AddExercisesToPatientPage(
                            patient: widget.patient);
                      }));
                    } catch (e) {
                      developer.log(e.toString(), name: "ERROR");
                    }
                  }
                },
                child: const Text('Ajouter des exercices'),
              ),
            ),
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
                      Patient editedPatient = Patient(
                          id: widget.patient.id,
                          name: _nameController.text,
                          age: int.parse(_ageController.text),
                          disease: _diseaseController.text,
                          isActive: widget.patient.isActive);
                      patientController.updatePatient(
                          widget.patient.id, editedPatient);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          closeIconColor: Colors.white,
                          showCloseIcon: true,
                          content: Text('Patient modifié avec succès'),
                        ),
                      );
                    } catch (e) {
                      developer.log(e.toString(), name: "ERROR");
                    }
                  }
                },
                child: const Text('Modifier'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
