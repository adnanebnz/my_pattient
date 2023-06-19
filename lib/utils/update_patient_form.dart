import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'package:my_patients_sql/models/exercise.dart';
import '../models/patient.dart';

class UpdatePersonForm extends StatefulWidget {
  const UpdatePersonForm(
      {super.key, required this.index, required this.patient});
  final int index;
  final Patient patient;
  @override
  State<UpdatePersonForm> createState() => _AddPersonFormState();
}

class _AddPersonFormState extends State<UpdatePersonForm> {
  // ignore: prefer_typing_uninitialized_variables
  late final _nameController;
  // ignore: prefer_typing_uninitialized_variables
  late final _ageController;
  // ignore: prefer_typing_uninitialized_variables
  late final _diseaseController;
  final _patientFormKey = GlobalKey<FormState>();

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
          Expanded(
            child: GetX<ExerciseController>(builder: ((controller) {
              return ListView.builder(
                itemCount: controller.exercises.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(controller.exercises[index].name),
                      subtitle: Text(controller.exercises[index].description),
                      trailing: Checkbox(
                        value: selectedExercises
                            .contains(controller.exercises[index]),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedExercises
                                  .add(controller.exercises[index]);
                            } else {
                              selectedExercises
                                  .remove(controller.exercises[index]);
                            }
                          });
                        },
                      ));
                },
              );
            })),
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
