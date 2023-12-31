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
                          Expanded(
                            child: Obx(() {
                              if (patientController.patientsList.isEmpty) {
                                return const Center(
                                  child: Text("Aucun patient trouvé", style: TextStyle(fontFamily: 'Poppins')),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount:
                                        patientController.patientsList.length,
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
                                                      title: const Text(
                                                        'Supprimer',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      content: const Text(
                                                        'Voulez-vous supprimer ce patient?',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    false),
                                                            child: const Text(
                                                              'NON',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins'),
                                                            )),
                                                        TextButton(
                                                            onPressed: () => {
                                                                  patientController.deletePatient(
                                                                      patientController
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
                                                                    content:
                                                                        Text(
                                                                      'Patient supprimé',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Poppins'),
                                                                    ),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            2),
                                                                  )),
                                                                  Navigator.pop(
                                                                      context,
                                                                      true)
                                                                },
                                                            child: const Text(
                                                              'OUI',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins'),
                                                            )),
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
                                                              patient:
                                                                  patientController
                                                                          .patientsList[
                                                                      index])));
                                              return false;
                                            }
                                          },
                                          secondaryBackground: Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(
                                                right: 15),
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
                                                      BorderRadius.circular(
                                                          10)),
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
                                                            patientController
                                                                    .patientsList[
                                                                        index]
                                                                    .name +
                                                                " / " +
                                                                patientController
                                                                    .patientsList[
                                                                        index]
                                                                    .age
                                                                    .toString() +
                                                                " ans",
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
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
                                                                        top:
                                                                            8.0),
                                                                child: Text(
                                                                  "Présent?",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                              Switch.adaptive(
                                                                activeColor:
                                                                    Colors
                                                                        .green,
                                                                value: patientController
                                                                        .patientsList[
                                                                            index]
                                                                        .isActive ==
                                                                    1,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    patientController
                                                                            .patientsList[
                                                                                index]
                                                                            .isActive =
                                                                        value
                                                                            ? 1
                                                                            : 0;
                                                                    if (patientController
                                                                            .patientsList[index]
                                                                            .isActive ==
                                                                        1) {
                                                                      patientController.setPatientActive(
                                                                          patientController
                                                                              .patientsList[index]
                                                                              .id,
                                                                          1);
                                                                    } else {
                                                                      patientController.setPatientActive(
                                                                          patientController
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0.0,
                                                                12.0,
                                                                0.0,
                                                                12.0),
                                                        child: Text(
                                                            "Maladie: ${patientController.patientsList[index].disease}",
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
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
                                      return const SizedBox();
                                    });
                              }
                            }),
                          ),
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
