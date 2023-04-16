import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/doctor/chats.dart' as doctor_chat;
import 'package:smart_care/screens/patient/chats.dart' as patient_chat;
import 'package:smart_care/screens/patient/historic.dart' as patient_historic;
import 'package:smart_care/screens/patient/home.dart' as patient_home;
import 'package:smart_care/screens/doctor/home.dart' as doctor_home;
import 'package:smart_care/screens/patient/upload.dart' as patient_upload;
import 'package:smart_care/screens/patient/workflow.dart' as patient_workflow;
import 'package:smart_care/screens/admin/dashboard.dart' as admin_dashboard;
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/functions.dart';

import '../stuff/globals.dart';

class Screens extends StatefulWidget {
  const Screens({super.key, required this.firstScreen});
  final int firstScreen;

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  late final GlobalKey<ScaffoldState> drawerScaffoldKey;
  late final PageController _screensController;
  final List<Map<String, dynamic>> _screens = <Map<String, dynamic>>[
    {"screen": const patient_home.Home(), "icon": FontAwesomeIcons.house, "role": "patient"},
    {"screen": const doctor_home.Home(), "icon": FontAwesomeIcons.house, "role": "doctor"},
    {"screen": const patient_upload.Upload(), "icon": FontAwesomeIcons.camera, "role": "patient"},
    {"screen": const patient_workflow.WorkFlow(), "icon": FontAwesomeIcons.sheetPlastic, "role": "patient"},
    {"screen": const patient_chat.Chats(), "icon": FontAwesomeIcons.solidMessage, "role": "patient"},
    {"screen": const doctor_chat.Chats(), "icon": FontAwesomeIcons.solidMessage, "role": "doctor"},
    {"screen": const patient_historic.Historic(), "icon": FontAwesomeIcons.solidFolder, "role": "patient"},
    {"screen": const admin_dashboard.Dashboard(), "icon": FontAwesomeIcons.chartGantt, "role": "admin"},
  ];
  List<Map<String, dynamic>> _filteredScreens = <Map<String, dynamic>>[];
  final GlobalKey _screensKey = GlobalKey();
  int _activeIndex = 0;

  @override
  void dispose() {
    _screensController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getToken();
    drawerScaffoldKey = GlobalKey<ScaffoldState>();
    _screensController = PageController();
    if (_screensController.hasClients) {
      _screensController.jumpToPage(widget.firstScreen);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: drawerScaffoldKey,
        drawer: const HealthDrawer(),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              me = snapshot.data!.data()!;
              me["token"] = userToken;
              _filteredScreens = _screens.where((Map<String, dynamic> item) => item["role"] == snapshot.data!.get("role")).toList();
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) _) {
                          return PageView(
                            physics: _activeIndex == 2 ? const NeverScrollableScrollPhysics() : null,
                            onPageChanged: (int page) {
                              _screensKey.currentState!.setState(() => _activeIndex = page);
                              if (_activeIndex == 2) {
                                _(() {});
                              }
                            },
                            controller: _screensController,
                            children: _filteredScreens.map((Map<String, dynamic> page) => page["screen"] as Widget).toList(),
                          );
                        }),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            drawerScaffoldKey.currentState!.openDrawer();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                            child: const Icon(FontAwesomeIcons.ellipsisVertical, size: 15, color: grey),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(color: const Color.fromARGB(255, 41, 41, 41), borderRadius: BorderRadius.circular(25)),
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          child: StatefulBuilder(
                            key: _screensKey,
                            builder: (BuildContext context, void Function(void Function()) setS) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  for (int screen = 0; screen < _filteredScreens.length; screen++)
                                    CustomIcon(
                                      clicked: _activeIndex == screen ? true : false,
                                      func: () {
                                        setS(() {
                                          _activeIndex = screen;
                                          _screensController.jumpToPage(screen);
                                        });
                                      },
                                      icon: _filteredScreens[screen]["icon"],
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
              return const Center(
                child: CircularProgressIndicator(color: blue),
              );
            } else {
              return ErrorRoom(error: snapshot.error.toString());
            }
          },
        ),
      ),
    );
  }
}
