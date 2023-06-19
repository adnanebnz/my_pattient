import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/views/update_exercise_screen.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  ExerciseController exerciseController = Get.put(ExerciseController());

  @override
  void initState() {
    super.initState();
    exerciseController.getExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetX<ExerciseController>(builder: (controller) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.exercises.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      return await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              icon: const Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 30,
                              ),
                              title: const Text('Supprimer'),
                              content: const Text(
                                  'Voulez-vous supprimer cet exercise?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('NON')),
                                TextButton(
                                    onPressed: () => {
                                          exerciseController.deleteExercise(
                                              exerciseController
                                                  .exercises[index].id),
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            showCloseIcon: true,
                                            behavior: SnackBarBehavior.floating,
                                            closeIconColor: Colors.white,
                                            content: Text('Exercise supprimé'),
                                            duration: Duration(seconds: 2),
                                          )),
                                          Navigator.pop(context, true)
                                        },
                                    child: const Text('OUI')),
                              ],
                            );
                          });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateExercisePage(
                                  index: index,
                                  exercise: controller.exercises[index])));
                      return false;
                    }
                  },
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 15),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    color: Colors.green,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  key: UniqueKey(),
                  child: Card(
                      child: ListTile(
                    title: Text(controller.exercises[index].name),
                    // ignore: prefer_interpolation_to_compose_strings
                    subtitle: Text("Description: " +
                        controller.exercises[index].description),
                  )),
                );
              },
            ),
          ),
        ],
      );
    }));
  }
}
