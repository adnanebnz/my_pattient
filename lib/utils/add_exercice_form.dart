import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/models/exercise.dart';

class AddExerciceForm extends StatefulWidget {
  const AddExerciceForm({super.key});

  @override
  State<AddExerciceForm> createState() => _AddExerciceFormState();
}

class _AddExerciceFormState extends State<AddExerciceForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _exerciceFormKey = GlobalKey<FormState>();
  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ Obligatoire';
    }
    return null;
  }

  ExerciseController exerciseController = Get.put(ExerciseController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _exerciceFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nom de l\'exercice'),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.sports_gymnastics_outlined),
            ),
            controller: _nameController,
            validator: _fieldValidator,
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Text('Description de l\'exercice'),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.description_outlined),
            ),
            controller: _descriptionController,
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
                  if (_exerciceFormKey.currentState!.validate()) {
                    Exercise newExercise = Exercise(
                      id: null,
                      name: _nameController.text,
                      description: _descriptionController.text,
                    );

                    exerciseController.insertExercise(newExercise);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        showCloseIcon: true,
                        closeIconColor: Colors.white,
                        content: Text('Exercice ajouté avec succès'),
                      ),
                    );
                    Navigator.of(context).pop();
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
