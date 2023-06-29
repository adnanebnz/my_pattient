import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/models/exercise.dart';

class UpdateExerciceForm extends StatefulWidget {
  const UpdateExerciceForm(
      {super.key, required this.index, required this.exercise});
  final int index;
  final Exercise exercise;

  @override
  State<UpdateExerciceForm> createState() => _UpdateExerciceFormState();
}

class _UpdateExerciceFormState extends State<UpdateExerciceForm> {
  // ignore: prefer_typing_uninitialized_variables
  late final _nameController;
  // ignore: prefer_typing_uninitialized_variables
  late final _descriptionController;
  final _exerciceFormKey = GlobalKey<FormState>();
  ExerciseController exerciseController = Get.put(ExerciseController());
  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ Obligatoire';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise.name);
    _descriptionController =
        TextEditingController(text: widget.exercise.description);
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
          const SizedBox(
            height: 24.0,
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
                    try {
                      Exercise newExercise = Exercise(
                        id: widget.exercise.id,
                        name: _nameController.text,
                        description: _descriptionController.text,
                      );
                      exerciseController.updateExercise(
                          widget.exercise.id, newExercise);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          showCloseIcon: true,
                          behavior: SnackBarBehavior.floating,
                          closeIconColor: Colors.white,
                          content: Text('Exercice modifié avec succès'),
                        ),
                      );
                      // ignore: empty_catches
                    } catch (e) {}
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
