import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/exercise_controller.dart';
import 'package:my_patients_sql/views/update_exercise_screen.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({Key? key}) : super(key: key);

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  ExerciseController exerciseController = Get.put(ExerciseController());
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exerciseController.getExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 5.0),
            child: SearchBar(
              elevation: MaterialStateProperty.all(2.0),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 231, 231, 231)),
              textStyle: MaterialStateTextStyle.resolveWith(
                  (states) => const TextStyle(color: Colors.black54)),
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              leading: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black54,
              ),
              hintText: "Rechercher un exercice",
              hintStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                (states) {
                  return const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (exerciseController.exercises.isEmpty) {
                return const Center(child: Text('Aucun exercice trouvé'));
              } else {
                return ListView.builder(
                  itemCount: exerciseController.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exerciseController.exercises[index];
                    if (searchText.isEmpty ||
                        exercise.name
                            .toLowerCase()
                            .contains(searchText.toLowerCase())) {
                      return Dismissible(
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            return await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                  icon: const Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  title: const Text('Supprimer'),
                                  content: const Text(
                                      'Voulez-vous supprimer cet exercice?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('NON'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        exerciseController
                                            .deleteExercise(exercise.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            showCloseIcon: true,
                                            behavior: SnackBarBehavior.floating,
                                            closeIconColor: Colors.white,
                                            content: Text('Exercice supprimé'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('OUI'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateExercisePage(
                                  index: index,
                                  exercise: exercise,
                                ),
                              ),
                            );
                          }
                          return false;
                        },
                        key: UniqueKey(),
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
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 1, right: 1),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(exercise.name),
                              subtitle:
                                  Text("Description: ${exercise.description}"),
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox(); // Return an empty SizedBox for non-matching items
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
