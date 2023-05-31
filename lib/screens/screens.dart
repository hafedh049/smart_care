import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/chats_screen.dart';
import 'package:smart_care/screens/patient/historic.dart' as patient_historic;
import 'package:smart_care/screens/patient/home.dart' as patient_home;
import 'package:smart_care/screens/doctor/home.dart' as doctor_home;
import 'package:smart_care/screens/laboratory/home.dart' as laboratory_home;
import 'package:smart_care/screens/patient/workflow.dart' as patient_workflow;
import 'package:smart_care/screens/admin/dashboard.dart' as admin_dashboard;
import 'package:smart_care/screens/admin/add_user.dart' as admin_add_user;
import 'package:smart_care/screens/admin/patients_list.dart' as admin_patients_list;
import 'package:smart_care/screens/admin/doctors_list.dart' as admin_doctors_list;
import 'package:smart_care/screens/super_admin/home.dart' as super_admin_home;
import 'package:smart_care/stuff/classes.dart';

import '../stuff/globals.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _screensController = PageController();
  final List<Map<String, dynamic>> _patientScreens = const <Map<String, dynamic>>[
    <String, dynamic>{"screen": patient_home.Home(), "icon": FontAwesomeIcons.house},
    <String, dynamic>{"screen": patient_workflow.WorkFlow(), "icon": FontAwesomeIcons.sheetPlastic},
    <String, dynamic>{"screen": ChatsScreen(user: "patient"), "icon": FontAwesomeIcons.solidMessage},
    <String, dynamic>{"screen": patient_historic.Historic(), "icon": FontAwesomeIcons.solidFolder},
  ];
  final List<Map<String, dynamic>> _doctorScreens = const <Map<String, dynamic>>[
    <String, dynamic>{"screen": doctor_home.Home(), "icon": FontAwesomeIcons.house},
    <String, dynamic>{"screen": ChatsScreen(user: "doctor"), "icon": FontAwesomeIcons.solidMessage},
  ];
  final List<Map<String, dynamic>> _adminScreens = const <Map<String, dynamic>>[
    <String, dynamic>{"screen": admin_dashboard.Dashboard(), "icon": FontAwesomeIcons.chartGantt},
    <String, dynamic>{"screen": admin_add_user.AddUser(), "icon": FontAwesomeIcons.userPlus},
    <String, dynamic>{"screen": admin_patients_list.PatientsList(), "icon": FontAwesomeIcons.userInjured},
    <String, dynamic>{"screen": admin_doctors_list.DoctorsList(), "icon": FontAwesomeIcons.userDoctor},
  ];
  final List<Map<String, dynamic>> _laboratoryScreens = const <Map<String, dynamic>>[
    <String, dynamic>{"screen": laboratory_home.Home(), "icon": FontAwesomeIcons.house},
  ];
  final List<Map<String, dynamic>> _superAdminScreens = const <Map<String, dynamic>>[
    <String, dynamic>{"screen": super_admin_home.Home(), "icon": FontAwesomeIcons.house},
  ];

  final GlobalKey _screensKey = GlobalKey();

  int _activeIndex = 0;

  @override
  void dispose() {
    _screensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: drawerScaffoldKey,
        drawer: const HealthDrawer(),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              me = snapshot.data!.data()!;
              me["token"] = userToken;
              final List<Map<String, dynamic>> filteredScreens = me["role"] == "laboratory"
                  ? _laboratoryScreens
                  : me["role"] == "patient"
                      ? _patientScreens
                      : me["role"] == "doctor"
                          ? _doctorScreens
                          : me["role"] == "super_admin"
                              ? _superAdminScreens
                              : _adminScreens;
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return PageView(
                              physics: _activeIndex == 2 ? const NeverScrollableScrollPhysics() : null,
                              onPageChanged: (int page) {
                                _screensKey.currentState!.setState(() => _activeIndex = page);
                                if (_activeIndex == 2) {
                                  _(() {});
                                }
                              },
                              controller: _screensController,
                              children: filteredScreens.map((Map<String, dynamic> page) => page["screen"] as Widget).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            drawerScaffoldKey.currentState!.openDrawer();
                          },
                          child: Container(width: 40, height: 40, decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)), child: const Icon(FontAwesomeIcons.ellipsisVertical, size: 15, color: grey)),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(color: grey.withOpacity(.4), borderRadius: BorderRadius.circular(25)),
                          height: 60,
                          padding: const EdgeInsets.all(8),
                          child: StatefulBuilder(
                            key: _screensKey,
                            builder: (BuildContext context, void Function(void Function()) setS) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  for (int screen = 0; screen < filteredScreens.length; screen++)
                                    CustomIcon(
                                      clicked: _activeIndex == screen ? true : false,
                                      func: () {
                                        setS(() {
                                          _activeIndex = screen;
                                          _screensController.jumpToPage(screen);
                                        });
                                      },
                                      icon: filteredScreens[screen]["icon"],
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) => AnimatedContainer(duration: 700.ms, height: MediaQuery.of(context).padding.bottom > 0 ? 40 : 20)),
                    ],
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: blue));
            } else {
              return ErrorRoom(error: snapshot.error.toString());
            }
          },
        ),
      ),
    );
  }
}
