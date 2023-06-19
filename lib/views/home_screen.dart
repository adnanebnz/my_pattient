import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:my_patients_sql/controllers/patient_controller.dart';
import 'package:my_patients_sql/views/active_patients_screen.dart';
import 'package:my_patients_sql/views/add_exercice_screen.dart';
import 'package:my_patients_sql/views/add_patient_screen.dart';
import 'package:my_patients_sql/views/exercise_list_screen.dart';
import 'package:my_patients_sql/views/update_patient_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool value = false;
  String searchText = '';
  final _nameController = TextEditingController();
  PatientController patientController = Get.put(PatientController());
  @override
  void initState() {
    super.initState();
    patientController.getPatients();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Acceuil'),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            tabs: [
              Tab(
                icon: Icon(Icons.list),
                text: 'Mes patients',
              ),
              Tab(
                icon: Icon(Icons.checklist_rtl),
                text: 'Patients présents',
              ),
              Tab(
                icon: Icon(Icons.sports_gymnastics),
                text: 'Exercises',
              )
            ],
          ),
        ),
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                      body: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 12.0, 12.0, 5.0),
                            child: SearchBar(
                              elevation: MaterialStateProperty.all(2.0),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromARGB(255, 231, 231, 231)),
                              textStyle: MaterialStateTextStyle.resolveWith(
                                  (states) =>
                                      const TextStyle(color: Colors.black54)),
                              controller: _nameController,
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
                              hintText: "Rechercher un patient",
                              hintStyle:
                                  MaterialStateProperty.resolveWith<TextStyle?>(
                                (states) {
                                  return const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  );
                                },
                              ),
                            ),
                          ),
                          // display the list of patients
                          Expanded(
                            child:
                                GetX<PatientController>(builder: (controller) {
                              return ListView.builder(
                                  itemCount: controller.patientsList.length,
                                  itemBuilder: (context, index) {
                                    if (searchText.isEmpty ||
                                        patientController
                                            .patientsList[index].name
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        patientController
                                            .patientsList[index].age
                                            .toString()
                                            .contains(searchText)) {
                                      return Dismissible(
                                        confirmDismiss: (direction) async {
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            return await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    elevation: 5,
                                                    icon: const Icon(
                                                      Icons.warning,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ),
                                                    title:
                                                        const Text('Supprimer'),
                                                    content: const Text(
                                                        'Voulez-vous supprimer ce patient?'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false),
                                                          child: const Text(
                                                              'NON')),
                                                      TextButton(
                                                          onPressed: () => {
                                                                patientController
                                                                    .deletePatient(controller
                                                                        .patientsList[
                                                                            index]
                                                                        .id),
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  showCloseIcon:
                                                                      true,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  closeIconColor:
                                                                      Colors
                                                                          .white,
                                                                  content: Text(
                                                                      'Patient supprimé'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                )),
                                                                Navigator.pop(
                                                                    context,
                                                                    true)
                                                              },
                                                          child: const Text(
                                                              'OUI')),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdatePatientPage(
                                                            index: index,
                                                            patient: controller
                                                                    .patientsList[
                                                                index])));
                                            return false;
                                          }
                                        },
                                        secondaryBackground: Container(
                                          alignment: Alignment.centerRight,
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          color: Colors.red,
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        background: Container(
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          color: Colors.green,
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        key: UniqueKey(),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 1, right: 1),
                                          child: Card(
                                            surfaceTintColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            elevation: 4,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          controller
                                                                  .patientsList[
                                                                      index]
                                                                  .name +
                                                              " / " +
                                                              controller
                                                                  .patientsList[
                                                                      index]
                                                                  .age
                                                                  .toString() +
                                                              " ans",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Column(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 8.0),
                                                              child: Text(
                                                                "Présent?",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                            Switch.adaptive(
                                                              activeColor:
                                                                  Colors.green,
                                                              value: controller
                                                                      .patientsList[
                                                                          index]
                                                                      .isActive ==
                                                                  1,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  controller
                                                                          .patientsList[
                                                                              index]
                                                                          .isActive =
                                                                      value
                                                                          ? 1
                                                                          : 0;
                                                                  if (controller
                                                                          .patientsList[
                                                                              index]
                                                                          .isActive ==
                                                                      1) {
                                                                    controller.setPatientActive(
                                                                        controller
                                                                            .patientsList[index]
                                                                            .id,
                                                                        1);
                                                                  } else {
                                                                    controller.setPatientActive(
                                                                        controller
                                                                            .patientsList[index]
                                                                            .id,
                                                                        0);
                                                                  }
                                                                });
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const Divider(
                                                      height: 0,
                                                      thickness: 1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0.0, 12.0, 0.0, 12.0),
                                                      child: Text(
                                                          "Maladie: ${controller.patientsList[index].disease}",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black87)),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      );
                                    }
                                    return null;
                                  });
                            }),
                          )
                        ],
                      ),
                      floatingActionButton: SpeedDial(
                        animatedIcon: AnimatedIcons.menu_close,
                        backgroundColor: Colors.green,
                        children: [
                          SpeedDialChild(
                            child: const Icon(Icons.add),
                            label: "Ajouter un patient",
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddPatientPage())),
                          ),
                          SpeedDialChild(
                            child: const Icon(Icons.add),
                            label: "Ajouter un Exercice",
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddExercicePage())),
                          ),
                        ],
                      ))),
              const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: ActivePatientsPage(),
              ),
              const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: ExerciseListPage(),
              )
            ]),
      ),
    );
  }
}
